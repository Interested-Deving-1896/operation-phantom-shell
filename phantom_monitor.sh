#!/bin/bash

WORKER_PIDS=()

cleanup() {
  echo "Shutting down all workers..."
  for PID in "${WORKER_PIDS[@]}"; do
    kill "$PID" 2>/dev/null
  done
  wait 2>/dev/null
  echo "All workers stopped. Exiting."
  exit 0
}

trap cleanup SIGTERM SIGINT

rm -f /tmp/worker_*.log

for i in $(seq 1 5); do
  (
    COUNT=0
    while true; do
      SLEEP=$(( (RANDOM % 7) + 2 ))
      sleep $SLEEP
      COUNT=$((COUNT + 1))
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] worker-${i} heartbeat ${COUNT}" >> /tmp/worker_${i}.log
    done
  ) &
  WORKER_PIDS[$i]=$!
done

echo "Started workers: ${WORKER_PIDS[@]}"

while true; do
  sleep 10
  for i in $(seq 1 5); do
    PID=${WORKER_PIDS[$i]}
    if ! kill -0 "$PID" 2>/dev/null; then
      echo "Worker $i (PID $PID) died. Restarting..."
      (
        COUNT=0
        while true; do
          SLEEP=$(( (RANDOM % 7) + 2 ))
          sleep $SLEEP
          COUNT=$((COUNT + 1))
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] worker-${i} heartbeat ${COUNT}" >> /tmp/worker_${i}.log
        done
      ) &
      WORKER_PIDS[$i]=$!
    fi
  done
  echo "---- PHANTOM MONITOR STATUS [$(date '+%Y-%m-%d %H:%M:%S')] ----"
  printf "%-10s %-12s %-12s %-s\n" "PID" "WORKER-ID" "HEARTBEATS" "LAST-SEEN"
  for i in $(seq 1 5); do
    PID=${WORKER_PIDS[$i]}
    COUNT=$(wc -l < /tmp/worker_${i}.log 2>/dev/null || echo 0)
    LAST=$(tail -1 /tmp/worker_${i}.log 2>/dev/null | cut -d']' -f1 | tr -d '[' || echo "never")
    printf "%-10s %-12s %-12s %-s\n" "$PID" "worker-$i" "$COUNT" "$LAST"
  done
done
