for i in $(awk -F, 'NR>1{print $2}' *.csv);
do
#  echo "${i}: $(./sslmonitoring ${i})"
  echo "${i},$(./sslmonitoring ${i})"
done
