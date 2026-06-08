#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <archive.tar.gz>"
  exit 1
fi

if ! tar -tzf "$1" > /dev/null 2>&1; then
  echo "Error: '$1' is corrupt or not a valid tar.gz file"
  exit 1
fi

tar -tvzf "$1" | grep '\.dat' | awk '{print $6}' | while read fname; do
  SIZE=$(tar -tvzf "$1" | grep "$fname" | awk '{print $3}')
  MD5=$(tar -xzf "$1" -O "$fname" | md5sum | cut -d' ' -f1)
  echo "$fname $SIZE $MD5"
done
