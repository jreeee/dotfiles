#! /bin/bash
# mensa script for the vegetarian dishes

#params
id="151"
col1="\\\e[1;36m"
col2="\\\e[1;33m"
clear="\\\e[0m"

#hacky stuff
[ $# -gt "0" ] && i=$(echo "$1 * 24" | bc -l) || i="10";
str=$(curl -s "https://openmensa.org/api/v2/canteens/$id/days/$(date -Ih -d "+$i hours")/meals" | jq -j '.[] | select(.category|test("Veg*")) | .name, .prices.students' | sed -e "s/\([0-9].[0-79]\)/\10/g;s/[0-9].[0-9]\{2\}/ $col1&€$clear\n/g;s/\(^\|\(\\n\)\([^$]\)\)/\2$col2->$clear \3/g")
[ "$str" == "" ] && echo "No Mensa?" || echo -e "Mensa Plan, $(date -d "+$i hours" "+%a%e %b %g"):\n$str"
