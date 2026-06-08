#!/bin/bash
for i in $(seq 1 20); do
  FILE=~/phantom/logs/app_$i.log
  awk -v filenum="$i" 'BEGIN {
    split("auth-service,api-gateway,db-connector,cache-manager,queue-worker,file-handler,notification-service,session-tracker", svcs, ",")
    split("INFO,WARN,ERROR,DEBUG", lvls, ",")
    srand(filenum * 31337)
    for (j = 1; j <= 1000; j++) {
      lvl = lvls[int(rand()*4)+1]
      svc = svcs[int(rand()*8)+1]
      hour = int(rand()*24)
      min = int(rand()*60)
      sec = int(rand()*60)
      day = int(rand()*365)+1
      year = 2024
      mon = int((day-1)/30)+1
      if (mon > 12) mon = 12
      dom = day - (mon-1)*30
      if (dom < 1) dom = 1
      if (dom > 28) dom = 28
      printf "[%04d-%02d-%02d %02d:%02d:%02d] [%s] [%s] message_file%d_line%d\n", year, mon, dom, hour, min, sec, lvl, svc, filenum, j
    }
  }' > "$FILE"
done
