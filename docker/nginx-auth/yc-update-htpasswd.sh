#/bin/bash

#
# This script is obtaining secret value (payload) from Yandex.Cloud's lockbox with specified SECRET_NAME and
# updates $SAVE_PATH/.htpasswd with provided login and obtained pass via htpasswd.
#
# Schedule this script with cron
#

SECRET_NAME="nginx-auth"
SAVE_DIR_PATH="/etc/nginx/keys"
SAVE_FILENAME=".htpasswd"

secret=$(yc lockbox payload get "$SECRET_NAME")
login=$(echo "$secret" | sed -n "/key: login/{n;s/.*text_value: \(.*\)/\1/p}")
pass=$(echo "$secret" | sed -n "/key: pass/{n;s/.*text_value: \(.*\)/\1/p}")

if [[ ! -d "$SAVE_DIR_PATH" ]]; then
    mkdir -p "$SAVE_DIR_PATH"
fi
save_path="$SAVE_DIR_PATH/$SAVE_FILENAME"

htpasswd -cb $save_path "$login" "$pass"
