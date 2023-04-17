#! /bin/bash

TEX_FILE=$1
BIB_FILE=$2

CITATIONS=$(grep -o -e "{?[^}]*}" ${TEX_FILE} | sed 's/.$//' | cut -c 3-)
UNIQUE_CITATIONS=$(echo "$CITATIONS" | tr ' ' '\n' | sort -u | tr '\n' ' ')
echo "$UNIQUE_CITATIONS" >> xivcite.log
FILE_TMP="processing_tmp"

extract_field () {
  cat ${FILE_TMP} | grep $1 | cut -d\" -f2 
}

get_ref () {
  head -n 1 ${FILE_TMP} | cut -d\{ -f2 | sed 's/.$//'
}

touch -a $BIB_FILE

for CITE in ${CITATIONS[@]}
do

  DATA=$(curl -s -H "Accept: application/x-bibtex" https://inspirehep.net/api/arxiv/"$CITE") 
  if [ "$DATA" == '{"status": 404, "message": "PID does not exist."}' ]; then
    continue  
  fi
  echo "${DATA}" >> ${FILE_TMP}
  #extract_field "eprint"
  #extract_field "doi"
  REF=$(get_ref)
  echo $REF >> xivcite.log
  if [[ ! -z "$REF" ]]; then
    if [[ $(grep "$REF" ${BIB_FILE}) ]]; then
      echo "$REF exists" >> xivcite.log
    else
      echo "put $REF in bib file" >> xivcite.log
      cat "${FILE_TMP}" >> ${BIB_FILE}
    fi
  sed -i '' -e "s|\cite{?$CITE|\cite{$REF|g" "$TEX_FILE"
  fi
  rm ${FILE_TMP}
done
