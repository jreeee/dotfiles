#! /bin/bash
# mensa script using the openmensa API (https://openmensa.org/api/v2)

# params
# euro sign, vegan, vegetarian, meat, fish, clear
cols=("\\\e[1;36m" "\\\e[1;31m" "\\\e[1;32m" "\\\e[1;33m" "\\\e[1;34m" "\\\e[0m")
id="151"

usage() {
    printf '%b' "Usage:\n-i specify openmensa id, default id:$id\n-d specify the day\n-m show meat dishes\n-f show fish dishes\n-v show vegan dishes\n-t show vegetarian dishes\n-a show all dishes\n-h show usage\n"
    exit 1
}
soup() {
    [ "$i" == "" ] && i=10 || i=$(echo "$i * 24" | bc -l)
    tmp="$(curl -s "https://openmensa.org/api/v2/canteens/$id/days/$(date -Ih -d "+$i hours")/meals" | jq -j '.[] | select(.category|test("'"$1"'")) | .name, .prices.students' | sed -e "s/\([0-9]\.[0-9]\)\([^0-9]\|$\)/\10\2/g;s/[0-9]\.[0-9]\{2\}/ ${cols[0]}&€${cols[5]}\n/g;s/^\|\(\\n\)\([^$]\)/\1$2$3->${cols[5]} \2/g")"
    [ "$str" != "" ] && tmp="\n$tmp"; 
    printf %b "$tmp"
}
fish() { str=$str$(soup "Fisch" "${cols[4]}" "F");}
meat() { str=$str$(soup "Fleisch" "${cols[3]}" "M"); }
vega() { str=$str$(soup "Vegan" "${cols[1]}" "V"); }
vege() { str=$str$(soup "Vegetarisch" "${cols[2]}" "T"); }
all() { vega; vege; fish; meat; }

while [ $# -gt 0 ]; do
    case "$1" in
    -i | --id) [ $# -gt 1 ] && [ "$2" -eq "$2" ] 2>/dev/null && id="$2" || usage; shift 2;;
    -d | --day) [ $# -gt 1 ] && [ "$2" -eq "$2" ] 2>/dev/null && i="$2" || usage; shift 2;;
    -f | --fish) fish; shift;;
    -m | --meat) meat; shift;;
    -v | --vegan) vega; shift;;
    -t | --vegetarian) vege; shift;;
    -a | -all) all; shift;;
    *) usage;;
    esac
done
# default display if there is no dish specified / no dish of that type:
[ "$str" == "" ] && vega && vege;
[ "$i" == "" ] && i=10 || i=$(echo "$i * 24" | bc -l)
[ "$str" == "" ] && printf %b "No Mensa?\n" || printf %b "$(curl -s "https://openmensa.org/api/v2/canteens/$id" | jq -j .name), $(date -d "+$i hours" "+%a %e %b %g"):\n$str\n"

# sed stuff:

# $(curl -s "https://openmensa.org/api/v2/canteens/$id/days/$(date -Ih -d "+$i hours")/meals" | jq -j '.[] | select(.category|test("Veg*")) | .name, .prices.students' | sed -e "s/\([0-9]\.[0-9]\)\([^0-9]\|$\)/\10\2/g;s/[0-9]\.[0-9]\{2\}/ ${cols[0]}&€${cols[4]}\n/g;s/^\|\(\\n\)\([^$]\)/\1${cols[2]}->${cols[4]} \2/g")
# s/\([0-9]\.[0-9]\)\([^0-9]\|$\)/\10\2/g
# matches x.x where x are numbers and adds a 0 to the end to make it x.xx for each occurrence

# s/[0-9]\.[0-9]\{2\}/ $col1&€$clear\n/g
# puts a € sign and newline behind the x.xx and colours the matched expression

# s/^\|\(\\n\)\([^$]\)/\1$col2->$clear \2/g"
# puts the coloured arrow at the start of the string and every newline