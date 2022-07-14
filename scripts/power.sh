#!/bin/bash

timeout 5400 mvn test -Dtest=caat.Power
timeout 5400 mvn test -Dtest=assume.Power
timeout 5400 mvn test -Dtest=cutting.Power
