#!/usr/bin/env bash
# Modified from https://wiki.archlinux.org/title/Mirrors#List_by_speed

curl -s "https://archlinux.org/mirrorlist/?country=CN&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -
