#!/bin/bash

timeout 5400 mvn test -Dtest=caat.ARM8
timeout 5400 mvn test -Dtest=assume.ARM8
timeout 5400 mvn test -Dtest=cutting.ARM8
