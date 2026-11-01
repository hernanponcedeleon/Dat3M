"""Check native mode with each solver supplied by the active Maven profile."""

import os
from pathlib import Path
import re
import subprocess
import sys
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[2]
TARGET = ROOT / "dartagnan" / "target"
PROGRAM = "dartagnan/src/test/resources/locks/ticketlock.ll"
NS = {"m": "http://maven.apache.org/POM/4.0.0"}


def main():
    effective_pom = TARGET / "native-solvers-pom.xml"
    subprocess.run(
        ["mvn.cmd" if os.name == "nt" else "mvn", "--batch-mode", "-pl", "dartagnan",
         "org.apache.maven.plugins:maven-help-plugin:3.5.1:effective-pom", f"-Doutput={effective_pom}"],
        cwd=ROOT, check=True,
    )
    dependencies = ET.parse(effective_pom).getroot().findall("m:dependencies/m:dependency", NS)
    solvers = set()
    for dependency in dependencies:
        if dependency.findtext("m:scope", namespaces=NS) != "provided":
            continue
        artifact = dependency.findtext("m:artifactId", namespaces=NS)
        if artifact and artifact.startswith("javasmt-solver-"):
            solvers.add(artifact.removeprefix("javasmt-solver-").upper())
    if not solvers:
        raise RuntimeError("The active Maven profile supplies no native solvers")

    executable = TARGET / ("dartagnan.exe" if os.name == "nt" else "dartagnan")
    env = os.environ.copy()
    env["DAT3M_HOME"] = str(ROOT)
    for variable in ("PATH", "LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"):
        env[variable] = str(TARGET / "libs") + os.pathsep + env.get(variable, "")

    checks = [(solver or "default", ["cat/c11.cat", PROGRAM] + ([f"--solver={solver}"] if solver else []))
              for solver in [None, *sorted(solvers)]]
    # Lazy closures are enforced by a Z3 user propagator, whose callbacks go through JNI
    checks.append(("lazy closures", ["cat/rc11.cat", PROGRAM, "--encoding.wmm.lazyClosures=true"]))

    failures = []
    for label, arguments in checks:
        command = [str(executable), *arguments]
        print(f"\nChecking {label}: {PROGRAM} (expected PASS)", flush=True)
        try:
            result = subprocess.run(command, cwd=ROOT, env=env, text=True,
                                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=120)
            print(result.stdout, flush=True)
            if result.returncode != 0 or not re.search(r"^Result: PASS\s*$", result.stdout, re.MULTILINE):
                failures.append(f"{label} (exit {result.returncode})")
        except subprocess.TimeoutExpired:
            failures.append(f"{label} (timeout)")
    if failures:
        print("Native solver checks failed:\n" + "\n".join(failures), file=sys.stderr)
        return 1
    print(f"Validated the default solver, lazy closures and {len(solvers)} configured native solvers")
    return 0


if __name__ == "__main__":
    sys.exit(main())
