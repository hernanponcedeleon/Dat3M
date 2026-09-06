#!/usr/bin/env python3
"""Compare Dartagnan execution times for two repository revisions."""

import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import json
import math
import os
from pathlib import Path
import re
import statistics
import subprocess
import sys

import yaml


MAX_TIMEOUT_ATTEMPTS = 3


TIME_PATTERN = re.compile(r"^Time:\s+(?:(?P<minutes>\d+):)?(?P<seconds>\d+(?:\.\d+)?)\s+(?:secs|mins)\s*$", re.MULTILINE)
RESULT_PATTERN = re.compile(r"^Result:\s+(?P<result>\S+)\s*$", re.MULTILINE)


def parse_arguments():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--benchmarks", type=Path, required=True)
    parser.add_argument("--base-checkout", type=Path, required=True)
    parser.add_argument("--head-checkout", type=Path, required=True)
    parser.add_argument("--timeout", type=float, required=True, help="timeout for one verification run in seconds")
    parser.add_argument("--jobs", type=int, required=True, help="number of benchmark runs to execute in parallel")
    parser.add_argument("--min-average-seconds", type=float, required=True)
    parser.add_argument("--markdown", type=Path, required=True)
    parser.add_argument("--json", type=Path, required=True)
    arguments = parser.parse_args()
    if arguments.min_average_seconds < 0:
        parser.error("--min-average-seconds must not be negative")
    if arguments.timeout <= 0:
        parser.error("--timeout must be positive")
    if arguments.jobs < 1:
        parser.error("--jobs must be positive")
    return arguments


def load_benchmarks(benchmark_path):
    with benchmark_path.open(encoding="utf-8") as benchmark_file:
        benchmark_selection = yaml.safe_load(benchmark_file)
    if not isinstance(benchmark_selection, dict) or not isinstance(benchmark_selection.get("benchmarks"), list):
        raise ValueError("Benchmark file must contain a 'benchmarks' list")

    benchmarks = []
    for entry in benchmark_selection["benchmarks"]:
        if not isinstance(entry, dict):
            raise ValueError("Each performance benchmark entry must be a mapping")
        required_keys = {"program", "runs", "configurations"}
        missing_keys = required_keys - entry.keys()
        if missing_keys:
            raise ValueError("Benchmark entry is missing: " + ", ".join(sorted(missing_keys)))
        if entry.keys() - {"program", "runs", "options", "configurations"}:
            raise ValueError("Benchmark entry contains unsupported keys")
        if not isinstance(entry["program"], str):
            raise ValueError("Benchmark program must be a string")
        if not isinstance(entry["runs"], int) or isinstance(entry["runs"], bool) or entry["runs"] < 1:
            raise ValueError("Benchmark runs must be a positive integer")
        shared_options = entry.get("options", [])
        if not isinstance(shared_options, list) or not all(isinstance(option, str) for option in shared_options):
            raise ValueError("Benchmark options must be a list of strings")
        program = Path(entry["program"])
        if program.is_absolute() or ".." in program.parts:
            raise ValueError(f"Benchmark program must be a repository-relative path: {program}")
        if not (benchmark_path.parent.parent / program).is_file():
            raise ValueError(f"Benchmark program does not exist: {program}")
        configurations = entry["configurations"]
        if not isinstance(configurations, list) or not configurations:
            raise ValueError("Benchmark configurations must be a non-empty list")
        for configuration in configurations:
            if not isinstance(configuration, dict) or not {"cat", "target"} <= configuration.keys() \
                    or configuration.keys() - {"cat", "target", "options"}:
                raise ValueError("Each benchmark configuration must contain a cat file and target")
            if not isinstance(configuration["cat"], str) or not isinstance(configuration["target"], str):
                raise ValueError("Benchmark configuration cat and target must be strings")
            configuration_options = configuration.get("options", [])
            if not isinstance(configuration_options, list) \
                    or not all(isinstance(option, str) for option in configuration_options):
                raise ValueError("Benchmark configuration options must be a list of strings")
            benchmarks.append({
                "name": program.as_posix(),
                "program": program.as_posix(),
                "runs": entry["runs"],
                "cat": configuration["cat"],
                "target": configuration["target"],
                "options": [*shared_options, *configuration_options],
            })
    if not benchmarks:
        raise ValueError("Benchmark file selects no benchmarks")
    validate_benchmarks(benchmarks)
    return benchmarks


def validate_benchmarks(benchmarks):
    seen_benchmarks = set()
    for benchmark in benchmarks:
        benchmark_key = (benchmark["program"], benchmark["cat"], benchmark["target"], tuple(benchmark["options"]))
        if benchmark_key in seen_benchmarks:
            raise ValueError(
                f"Benchmark is selected more than once: {benchmark['program']} ({benchmark['target']})"
            )
        seen_benchmarks.add(benchmark_key)


