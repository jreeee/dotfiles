#! /bin/bash

get_text() {
    [ -f "/tmp/$1" ] && mv "/tmp/$1" "/tmp/$1.old"
    curl "https://trackings.post.japanpost.jp/services/srv/search/?requestNo1=$1&search.x=117&search.y=13&locale=en&startingUrlPatten=" >> "/tmp/$1"
    [ -s "/tmp/$1" ] || { echo "Bad number or no internet connection"; exit 1 }

    # otherwise
# get lines
# move to old
# paste subsection
}

show_hist() {
    get_text "$1"
# extract the values and store them in arrays
# create the table (dynamic?)
}

# check arguments
while [ $# -gt 0 ]; do
    show_hist "$1"
    shift
done
