#!/bin/sh

target=$(readlink -f "$1")

snapshot_dir="/.zfs/snapshot"

zfs_root() {
  t=$1
  while [ ! -d "$t/.zfs" ] ; do
    t="${t%/*}"
  done
  echo "$t"
}
zfsroot="$(zfs_root $target)"
subpath="${target#$zfsroot}"

selected=$(ls -d "$zfsroot$snapshot_dir/"*"$subpath" | sed "s|$zfsroot$snapshot_dir/\(.*\)$subpath|\1|" | sort -r | fzf)

read -p "Restore $target from $selected snapshot? [N] " reply
case "$reply" in
  y|Y ) ;;
  * ) echo aborted; [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1;; # handle exits from shell or function but don't exit interactive shell
esac

rsync -a "$zfsroot$snapshot_dir/$selected$subpath" "$target"

