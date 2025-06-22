#!/bin/bash

docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | tail -n +2 | sort -k 3 -h -r
