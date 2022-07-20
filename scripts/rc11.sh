#!/bin/bash

timeout 5400 mvn test -Dtest=caat.RC11
timeout 5400 mvn test -Dtest=assume.RC11
timeout 5400 mvn test -Dtest=cutting.RC11
timeout 5400 mvn test -Dtest=GenmcRC11
