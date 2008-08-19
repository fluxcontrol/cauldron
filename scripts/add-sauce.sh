#!/bin/bash

TEMPDIR="/tmp/sauce.$$"

FORCE=false
if [[ $1 == "-f" ]] ;then
  shift
  FORCE=true
fi

TYPE=bad
if [[ $1 == "-i" ]] ;then
  TYPE=iso
elif [[ $1 == "-s" ]] ;then
  TYPE=system
fi

if [[ $TYPE == "bad" || -z $2 ]] ;then
  echo "Usage: $0 [-f] <-i|-s> /path/to/target"
  echo "Adds the cauldron team files to the given chroot"
  echo "Use -i for an iso target, -s for the system tarball"
  exit 1
fi >&2

CHROOTDIR=$2

if ! $FORCE ;then
  if [[ ! -x $CHROOTDIR/bin/bash ]] ;then
    echo "Chroot at $CHROOTDIR failed sanity check (no bash?)"
    exit 2
  fi >&2
fi

MYDIR=$(readlink -f ${0%/*}/..)

if ! [[ -e $MYDIR/base/etc/shadow ]] ;then
  echo "Failed sanity check: Cannot find base/etc/shadow in my dir"
  echo "(assumed to be $MYDIR)"
  exit 2
fi >&2


rm -rf $TEMPDIR
mkdir -m 0700 $TEMPDIR
cp -a $MYDIR/base/* $TEMPDIR/
if [[ $TYPE == "iso" ]] ;then
  cp -a $MYDIR/iso/* $TEMPDIR/
fi
# Insert copy of system here, once/if we need one.

# ==== FIXUP starts here ====
chown -R 0:0 $TEMPDIR/
chmod -R u=rwX,go=u-w $TEMPDIR/
chmod 0600 $TEMPDIR/etc/shadow
# ==== end fixup ====

cp -a $TEMPDIR/* $CHROOTDIR/
rm -rf $TEMPDIR