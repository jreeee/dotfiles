#! /bin/bash
# mensa script using the openmensa API (https://openmensa.org/api/v2)

# colours for: euro sign, vegan, vegetarian, meat, fish, clear
cols=("\\\e[1;36m" "\\\e[1;31m" "\\\e[1;32m" "\\\e[1;33m" "\\\e[1;34m" "\\\e[0m")
id="151"
# uses a hex number as 4-bit bitmask to select food in the following order: M | F | T | V
default=0x3
sel=0x0

usage() {
    printf '%b' "Usage:\n-i | specify openmensa id, default id:$id\n-d | specify the day\n-M | meat dishes\n-F | fish dishes\n-V | vegan dishes\n-T | only vegetarian dishes\n-v | vegan and vegetarian dishes\n-p | pescetarian dishes\n-a | all dishes\n-h | usage\n"
    exit 1
}
soup() {
    tmp="$(curl -s "https://openmensa.org/api/v2/canteens/$id/days/$(date -Ih -d "+$d hours")/meals" | jq -j '.[] | select(.notes[]|test("'"$1"'")) | .name, .prices.students' | sed -e "s/\([0-9]\.[0-9]\)\([^0-9]\|$\)/\10\2/g;s/[0-9]\.[0-9]\{2\}/ ${cols[0]}&€${cols[5]}\n/g;s/^\|\(\\n\)\([^$]\)/\1$2$3->${cols[5]} \2/g")"
    [ "$str" != "" ] && tmp="\n$tmp"
    printf %b "$tmp"
}
fish() { str=$str$(soup "\\\(F\\\)" "${cols[4]}" "F"); }
meat() { str=$str$(soup "\\\(S\\\)|\\\(R\\\)|\\\(G\\\)" "${cols[3]}" "M"); }
vega() { str=$str$(soup "\\\(V\\\*\\\)" "${cols[1]}" "V"); }
vege() { str=$str$(soup "\\\(V\\\)|contains(\\\V\\\*\\\))|not" "${cols[2]}" "T"); } # should be "!(V*) and (V)"
unmask() {
    [ $((sel & 0x1)) -eq $(( 0x1 )) ] && vega
    [ $((sel & 0x2)) -eq $(( 0x2 )) ] && vege
    [ $((sel & 0x4)) -eq $(( 0x4 )) ] && fish
    [ $((sel & 0x8)) -eq $(( 0x8 )) ] && meat
}

while [ $# -gt 0 ]; do
    case "$1" in
    -i | --id) [ $# -gt 1 ] && [ "$2" -eq "$2" ] 2>/dev/null && id="$2" || usage; shift 2;;
    -d | --day) [ $# -gt 1 ] && [ "$2" -eq "$2" ] 2>/dev/null && d="$2" || usage; shift 2;;
    -F | --fish) sel=$(( 0x4 | sel)); shift;;
    -M | --meat) sel=$(( 0x8 | sel )); shift;;
    -V | --vegan) sel=$(( 0x1 | sel )); shift;;
    -T | --only-vegetarian) sel=$(( 0x2 | sel)); shift;;
    -v | --vegetarian) sel=$(( 0x3 | sel )); shift;;
    -p | --pescetarian) sel=$(( 0x7 | sel )); shift;;
    -a | --all) sel=0xf; shift;;
    *) usage;;
    esac
done
# default display if there is no dish specified:
[ "$sel" == "0x0" ] && sel=$default;
[ "$d" == "" ] && d=10 || d=$(echo "$d * 24" | bc -l)
unmask
[ "$str" == "" ] && printf %b "No Mensa?\n" || printf %b "$(curl -s "https://openmensa.org/api/v2/canteens/$id" | jq -j .name), $(date -d "+$d hours" "+%a %e %b %g"):\n$str\n"

# sed stuff:

# $(curl -s "https://openmensa.org/api/v2/canteens/$id/days/$(date -Ih -d "+$i hours")/meals" | jq -j '.[] | select(.category|test("Veg*")) | .name, .prices.students' | sed -e "s/\([0-9]\.[0-9]\)\([^0-9]\|$\)/\10\2/g;s/[0-9]\.[0-9]\{2\}/ ${cols[0]}&€${cols[4]}\n/g;s/^\|\(\\n\)\([^$]\)/\1${cols[2]}->${cols[4]} \2/g")
# s/\([0-9]\.[0-9]\)\([^0-9]\|$\)/\10\2/g
# matches x.x where x are numbers and adds a 0 to the end to make it x.xx for each occurrence

# s/[0-9]\.[0-9]\{2\}/ $col1&€$clear\n/g
# puts a € sign and newline behind the x.xx and colours the matched expression

# s/^\|\(\\n\)\([^$]\)/\1$col2->$clear \2/g"
# puts the coloured arrow at the start of the string and every newline
