 #awk 'BEGIN{print 5380395.153701257 / 86400}'
 awk -v sec=${1} 'BEGIN{print sec / 86400}'
 awk -v sec=${1} 'BEGIN{print int(sec / 86400)}'
