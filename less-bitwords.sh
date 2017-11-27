#! /usr/bin/env bash
lesskey -o lrfiles.less - <<EOF
\kl prev-file
\kr next-file
EOF

bits=${1-8}

cd bitdicts
less -M -k ../lrfiles.less '++&![^a-z]'$'\n' \
  $(perl -e "for (1..(1<<$bits)-1) {printf('%0${bits}b ', \$_)}")
