#!/bin/bash

# Build a Samsung TV app to my development environment
#
# Author: Ali Craigmile <ali@craigmile.com>
# Date: 31/Aug/2022

usage()
{
    echo "Usage: build.sh -b buildnum [-o output] [-f] -j folder" 1>&2
    exit 1
}

remove_trailing_slash()
{
    echo "$1" | sed 's/\/*$//g'
}

config_get_value()
{
    xmlstarlet sel \
    -N "s=http://www.samsung.com/" \
    -t -v "$1" \
    config.xml
}

config_set_buildnum()
{
    xmlstarlet ed --inplace \
    -N "s=http://www.samsung.com/" \
    -s '/s:widget' -t elem -n 'buildnum' -v "$1" \
    config.xml
}

# input variables

while getopts i:o:b:f arg
do
    case "${arg}" in
        o) ZIP=${OPTARG};;
        b) BUILDNUM=${OPTARG};;
        f) FORCE=true;;
    esac
done

shift $(($OPTIND - 1))
FOLDER=$1

if [[ $# -eq 0 ]]
then
    usage
fi

# default values

ZIP=${ZIP:-$(basename "$FOLDER").zip}

# we really need a zip file to continue

if [ ! -d "$FOLDER" ]
then
    echo "status: 🛑 blocked - '${FOLDER}' not found"
    exit -1
fi

# and we need a build number too

if [ -z "$BUILDNUM" ]
then
    echo "Please supply a build number"
    exit -2
fi
echo "status: 🤞 starting build $BUILDNUM ..."

# get ready

FOLDER=$(remove_trailing_slash "$FOLDER")
BUILDFOLDER=./build/${FOLDER}-${BUILDNUM}

# we can proceed if a previous build is not blocking us

if [ -d "$BUILDFOLDER" ]
then
    if [ ! -z "$FORCE" ]
    then
        rm -r "$BUILDFOLDER"
        echo "cleanup: 🗑 removed previous build"
    else
        echo "status: 🛑 blocked - build '$BUILDNUM' already exists (override with -f option)"
        exit -3
    fi
fi

# preparation is key

mkdir -p $BUILDFOLDER
cp -R $FOLDER/. $BUILDFOLDER

# whistle while we work!

cd "build/${FOLDER}-${BUILDNUM}"


NAME=$(config_get_value "/s:widget/s:widgetname")
DESCRIPTION=$(config_get_value "/s:widget/s:description")
echo "name: $NAME"
echo "description: $DESCRIPTION"
config_set_buildnum $BUILDNUM

zip -r ../../${ZIP} .

echo "output: ${ZIP}" 
echo "status: ✅ completed successfully"

