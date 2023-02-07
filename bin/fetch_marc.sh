#!/bin/bash

#
# Fetch MARC records from Voyager and merge them into a single file. All bib
# ids from ./bib_ids.txt will be retrieved.
#
# NOTE: the list of bib ids in bib_ids.txt should be manually updated:
# * bib ids for fiche items can be found in the shotlist Google doc:
#     https://docs.google.com/spreadsheets/d/1ffmSwOwKLhxzsdvtJ7mTHFjJshhmCLXQDM6kQCknWdc/edit#gid=0)
# * bib ids for PUL items can be found in Plum
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
if [ $? = 0 ]; then
  rm $TMP
fi
