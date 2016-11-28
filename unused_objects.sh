#!/bin/bash
#

ltm_params="rule pool node snat-translation snatpool virtual-address"

ltm_profile_args="client-ssl http http-compression one-connect request-log server-ssl smtp stream tcp web-acceleration"
ltm_monitor_args="http https"
sys_file_params="ssl-cert ssl-key ifile data-group"

in_file="$1"

function search_and_print() {

        lines=$(cat $in_file | sed -n -e "s/^$1 \([[:print:]]*\) {/\1/p" | grep -o -F -f - $in_file | sort | uniq -u | sed "s%/Common/%%")
        [[ -n $lines ]] && echo -e "*** $1 ($(echo "$lines" | wc -l)) ***\n\n$lines\n\n"

}

for param in $ltm_params
do
        search_and_print "ltm $param"
done


param="ltm profile"
for arg in $ltm_profile_args
do
        search_and_print "$param $arg"
done

param="ltm monitor"
for arg in $ltm_monitor_args
do
        search_and_print "$param $arg"
done


param="sys file"
for arg in $sys_file_params
do
        search_and_print "$param $arg"
done
