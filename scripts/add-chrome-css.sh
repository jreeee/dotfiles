#! /bin/bash

mozpath="$HOME/.mozilla/firefox"
ffver=$(ls "$mozpath" | grep "default-release")
ffcpath="$mozpath/$ffver/chrome"
cssf="$ffcpath/userChrome.css"

csss="/* hides the native tabs */\n#TabsToolbar {\n  visibility: collapse;\n}"

# check if you already have a chrome folder in your firefox files
if [ ! -d "$ffcpath" ]; then
	mkdir "$ffcpath"
fi

# add the config (to the) file
if [ ! -f "$cssf" ]; then
	printf "%s" "> use advanced config? (requires internet connection)[y/N]"
	read res
	if [ "$res" == "Y" ] || [ "$res" == "y" ]; then
		# useful config I daily drive, thanks @jakobbbb :3
		curl "https://raw.githubusercontent.com/jakobbbb/dotfiles/main/.mozilla/firefox/profile/chrome/userChrome.css" --output "$cssf"
	else
		# just the css to collapse tabs
		printf "$csss" > "$cssf"
	fi
else
	# just appends this to your existing file
	printf "$csss" >> "$cssf"
fi

printf "> done adding tab collapsing to ff \n"
printf "> go to about:config in firefox and set\n"
printf "  toolkit.legacyUserProfileCustomizations.stylesheets to true\n"
printf "> restart ff & you're good to go :)\n"
