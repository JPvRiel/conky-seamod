#!/usr/bin/env bash
tac /var/log/syslog \
  | grep  --color=never -m 5 -o -i -P '[a-z0-9.\-]+\[[0-9]+\]:.*((error)|(warn)|(fail)|(deny)).*$' \
  | sed -e 's/^[a-z0-9.\-]\+\[[0-9]\+\]:/${color white}&${color #888888}/I' \
  | sed -e 's/err\(or\)\?/${color red}&${color #888888}/Ig' \
  | sed -e 's/warn\(ing\)\?/${color yellow}&${color #888888}/Ig' \
  | sed -E -e 's/fail((ed)|(ure)|(ing))?/${color orange}&${color #888888}/Ig' \
  | sed -E -e 's/den((y)|(ied))?/${color purple}&${color #888888}/Ig'