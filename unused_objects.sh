#!/bin/bash
#
# Usage : ./unused_objects.sh <bigip.conf>
#

ltm_params="node policy pool rule snat-translation snatpool virtual-address"

ltm_profile_args="analytics classification client-ssl dns dns-logging ftp http http-compression one-connect request-log server-ssl smtp stream tcp web-acceleration"
ltm_monitor_args="http https smtp tcp udp"
sys_file_params="data-group ifile ssl-cert ssl-key"

in_file="$1"
stats=""
sum=0

function search_and_print() {

        lines=$(cat $in_file | sed -n -e "s/^$1 $2 \/[[:print:]]*\/\([[:print:]]*\) {/\\\b\1\\\b/p" | grep -o -E -f - $in_file | sort | uniq -u | sed -e "s%/^[[:print:]]*/%%")
        [[ -n $lines ]] && echo -e "$(echo "$lines" | sed "s/^/$2 /")"

        [[ -n $lines ]] && x=$(echo "$lines" | wc -l) || x=0
        stats="$stats\n  * $1 $2 : $x"
        sum=$((sum+ x))
}

for param in $ltm_params
do
        search_and_print "ltm" $param
done


param="ltm profile"
for arg in $ltm_profile_args
do
        search_and_print "$param" $arg
done

param="ltm monitor"
for arg in $ltm_monitor_args
do
        search_and_print "$param" $arg
done


param="sys file"
for arg in $sys_file_params
do
        search_and_print "$param" $arg
done


echo -e "\nStats : $stats"
echo -e "\nTotal : $sum"
