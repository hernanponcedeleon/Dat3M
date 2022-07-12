#!/bin/bash

# These timeouts are to avoid that the test hung, not to limit each benchmark execution.
# The first one runs Dartagnan an CAAT and thus the higher timeout.
timeout 7200 mvn test -Dtest=DartagnanIMM
timeout 5400 mvn test -Dtest=CuttingIMM
timeout 5400 mvn test -Dtest=GenmcIMM
