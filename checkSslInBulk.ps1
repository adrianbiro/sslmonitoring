foreach($i in (Import-csv .\Weby-prehled.csv).Doména){
    "{0}: {1}" -f $i, $(bin\sslmonitoring.exe $i); 
}