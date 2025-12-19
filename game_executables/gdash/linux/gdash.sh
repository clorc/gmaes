#!/bin/sh
printf '\033c\033]0;%s\a' gdash
base_path="$(dirname "$(realpath "$0")")"
"$base_path/gdash.x86_64" "$@"
