#!/bin/bash
# Maintainer: yaroslav2424 <julia.schweinz at mailfence dot com>
# Contributor: capezotte (oc1024 at Github)
# Contributor: Seto (huresche at GitHub)
# Contributor: Koichi Murase (akinomyoga at GitHub)

_ble_base_package_type=MPR

function ble/base/package:MPR/version_check {
	LC_ALL=C apt show blesh-git 2>/dev/null | sed -n 's/^Version[[:space:]]*:[[:space:]]*//p'
}

function ble/base/package:MPR/update {
	local PKGNAME="blesh-git"
	local PRE_VERSION POST_VERSION
	PRE_VERSION="$(ble/base/package:MPR/version_check)"
	local helper_exit
	# Try to use MPR helper
		(
			available=(); default_helper='';
			for helper in tap mpm; do
				ble/bin#has "$helper" || continue
				ble/array#push available "$helper"
				[[ ! $default_helper && $_ble_base_repository == */"$helper"* ]] && default_helper=$helper
			done

			if ((${#available[@]})); then
				ble/array#push available "built-in (experimental)"
				if [[ $default_helper ]]; then
					# Bring the default to the beginning of the list
					ble/array#remove available "$default_helper"
					ble/array#unshift available "$default_helper"
				fi

				local PS3="Which MPR helper to use? [${default_helper:+d: $default_helper (default), }x: cancel]? "

				OPERATION='install';
				select helper in "${available[@]}"; do
					# Check if default was set 
					[[ ${helper:=$REPLY} = [dD] || $REPLY = default ]] && helper="$default_helper"

					case $helper in
						(tap)
							builtin printf "Selected helper: $helper\n"
							builtin printf "Package will be built from the MPR repo\n"
							exec "$helper" "$OPERATION" "$PKGNAME"
							break;;
						(mpm)
							builtin printf "Selected helper: $helper\n"
							builtin printf "Package will be built from the AUR repo\n"
							exec "$helper" "$OPERATION" "$PKGNAME"
							break;;
						('built-in (experimental)')
							ble/util/print 'Using built-in AUR helper.'
							exit 3 ;;
						([xX]|exit|[cC]|cancel)
							ble/util/print >&2 'Canceled by the user.'
							exit 1 ;;
					esac
					# Did not exec into a helper
					ble/util/print >&2 'MPR helper failed.'
					exit 1
				done
     		else
				ble/util/print >&2 'MPR helper not found, using built-in.'
				exit 3
			fi
		)
		helper_exit="$?"
   
    if ((helper_exit == 3)); then
		#Try to build from scratch
		local LOCALR="$HOME/.cache/blesh/package"
		(
			ble/util/print "Trying set up a build environment at $LOCALR"
			MPRREPO="https://mpr.hunterwittenborn.com/${PKGNAME}.git"

			set -ex
			[[ -w "${LOCALR%/*}" ]]
			mkdir -p "$LOCALR" && builtin cd "$LOCALR"
			git clone "$MPRREPO" || [ "$(builtin cd "$PKGNAME" && git remote get-url origin)" = "$MPRREPO" ]
			builtin cd "$PKGNAME"
			# Discard changes made by makepkg
			git reset --hard HEAD
			git pull
			ble/util/print "Generating the .deb package from the PKGBUILD..."
			exec makedeb PKGBUILD
		)
		makedeb_exit="$?"
		if ((makedeb_exit==0)); then
			ble/util/print "Asking for installation (sudo dpkg -i "$LOCALR/$PKGNAME"/blesh*.deb):"
			builtin cd "$LOCALR/$PKGNAME" && sudo dpkg -i "$(find -name '*.deb')" # Not the best way to get it, but still unsure which other characters get modified in the .deb name (like - to _)
			makepkg --printsrcinfo > .SRCINFO
		else
			ble/util/print "There was an issue generating the .deb package, exiting..."
		fi
	fi

	POST_VERSION="$(ble/base/package:MPR/version_check)"

	if ((helper_exit==0)); then
		[ "$PRE_VERSION" = "$POST_VERSION" ] && return 6
		return 0
	fi
	# Just return 1 if we reached this point
	return 1
}
