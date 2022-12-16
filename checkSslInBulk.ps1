foreach($i in (Import-csv .\Weby-prehled.csv).Doména){
    $days = bin\sslmonitoring.exe $i; 
    "$i : $days"
}