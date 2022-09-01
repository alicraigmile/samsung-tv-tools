#!/bin/bash

# Deploy a Samsung TV app to my development environment so I can
# later install it on my telly
#
# Author: Ali Craigmile <ali@craigmile.com>
# Date: 31/Aug/2022

# configuration

SERVER='172.16.0.10'
WWW='www/'


usage()
{
    echo "Usage: deploy.sh [-b buildnum] [-t title] [-d description] [-i id] [-f] zip" 1>&2
    exit 1
}

config_get_value()
{
    unzip -p "$1" "config.xml" | \
    xmlstarlet sel \
    -N "s=http://www.samsung.com/" \
    -t -v "$2"
}

already_deployed()
{
    FOUND=$(xmlstarlet sel \
        -t -v "/rsp/list/widget[@id='$1']/@id" \
        widgetlist.xml)
    echo -n "$FOUND" | grep -c '^'
}

remove_previous()
{
    xmlstarlet ed --inplace \
    -d "/rsp/list/widget[@id='$1']" \
    widgetlist.xml
}

# input variables

while getopts b:t:i:d:f arg
do
    case "${arg}" in
        b) BUILDNUM=${OPTARG};;
        t) TITLE=${OPTARG};;
        i) ID=${OPTARG};;
        d) DESCRIPTION=${OPTARG};;
        f) FORCE=true;;
    esac
done

shift $(($OPTIND - 1))
ZIP=$1

if [[ $# -eq 0 ]]
then
    usage
fi

# we really need a zip file to continue

[ ! -f "$ZIP" ] && echo "File not found '${ZIP}'" && exit -1

# default values come from the app's config file

BUILDNUM=${BUILDNUM:-$(config_get_value "$ZIP" '/s:widget/s:buildnum')}
TITLE=${TITLE:-$(config_get_value "$ZIP" '/s:widget/s:widgetname')}
DESCRIPTION=${DESCRIPTION:-$(config_get_value "$ZIP" '/s:widget/s:description')}

construct_default_id()
{
    TITLE=$1
    BUILDNUM=$2
    ID="${TITLE}_${BUILDNUM}"
    echo ${ID/ /_}
}

ID=${ID:-$(construct_default_id "$TITLE" "$BUILDNUM")}

# ok - what are we working wirth then?

echo "title: $TITLE"
echo "description: $DESCRIPTION"
echo "buildnum: $BUILDNUM"
echo "id: $ID"

# we need the index to query now and update later

cp "${WWW}widgetlist.xml" .

# check to see if this ID is already in use? aka - already deployed?

DEPLOYED=$(already_deployed "$ID")
echo "already deployed: $DEPLOYED"
echo "force: $FORCE"
if [ $DEPLOYED -gt 0 ]
then
 if [ ! -z "$FORCE" ]
    then
        echo "status: ♻️  replacing previous deployment of '$ID'"
        remove_previous "$ID"
    else
        echo "status: 🛑 blocked - build '$ID' already deployed (override with -f option)"
        exit -3
    fi
fi

# internals to the Samsung TV app deploy script

FILE=${ZIP/.zip/_$BUILDNUM.zip}
TITLE="${TITLE} ${BUILDNUM}"
SIZE=$(stat --printf="%s" $ZIP)
DOWNLOAD="http://${SERVER}/widgets/${FILE}"

xmlstarlet ed --inplace \
    -s /rsp/list -t elem -n widget -v "" \
    -s '//widget[position()=last()]' -t attr -n "id" -v "$ID" \
    -s '//widget[position()=last()]' -t elem -n "title" -v "$TITLE" \
    -s '//widget[position()=last()]' -t elem -n "compression" -v "" \
    -s '//widget[position()=last()]/compression' -t attr -n "size" -v "$SIZE" \
    -s '//widget[position()=last()]/compression' -t attr -n "type" -v "zip" \
    -s '//widget[position()=last()]' -t elem -n "description" -v "$DESCRIPTION" \
    -s '//widget[position()=last()]' -t elem -n "download" -v "$DOWNLOAD" \
    widgetlist.xml

install -v --backup=t "$ZIP" "${WWW}widgets/${FILE}"
install -v --backup=t "widgetlist.xml" "$WWW"

