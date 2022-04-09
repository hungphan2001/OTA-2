DEVICE=$1
ROMDIR=~/output/Cherish
MAINTAINER=$3
MAINTAINER_URL=$4
FORUM_URL=$5

# Ensures that mandatory parameters are entered
if [ $# -lt 5 ]; then
    echo "Missing mandatory parameters"
    exit 1
fi

cd $ROMDIR
DATETIME=$(grep "ro.cherish.build_date_utc=" out/target/product/$DEVICE/system/build.prop | cut -d "=" -f 2)
FILENAME=$(find out/target/product/$DEVICE/Cherish*.zip | cut -d "/" -f 5)
ID=$(md5sum out/target/product/$DEVICE/Cherish*.zip | cut -d " " -f 1)
FILEHASH=$ID
SIZE=$(wc -c out/target/product/$DEVICE/Cherish*.zip | awk '{print $1}')
URL="https://sourceforge.net/projects/cherish-os/files/device/$DEVICE/$FILENAME/download"
VERSION="12"
DONATE_URL="https://www.paypal.me/hungphan2001"
WEBSITE_URL="https://cherishos.com"
NEWS_URL="https:\/\/t.me\/CherishOS"
JSON_FMT='{\n"error":false,\n"filename": %s,\n"datetime": %s,\n"size":%s, \n"url":"%s", \n"filehash":"%s", \n"version": "%s", \n"id": "%s",\n"donate_url": "%s",\n"website_url":"%s",\n"news_url":"%s",\n"maintainer":"%s",\n"maintainer_url":"%s",\n"forum_url":"%s"\n}'
printf "$JSON_FMT" "$FILENAME" "$DATETIME" "$SIZE" "$URL" "$FILEHASH" "$VERSION" "$ID" "$DONATE_URL" "$WEBSITE_URL" "$NEWS_URL" "$MAINTAINER" "$MAINTAINER_URL" "$FORUM_URL" > $ROMDIR/OTA/builds/$DEVICE.json
echo $ROMDIR/OTA/builds/$DEVICE.json file created

BUILD_DATE=$(echo $FILENAME | cut -d "-" -f 3)
BUILD_YEAR=${BUILD_DATE:0:4}
BUILD_MONTH=${BUILD_DATE:4:2}
BUILD_DAY=${BUILD_DATE:6:2}
CHANGELOG_DATE=$(echo $BUILD_YEAR/$BUILD_MONTH/$BUILD_DAY)
CHANGELOG="Changelog - %s\n\n"
printf "$CHANGELOG_DATE" > $ROMDIR/OTA/changelogs/$FILENAME.txt
echo $ROMDIR/OTA/changelogs/$FILENAME.txt file created
