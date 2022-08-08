#! /bin/bash
# mensa script for the vegetarian dishes

# params
col1="\\\e[1;36m"
col2="\\\e[1;33m"
clear="\\\e[0m"

# hacky stuff
[ $# -gt "0" ] && i=$(echo "$1 * 24" | bc -l) || i="10" &&
[ $# -gt "1" ] && id="$2" || id="151" &&
str=$(curl -s "https://openmensa.org/api/v2/canteens/$id/days/$(date -Ih -d "+$i hours")/meals" | jq -j '.[] | select(.category|test("Veg*")) | .name, .prices.students' | sed -e "s/\([0-9]\.[0-9]\)\([^0-9]\|$\)/\10\2/g;s/[0-9]\.[0-9]\{2\}/ $col1&€$clear\n/g;s/^\|\(\\n\)\([^$]\)/\1$col2->$clear \2/g")
[ "$str" == "" ] && echo "No Mensa?" || echo -e "$(curl -s "https://openmensa.org/api/v2/canteens/$id" | jq -j .name), $(date -d "+$i hours" "+%a%e %b %g"):\n$str"

# sed stuff:

# s/\([0-9]\.[0-9]\)\([^0-9]\|$\)/\10\2/g
# matches x.x where x are numbers and adds a 0 to the end to make it x.xx for each occurrence

# s/[0-9]\.[0-9]\{2\}/ $col1&€$clear\n/g
# puts a € sign and newline behind the x.xx and colours the matched expression

# s/^\|\(\\n\)\([^$]\)/\1$col2->$clear \2/g"
# puts the coloured arrow at the start of the string and every newline
