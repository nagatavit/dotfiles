#!/usr/bin/env bash

BASE_DATE=${1}
END_DATE=$(date +%s)

ORG_JOURNAL_DIR="/home/nagata/Org/roam/journal"

TMP_FILE=$(mktemp)

echo "Saving journal to $TMP_FILE"

DIFF_DAYS=$(( (${END_DATE} - $(date --date="${BASE_DATE}" +%s) )/(60*60*24) ))

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    echo -e "\tusage: $0 <year>-<month>-<day>"
    exit
fi

cd "$ORG_JOURNAL_DIR" || exit

for i in $(seq 0 "${DIFF_DAYS}"); do
    curr_date=$(date -I -d "${BASE_DATE} +$i days")

    cat "$curr_date.org" 2> /dev/null >> "$TMP_FILE"
done

read -p "Open in emacsclient? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    emacsclient "$TMP_FILE"
fi
