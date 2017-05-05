#!/bin/bash
# Purpose: Purge a single url using cloudflare API from the bash shell 
# Author: Vivek Gite
# License: GNU GPL v2.x+
# https://bash.cyberciti.biz/web-server/linuxunix-bash-shell-script-to-purge-cloudflare-urlimages-from-the-command-line/
#----------------------------------------------------------------------
## Login to Cloudflare to get API keys ##
zone_id="YOUR-Cloudflare-ID-HERE"
api_key="YOUR-Cloudflare-API-KEY-HERE"
login_id="YOUR-Cloudflare-login-name"

## Get url to purge ##
urls="$1"
[ "$urls" == "" ] && { echo "Usage: $0 url"; exit 1; }

## Let user know ##
echo "Purging $urls..."

## Purge it using curl command ##
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/${zone_id}/purge_cache" \
     -H "X-Auth-Email: ${login_id}" \
     -H "X-Auth-Key: ${api_key}" \
     -H "Content-Type: application/json" \
     --data "{\"files\":[\"${urls}\"]}"

echo ""
