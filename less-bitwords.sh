#! /usr/bin/env bash
lesskey -o lrfiles.less - <<EOF
\kl prev-file
\kr next-file
EOF

less -M -k lrfiles.less '++&![^a-z]'$'\n' \
  $(eval echo bitdicts/$(printf "%*s" ${1-8} | sed 's/ /{0,1}/g'))
