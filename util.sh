#!/bin/sh
#
# example
# sh util.sh update 1.0.0
# sh util.sh pull
#

update(){
    tmp=$(mktemp)
    version=$(echo $1 | sed "s/v//")
    jq --indent 4 \
       --arg version $version \
       '.version = $version' \
       manifest.json > "$tmp" && mv "$tmp" manifest.json

    jq --indent 4 \
       --arg version $version \
       --arg ts $(date +%s) \
       --arg t "update" \
       --arg msg "Update to $version is available." \
       --arg link "https://github.com/lnbits/lnbits/releases/tag/$1" \
       '.notifications |= [{date:$ts,type:$t,message:$msg,link:$link}] + .' \
       manifest.json > "$tmp" && mv "$tmp" manifest.json
}

# execute functions
$@
