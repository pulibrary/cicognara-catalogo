#!/bin/bash

#
# Fetch MARC records from Voyager and merge them into a single file. All bib
# ids from ./bib_ids.txt will be retrieved.
#
# Requires: curl, xmllint
#

HERE=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
IDS_FILE="$HERE/bib_ids.txt"
OUT="$(dirname $HERE)/cicognara.mrx.xml"
TMP="/tmp/cico"

BIBDATA="https://bibdata.princeton.edu/bibliographic"

echo "<collection xmlns='http://www.loc.gov/MARC21/slim'>" > $TMP
for bib_id in `cat $IDS_FILE`; do
  curl "$BIBDATA/$bib_id" >> $TMP
done
echo "</collection>" >> $TMP
xmllint --format --nsclean $TMP > $OUT
rm $TMP
