for i in $(awk -F, 'NR>1{print $2}' *.csv);
do
  echo "${i}: $(./sslmonitoring ${i})"
  # just return number not a error
  #echo "${i}: $(/home/adrian/gits/m_bin/,checkssl ${i})"
#  echo "${i},$(./sslmonitoring ${i})"
done
