#!/bin/bash

PROVIDER="${PROVIDER:-free_runner}"
MACHINE="${MACHINE:-2cpu7gb}"

RESULTS=$(cat log.txt | grep -P '^\d|Killed|Segmentation' | sed -r -e 's/^.*(Killed|Segmentation).*$/null\nnull\nnull/' |     awk '{ if (i % 3 == 0) { printf "[" }; printf $1; if (i % 3 != 2) { printf "," } else { print "]," }; ++i; }') # >> results.json

mkdir -p results

echo '
{
    "system": "Github Actions ('$PROVIDER')",
    "date": "'$(date +%F)'",
    "machine": "'$MACHINE'",
    "cluster_size": "serverless",
    "comment": "",

    "tags": ["C++", "column-oriented", "ClickHouse derivative", "embedded", "github"],

    "load_time": '0',
    "data_size": '$(find . -type f -name "*.parquet" -print0 | xargs -0r du -cb | tail -n1 | awk '{print $1}')',

    "result": [
'$(echo $RESULTS | head -c-2)'
]
}
' > "results/${PROVIDER}.${MACHINE}.json"
