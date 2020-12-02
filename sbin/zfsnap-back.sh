#!/bin/sh

target="$1"

zfs_root() {
  t=$1
  while [ ! -d "$t/.zfs" ] ; do
    t="${t%/*}"
  done
  echo "$t"
}
zfsroot="$(zfs_root $target)"
subpath="${target#$zfsroot}"

selected=$(ls -d "$zfsroot/.zfs/snapshot/"*"$subpath" | sed "s|$zfsroot/\.zfs/snapshot/\(.*\)$subpath|\1|" | sort -r | fzf)

echo Selected $selected
