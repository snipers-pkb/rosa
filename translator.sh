#!/usr/bin/env bash

TARGET_LANGUAGE="ru"

SELECTED_TEXT=$(xsel -o | sed "s/[\"\#\&\*\<\>\\]//g")
GT_RESPONSE=$(wget -U "Mozilla/5.0" -qO - "http://translate.google.com/translate_a/t?client=t&sl=auto&tl=${TARGET_LANGUAGE}&text=${SELECTED_TEXT}")
RESULT=$(echo ${GT_RESPONSE} | sed "s/\[\[\[\"//" | cut -d \" -f 1)

notify-send -i accessories-dictionary -t 10000 "${RESULT}"
