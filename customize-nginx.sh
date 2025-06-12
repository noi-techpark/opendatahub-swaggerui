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

# Iterate over config urls entries and create nginx rewrite sections
jq -c '.urls[]' $INPUT_JSON | tac | while read entry; do
    NAME=`echo $entry | jq -rc '.name'`
    # swagger replaces spaces in names with + characters
    NAME=$(echo "$NAME" | sed "s/ /+/g" )

    URL=`echo $entry | jq -rc '.url'`
    
    cat <<EOF >>$TMP
      if (\$arg_url = "$URL" ) {
        rewrite ^ /?urls.primaryName=$NAME? permanent;
      }
EOF

done

sed -i "/alias/r$TMP" $NGINX_CONF

rm $TMP