def parse_time(output):
    match = TIME_PATTERN.search(output)
    if not match:
        raise ValueError("Dartagnan did not report a verification time")
    return int(match.group("minutes") or 0) * 60 + float(match.group("seconds"))


def parse_result(output):
    match = RESULT_PATTERN.search(output)
    if not match:
        raise ValueError("Dartagnan did not report a verification result")
    return match.group("result")


def run_benchmark(revision_dir, benchmark, run, timeout):
    executable = revision_dir / "dartagnan" / "target" / "dartagnan"
    command = [
        str(executable),
        benchmark["cat"],
        f"--target={benchmark['target']}",
        *benchmark["options"],
        benchmark["program"],
    ]
    environment = os.environ | {
        "DAT3M_HOME": str(revision_dir),
    }
    library_path_variable = "DYLD_LIBRARY_PATH" if sys.platform == "darwin" else "LD_LIBRARY_PATH"
    library_directory = str(revision_dir / "dartagnan" / "target" / "libs")
    environment[library_path_variable] = library_directory + os.pathsep + environment.get(library_path_variable, "")
    for attempt in range(MAX_TIMEOUT_ATTEMPTS):
        output_directory = (
            revision_dir / "output" / "performance" / Path(benchmark["cat"]).stem / benchmark["program"]
            / f"run-{run}" / f"attempt-{attempt + 1}"
        )
        environment["DAT3M_OUTPUT"] = str(output_directory)
        output_directory.mkdir(parents=True, exist_ok=True)
        try:
            completed = subprocess.run(command, cwd=revision_dir, env=environment, text=True, capture_output=True, timeout=timeout)
            break
        except subprocess.TimeoutExpired:
            if attempt == MAX_TIMEOUT_ATTEMPTS - 1:
                print(
                    f"Benchmark timed out {MAX_TIMEOUT_ATTEMPTS} times; recording {timeout:g} seconds: "
                    + " ".join(command),
                    file=sys.stderr,
                )
                return timeout, "TIMEOUT"
    output = completed.stdout + completed.stderr
    return parse_time(output), parse_result(output)


def summarize(values):
    return {
        "average": statistics.mean(values),
        "standard_deviation": statistics.stdev(values) if len(values) > 1 else 0.0,
    }


def summarize_results(results):
    return dict(sorted(Counter(results).items()))


# Two-sided 95% Student-t critical values, indexed by degrees of freedom. Performance
# measurements normally have only a few runs, so the normal-distribution value (1.96)
# would underestimate the confidence interval. For more than 31 runs, 1.96 is a close
# enough approximation.
T_CRITICAL_95 = {
    1: 12.706,
    2: 4.303,
    3: 3.182,
    4: 2.776,
    5: 2.571,
    6: 2.447,
    7: 2.365,
    8: 2.306,
    9: 2.262,
    10: 2.228,
    11: 2.201,
    12: 2.179,
    13: 2.160,
    14: 2.145,
    15: 2.131,
    16: 2.120,
    17: 2.110,
    18: 2.101,
    19: 2.093,
    20: 2.086,
    21: 2.080,
    22: 2.074,
    23: 2.069,
    24: 2.064,
    25: 2.060,
    26: 2.056,
    27: 2.052,
    28: 2.048,
    29: 2.045,
    30: 2.042,
}


def paired_improvement(base_times, head_times):
    """Return the paired relative improvement and its two-sided 95% confidence interval.

    Each base/head pair belongs to the same run and therefore shares much of the
    machine noise. A positive value means that the head revision is faster. The
    interval is used by the report to label a result as an improvement or regression
    only when it does not contain zero.
    """
    improvements = [(base - head) / base * 100 for base, head in zip(base_times, head_times)]
    average = statistics.mean(improvements)
    if len(improvements) < 2:
        return {"average": average, "lower": None, "upper": None}
    standard_error = statistics.stdev(improvements) / math.sqrt(len(improvements))
    critical_value = T_CRITICAL_95.get(len(improvements) - 1, 1.96)
    margin = critical_value * standard_error
    return {"average": average, "lower": average - margin, "upper": average + margin}


def measure_benchmark(benchmark, base_checkout, head_checkout, timeout):
    measurements = []
    base_times = []
    head_times = []
    base_results = []
    head_results = []
    for run in range(benchmark["runs"]):
        revisions = (
            ("base", base_checkout, base_times, base_results),
            ("head", head_checkout, head_times, head_results),
        )
        # Alternate the measurement order to avoid consistently favoring the revision that runs first.
        for revision, directory, times, results in (revisions if run % 2 == 0 else reversed(revisions)):
            time, result = run_benchmark(directory, benchmark, run + 1, timeout)
            times.append(time)
            results.append(result)
            measurements.append({
                "benchmark": benchmark["name"], "revision": revision, "run": run + 1,
                "seconds": time, "result": result,
            })
    base = summarize(base_times)
    head = summarize(head_times)
    return {
        "benchmark": benchmark["name"],
        "memory_model": Path(benchmark["cat"]).stem,
        "runs": benchmark["runs"],
        "base": base,
        "head": head,
        "base_times": base_times,
        "head_times": head_times,
        "results": {"base": summarize_results(base_results), "head": summarize_results(head_results)},
        "improvement": paired_improvement(base_times, head_times),
    }, measurements


