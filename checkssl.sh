#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

if [[ ${#} -eq 0 ]]; then
    echo -e "Usage:\v${0} <example.com>\n"
    exit 64
fi
function daysleft()
{
  data=$(echo \
    | openssl s_client -servername ${1} -connect ${1}:443 2>/dev/null \
    | openssl x509 -noout -enddate \
    | sed -e 's#notAfter=##')

  ssldate=$(date -d "${data}" '+%s')
  nowdate=$(date '+%s')
  diff="$((${ssldate}-${nowdate}))"

  echo $((${diff}/86400))
}
arradress=$('google.com' 'youtube.com')

for i in ${arradress}
do
  #left=$(daysleft ${i})
  #if [[ ${left} -ld 500 ]]; then
  #  echo left
  #fi
  echo $i
done

