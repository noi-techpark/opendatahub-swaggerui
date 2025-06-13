#!/bin/sh

# SPDX-FileCopyrightText: 2025 NOI Techpark <digital@noi.bz.it>
#
# SPDX-License-Identifier: CC0-1.0
# 

# This script is ran as part of the docker startup procedure.
# Since swagger itself is also modifying the file on startup, we cannot use a static template
#
# Since we started using a preset urls=[...] config to enable the top bar selection box, the "url" parameter is ignored and the old links don't work anymore
# The script adds a couple of custom mapping rules to the nginx config file to support legacy URL formats using the url=<apispec> format
# To work around this without changing all the links (and because names might change), we rewrite these specific url parameters to urls.primaryName
# urls.primaryName expects the "name" and not the URL, hence we get the name/url pairs from the swagger-ui config json and generate the mapping from that

NGINX_ROOT=/usr/share/nginx/html
NGINX_CONF=/etc/nginx/conf.d/default.conf
INPUT_JSON="${NGINX_ROOT}${CONFIG_URL}"

TMP=$(mktemp)

cat <<"EOF" >> $TMP
map_hash_bucket_size 256;
# map old style url= to urls.primaryName format
map $arg_url $remap {
EOF

# Iterate over config urls entries and create nginx rewrite sections
jq -c '.urls[]' $INPUT_JSON | tac | while read entry; do
    NAME=`echo $entry | jq -rc '.name'`
    # swagger uses urlencode, but with the '+' for spaces instead of %20
    NAME=$(echo -n "$NAME" | jq -s -R -r @uri | sed 's/%20/+/g' )

    URL=`echo $entry | jq -rc '.url'`
    
    echo "\"$URL\" \"$NAME\";" >> $TMP
done

echo 'default 0;' >> $TMP
echo '}' >> $TMP

# insert at start of file
cat $TMP $NGINX_CONF > $NGINX_CONF.tmp && mv $NGINX_CONF.tmp $NGINX_CONF

# zero out temp file
cat /dev/null > $TMP

cat <<"EOF" >> $TMP
if ($remap) {
  rewrite ^ /?urls.primaryName=$remap? permanent;
}
EOF

# insert tmp file content right below the alias directive
sed -i "/alias/r$TMP" $NGINX_CONF

cat $NGINX_CONF

rm $TMP