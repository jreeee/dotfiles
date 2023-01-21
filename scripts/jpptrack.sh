#! /bin/bash

# set -x

die() {
    echo "$1"
    exit 1
}

get_text() {
    [ -f "/tmp/$1" ] && mv "/tmp/$1" "/tmp/$1.old"
    curl "https://trackings.post.japanpost.jp/services/srv/search/?requestNo1=$1&search.x=117&search.y=13&locale=en&startingUrlPatten=" >> "/tmp/$1"
    [ -s "/tmp/$1" ] || die "Bad number or no internet connection"
    # seperate numbers
    start=$(grep -n "Delivery Status Details" "/tmp/$1" | cut -f1 -d:)
    end=$(grep -n "Office contact" "/tmp/$1" | cut -f1 -d:)"p"
    echo $start$end
    mv "/tmp/$1" "/tmp/$1.old"
    sed -n "$start,$end" "/tmp/$1.old" > "/tmp/$1"
}

show_hist() {
    get_text "$1"
    tags=( "w_105" "w_120" "w_150" "w_180" "w_380" )
    tag1=( $(grep "${tags[0]}" "/tmp/$1" | cut -d ">" -f 2 | cut -d "<" -f 1) )
    for (( i=0; i<${#tag1[@]}; ++i )) do
        echo "${tag1[$i]}"
    done
# extract the values and store them in arrays
# create the table (dynamic?)
}

# check arguments
while [ $# -gt 0 ]; do
    show_hist "$1"
    shift
done
