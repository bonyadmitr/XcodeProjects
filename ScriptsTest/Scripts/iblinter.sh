#!/bin/sh

## without pod
#if which iblinter >/dev/null; then
#    iblinter lint
#else
#    echo "warning: IBLinter not installed, download from https://github.com/IBDecodable/IBLinter"
#fi


## pod version
${PODS_ROOT}/IBLinter/bin/iblinter