def format_improvement(improvement):
    if improvement["lower"] is None:
        return "➖ insufficient data"
    formatted_interval = (
        f"{improvement['average']:+.1f}% [{improvement['lower']:+.1f}%, {improvement['upper']:+.1f}%]"
    )
    if improvement["lower"] > 0:
        return f"✅ {formatted_interval}"
    if improvement["upper"] < 0:
        return f"❌ {formatted_interval}"
    return f"➖ {formatted_interval}"


def common_result(results):
    all_results = set(results["base"]) | set(results["head"])
    return all_results.pop() if len(all_results) == 1 else None


def format_result_counts(result_counts):
    return ", ".join(f"{result} × {count}" for result, count in result_counts.items())


def format_results(results):
    result = common_result(results)
    if result is not None:
        return result
    return f"Base: {format_result_counts(results['base'])}<br>PR: {format_result_counts(results['head'])}"


def summarize_total(rows):
    """Summarize the total verification time of all rows for every paired run."""
    base_times = [sum(times) for times in zip(*(row["base_times"] for row in rows))]
    head_times = [sum(times) for times in zip(*(row["head_times"] for row in rows))]
    result_counts = Counter()
    for row in rows:
        result_counts[common_result(row["results"]) or "MIXED"] += 1
    return {
        "base": summarize(base_times),
        "head": summarize(head_times),
        "result_counts": dict(sorted(result_counts.items())),
        "improvement": paired_improvement(base_times, head_times),
    }


def render_markdown(rows, minimum):
    visible_rows = [row for row in rows if max(row["base"]["average"], row["head"]["average"]) >= minimum]
    lines = [
        "<!-- dat3m-performance-report -->",
        "## Performance comparison",
    ]
    memory_models = {}
    for row in visible_rows:
        memory_models.setdefault(row["memory_model"], []).append(row)
    for memory_model, memory_model_rows in memory_models.items():
        lines.extend([
            "",
            f"### Memory model: {memory_model}",
            "",
            "| Benchmark | Base branch | PR branch | Result | Improvement (95% CI) |",
            "|---|---:|---:|---|---:|",
        ])
        for row in memory_model_rows:
            lines.append(
                f"| `{row['benchmark']}` | {row['base']['average']:.3f} ± {row['base']['standard_deviation']:.3f} s "
                f"| {row['head']['average']:.3f} ± {row['head']['standard_deviation']:.3f} s "
                f"| {format_results(row['results'])} "
                f"| {format_improvement(row['improvement'])} |"
            )
    if visible_rows:
        total = summarize_total(visible_rows)
        lines.extend([
            "",
            "### Total",
            "",
            "| Benchmarks | Base branch | PR branch | Result | Improvement (95% CI) |",
            "|---|---:|---:|---|---:|",
            f"| All reported benchmarks | {total['base']['average']:.3f} ± {total['base']['standard_deviation']:.3f} s "
            f"| {total['head']['average']:.3f} ± {total['head']['standard_deviation']:.3f} s "
            f"| {format_result_counts(total['result_counts'])} "
            f"| {format_improvement(total['improvement'])} |",
        ])
    if not visible_rows:
        lines.append("| _No benchmark met the reporting threshold_ | — | — | — | — |")
    filtered = len(rows) - len(visible_rows)
    if filtered:
        lines.extend(["", f"_{filtered} benchmark(s) omitted because both averages were below {minimum:g} seconds._"])
    return "\n".join(lines) + "\n"


def main():
    arguments = parse_arguments()
    for output_path in (arguments.markdown, arguments.json):
        output_path.parent.mkdir(parents=True, exist_ok=True)
    benchmarks = load_benchmarks(arguments.benchmarks)
    rows = []
    measurements = []
    with ThreadPoolExecutor(max_workers=arguments.jobs) as executor:
        futures = [
            executor.submit(
                measure_benchmark, benchmark, arguments.base_checkout, arguments.head_checkout, arguments.timeout
            )
            for benchmark in benchmarks
        ]
        for future in futures:
            row, benchmark_measurements = future.result()
            rows.append(row)
            measurements.extend(benchmark_measurements)
    arguments.markdown.write_text(render_markdown(rows, arguments.min_average_seconds), encoding="utf-8")
    arguments.json.write_text(json.dumps({"measurements": measurements, "summary": rows}, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError, ValueError, yaml.YAMLError) as error:
        print(f"Performance comparison failed: {error}", file=sys.stderr)
        sys.exit(1)
