# Operation Phantom Shell
### Linux Hackathon — Complete Solution

A competitive Linux hackathon completed under timed conditions (3 hours).
All 5 challenges solved using **pure bash** and standard Linux utilities only.

---

## Score: 105+ / 130 points

| Challenge | Description | Points | Bonus |
|-----------|-------------|--------|-------|
| 1 | The Log Analyst | 15 | +5 |
| 2 | The Process Wrangler | 20 | +5 |
| 3 | The Network Detective | 15 | - |
| 4 | The Filesystem Archaeologist | 20 | +5 |
| 5 | The Final Boss (Load Tester) | 30 | +10 |

---

## Challenges

### Challenge 1 — The Log Analyst
- Generated 20 log files with 1000 lines each (20,000 total)
- Fully reproducible output using awk with fixed seed
- Queried logs using grep, awk, sed one-liners
- Found top ERROR services, concurrent error minutes, busiest hour

### Challenge 2 — The Process Wrangler
- Spawned 5 background worker processes
- Monitor prints status every 10 seconds with PID, heartbeat count, last seen
- Auto-detects dead workers and restarts them within 5 seconds
- Clean shutdown on Ctrl+C with zero leftover processes

### Challenge 3 — The Network Detective
- Sent crafted POST request with computed base64 token, SHA256 checksum, Unix timestamp
- Parsed JSON response using only grep, awk, sed, tr
- One-liner: 10 parallel UUID requests, filtered, sorted

### Challenge 4 — The Filesystem Archaeologist
- Created 100 files of exactly 512 bytes each
- Deleted all prime-numbered files programmatically (no hardcoded list)
- Inspected tar.gz archive without extracting
- manifest.sh script lists filename, size, MD5 for every file in any archive
- Handles corrupt archives gracefully with error message and exit code 1

### Challenge 5 — The Final Boss
- Full HTTP load testing tool built in pure bash
- Accepts flags: -u URL -n requests -c concurrency -m method -t timeout
- Hard concurrency cap — never exceeds -c parallel requests
- Measures response time in milliseconds per request
- Calculates Min, Max, Average, P95, Throughput
- Cleans up all temp files on exit

---

## Skills Demonstrated
- Bash scripting (functions, arrays, loops, arithmetic)
- Process management (background jobs, PIDs, signals, traps)
- Text processing (grep, awk, sed, tr pipelines)
- Networking (curl, HTTP methods, headers, JSON)
- File systems (tar, md5sum, dd, find)
- Concurrency control in bash

---

## Files
| File | Description |
|------|-------------|
| generate_logs.sh | Generates 20 log files with 1000 lines each |
| phantom_monitor.sh | Process monitor with auto-restart |
| phantom_load.sh | HTTP load testing tool |
| manifest.sh | Archive manifest generator |

---

*Platform: Google Cloud Shell | Language: Bash only*
