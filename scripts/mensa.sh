# mensa script

[ $# -gt "0" ] && i=$(echo "$1 * 24" | bc -l) || i="10";
str=$(curl -s 'https://openmensa.org/api/v2/canteens/151/days/'$(date -Ih -d "+$i hours")'/meals' | jq -j '.[] | select(.category|test("Veg*")) | .name, .prices.students' | sed -e "s/\([0-9].[0-79]\)\(\|$\\)/\10\2/g" -e "s/[0-9].[0-9]\{2\}/ &€/g" -e "s/€/€\n/g")
[ "$str" == "" ] && echo "mensa is closed :(" || echo "$str"
