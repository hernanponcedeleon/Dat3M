#!/bin/bash

timeout 5400 mvn test -Dtest=caat.IMM
timeout 5400 mvn test -Dtest=assume.IMM
timeout 5400 mvn test -Dtest=cutting.IMM
timeout 5400 mvn test -Dtest=GenmcIMM
