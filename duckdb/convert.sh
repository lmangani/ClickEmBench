#!/bin/bash

PROVIDER="${PROVIDER:-github}"
MACHINE="${MACHINE:-2cpu7gb}"

RESULTS=$(cat log.txt | grep -P '^\d|Killed|Segmentation' | sed -r -e 's/^.*(Killed|Segmentation).*$/null\nnull\nnull/' |     awk '{ if (i % 3 == 0) { printf "[" }; printf $1; if (i % 3 != 2) { printf "," } else { print "]," }; ++i; }') # >> results.json

mkdir -p results

VERSION=$(python3 -c "import duckdb; print(duckdb.__version__)")

echo '
{
    "system": "DuckDB ('$VERSION')",
    "date": "'$(date +%F)'",
    "machine": "'$PROVIDER-$MACHINE'",
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