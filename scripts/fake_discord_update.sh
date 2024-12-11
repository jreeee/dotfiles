#!/usr/bin/env bash

set -e

get_build_info_file() {
    discord_dir="/opt/discord"
    if [ ! -z $1 ]; then
        discord_dir="$discord_dir-$1"
    fi;
    file="$discord_dir/resources/build_info.json"
    if [ ! -f "$file" ]; then
        >&2 echo "File '$file' does not exist."
        exit 1
    fi
    echo $file
}

get_current_version() {
    if [ ! -z $1 ]; then
        branch="/$1"
    fi
    url=https://discord.com/api/download$branch\?platform\=linux\&format\=tar.gz 
    ver=$(curl -v $url 2>&1 | sed -sn "s/< location: https.*linux.\([0-9\.]\+\).*/\1/p")
    if [ -z $ver ]; then
        >&2 echo "Could not find version for '$1' (tried $url)"
        exit 1
    fi
    echo $ver
}

fake_update() {
    file=$(get_build_info_file $1)
    old_version="$(cat $file | jq -r .version)"
    new_version="$(get_current_version $1)"
    sudo sed -i "s/$old_version/$new_version/" $file
    echo "$1: $old_version -> $new_version"
}

print_help() {
    echo "Fake Discord update by bumping version in \`build_info.json\`"
    echo "usage:"
    echo "    # regular Discord:"
    echo "    $0"
    echo "    # PTB:"
    echo "    $0 ptb"
    echo "    # Canary:"
    echo "    $0 canary"
}

case $1 in
    -h|--help)
        print_help
        ;;
    *)
        fake_update $1
        ;;
esac
