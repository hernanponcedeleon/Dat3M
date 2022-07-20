#!/bin/bash

timeout 5400 mvn test -Dtest=caat.TSO
timeout 5400 mvn test -Dtest=assume.TSO
timeout 5400 mvn test -Dtest=cutting.TSO
timeout 5400 mvn test -Dtest=Nidhugg
