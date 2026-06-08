#!/bin/bash

while getopts "u:n:c:m:t:" opt; do
  case $opt in
    u) URL=$OPTARG ;;
    n) TOTAL=$OPTARG ;;
    c) CONCURRENCY=$OPTARG ;;
    m) METHOD=$OPTARG ;;
    t) TIMEOUT=$OPTARG ;;
  esac
done

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

run_request() {
  local ID=$1
  local START=$(date +%s%N)
  local HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X "$METHOD" --max-time "$TIMEOUT" "$URL")
  local END=$(date +%s%N)
  local MS=$(( (END - START) / 1000000 ))
  if [[ "$HTTP_CODE" =~ ^2 ]]; then
    echo "success $MS" > "$TMPDIR/req_$ID"
  else
    echo "fail $MS" > "$TMPDIR/req_$ID"
  fi
}

WALL_START=$(date +%s%N)
RUNNING=0
ID=0

for i in $(seq 1 $TOTAL); do
  while [ $RUNNING -ge $CONCURRENCY ]; do
    RUNNING=$(jobs -r | wc -l)
    sleep 0.1
  done
  ID=$((ID+1))
  run_request $ID &
  RUNNING=$(jobs -r | wc -l)
done

wait
WALL_END=$(date +%s%N)

SUCCESS=0
FAIL=0
TIMES=()

for file in $TMPDIR/req_*; do
  STATUS=$(awk '{print $1}' $file)
  MS=$(awk '{print $2}' $file)
  TIMES+=($MS)
  if [ "$STATUS" = "success" ]; then
    SUCCESS=$((SUCCESS+1))
  else
    FAIL=$((FAIL+1))
  fi
done

SORTED=($(printf '%s\n' "${TIMES[@]}" | sort -n))
COUNT=${#SORTED[@]}
MIN=${SORTED[0]}
MAX=${SORTED[$((COUNT-1))]}
SUM=0
for t in "${SORTED[@]}"; do SUM=$((SUM+t)); done
AVG=$((SUM/COUNT))
P95_IDX=$(( (COUNT * 95) / 100 ))
P95=${SORTED[$P95_IDX]}
WALL_MS=$(( (WALL_END - WALL_START) / 1000000 ))
THROUGHPUT=$(awk -v total="$TOTAL" -v wall="$WALL_MS" 'BEGIN {printf "%.2f", total * 1000 / wall}')

echo "==================== PHANTOM LOAD TEST REPORT ===================="
printf "%-16s : %s\n" "Target URL" "$URL"
printf "%-16s : %s\n" "HTTP Method" "$METHOD"
printf "%-16s : %s\n" "Total Requests" "$TOTAL"
printf "%-16s : %s\n" "Concurrency" "$CONCURRENCY"
printf "%-16s : %s\n" "Timeout (s)" "$TIMEOUT"
echo "------------------------------------------------------------------"
echo "Results"
echo "------------------------------------------------------------------"
printf "%-16s : %s\n" "Successful" "$SUCCESS"
printf "%-16s : %s\n" "Failed" "$FAIL"
echo "------------------------------------------------------------------"
echo "Response Times (ms)"
echo "------------------------------------------------------------------"
printf "%-16s : %s\n" "Minimum" "$MIN"
printf "%-16s : %s\n" "Maximum" "$MAX"
printf "%-16s : %s\n" "Average" "$AVG"
printf "%-16s : %s\n" "P95" "$P95"
echo "------------------------------------------------------------------"
printf "%-16s : %s requests/second\n" "Throughput" "$THROUGHPUT"
echo "=================================================================="
