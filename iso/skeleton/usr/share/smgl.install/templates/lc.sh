#!/bin/bash
# Generated by the installer
# Check if set, if not, set it. In every case, export it
if [[ -z "$LANG" ]] ;then
  LANG=__LANG__
fi
export LANG
