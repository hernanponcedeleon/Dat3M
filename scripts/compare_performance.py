#!/usr/bin/env python3
"""Compare Dartagnan execution times for two repository revisions."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import fnmatch
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
        required_keys = {"directory", "include", "runs", "configurations"}
        missing_keys = required_keys - entry.keys()
        if missing_keys:
            raise ValueError("Benchmark entry is missing: " + ", ".join(sorted(missing_keys)))
        if not isinstance(entry["directory"], str):
            raise ValueError("Benchmark directory must be a string")
        if not isinstance(entry["runs"], int) or isinstance(entry["runs"], bool) or entry["runs"] < 1:
            raise ValueError("Benchmark runs must be a positive integer")
        if not isinstance(entry["include"], list) or not entry["include"] or not all(isinstance(pattern, str) for pattern in entry["include"]):
            raise ValueError("Benchmark include must be a non-empty list of strings")
        folder_excludes = entry.get("exclude", [])
        if not isinstance(folder_excludes, list) or not all(isinstance(pattern, str) for pattern in folder_excludes):
            raise ValueError("Benchmark exclude must be a list of strings")

        directory = Path(entry["directory"])
        if directory.is_absolute() or ".." in directory.parts:
            raise ValueError(f"Benchmark directory must be a repository-relative path: {directory}")
        includes = entry["include"]
        configurations = entry["configurations"]
        if not isinstance(configurations, list) or not configurations:
            raise ValueError("Benchmark configurations must be a non-empty list")
        for configuration in configurations:
            if not isinstance(configuration, dict) or not {"cat", "target"} <= configuration.keys() \
                    or configuration.keys() - {"cat", "target", "exclude"}:
                raise ValueError("Each benchmark configuration must contain a cat file and target")
            if not isinstance(configuration["cat"], str) or not isinstance(configuration["target"], str):
                raise ValueError("Benchmark configuration cat and target must be strings")
            configuration_excludes = configuration.get("exclude", [])
            if not isinstance(configuration_excludes, list) or not all(isinstance(pattern, str) for pattern in configuration_excludes):
                raise ValueError("Benchmark configuration exclude must be a list of strings")

        root = benchmark_path.parent.parent / directory
        if not root.is_dir():
            raise ValueError(f"Benchmark directory does not exist: {directory}")
        for source in sorted(path for path in root.rglob("*") if path.is_file()):
            relative_path = source.relative_to(benchmark_path.parent.parent)
            relative_to_directory = source.relative_to(root)
            if not any(fnmatch.fnmatch(relative_to_directory.as_posix(), pattern) for pattern in includes):
                continue
            if any(fnmatch.fnmatch(relative_to_directory.as_posix(), pattern) for pattern in folder_excludes):
                continue
            for configuration in configurations:
                if any(fnmatch.fnmatch(relative_to_directory.as_posix(), pattern)
                       for pattern in configuration.get("exclude", [])):
                    continue
                benchmarks.append({
                    "name": relative_path.as_posix(),
                    "program": relative_path.as_posix(),
                    "runs": entry["runs"],
                    "cat": configuration["cat"],
                    "target": configuration["target"],
                })
    if not benchmarks:
        raise ValueError("Benchmark file selects no benchmarks")
    validate_benchmarks(benchmarks)
    return benchmarks


def validate_benchmarks(benchmarks):
    seen_benchmarks = set()
    for benchmark in benchmarks:
        benchmark_key = (benchmark["program"], benchmark["cat"], benchmark["target"])
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


def run_benchmark(revision_dir, benchmark, run, timeout):
    executable = revision_dir / "dartagnan" / "target" / "dartagnan"
    command = [
        str(executable),
        benchmark["cat"],
        f"--target={benchmark['target']}",
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
                return timeout
    return parse_time(completed.stdout + completed.stderr)


def summarize(values):
    return {
        "average": statistics.mean(values),
        "standard_deviation": statistics.stdev(values) if len(values) > 1 else 0.0,
    }


def percent_change(base, head):
    return (head - base) / base * 100 if base else math.inf


def measure_benchmark(benchmark, base_checkout, head_checkout, timeout):
    measurements = []
    base_times = []
    head_times = []
    for run in range(benchmark["runs"]):
        revisions = (("base", base_checkout, base_times), ("head", head_checkout, head_times))
        # Alternate the measurement order to avoid consistently favoring the revision that runs first.
        for revision, directory, times in (revisions if run % 2 == 0 else reversed(revisions)):
            time = run_benchmark(directory, benchmark, run + 1, timeout)
            times.append(time)
            measurements.append({"benchmark": benchmark["name"], "revision": revision, "run": run + 1, "seconds": time})
    base = summarize(base_times)
    head = summarize(head_times)
    return {
        "benchmark": benchmark["name"],
        "memory_model": Path(benchmark["cat"]).stem,
        "runs": benchmark["runs"],
        "base": base,
        "head": head,
        "change": percent_change(base["average"], head["average"]),
    }, measurements


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
            "| Benchmark | Base branch | PR branch | Change |",
            "|---|---:|---:|---:|",
        ])
        for row in memory_model_rows:
            change = row["change"]
            marker = "❌" if change > 0 else "✅" if change < 0 else "➖"
            lines.append(
                f"| `{row['benchmark']}` | {row['base']['average']:.3f} ± {row['base']['standard_deviation']:.3f} s "
                f"| {row['head']['average']:.3f} ± {row['head']['standard_deviation']:.3f} s | {marker} {abs(change):.1f}% |"
            )
    if not visible_rows:
        lines.append("| _No benchmark met the reporting threshold_ | — | — | — |")
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
