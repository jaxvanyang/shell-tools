#!/usr/bin/env bash
#
# Select fastest mirrors of Arch Linux.
#
# Usage:
# 	arch-rankmirrors [mirror_count]
#
# Modified from https://wiki.archlinux.org/title/Mirrors#List_by_speed

arch_rankmirrors() {
	curl -s "https://archlinux.org/mirrorlist/?country=CN&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n "${1}" -
}

main() {
	if [ $# -gt 1 ]; then
		echo "Only 0 or 1 argument is acceptable!" >&2
		exit 1
	fi

	if [ $# -eq 0 ]; then
		arch_rankmirrors 5
	else
		arch_rankmirrors "${1}"
	fi
}

main "$@"
