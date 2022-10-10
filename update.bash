#!/usr/bin/env bash
set -e

if [[ -z "$TORRENT_PATH" ]]; then
echo '$TORRENT_PATH not specified.'; exit
elif [[ ! -d "$TORRENT_PATH" ]]; then
echo "$TORRENT_PATH does not exist or is not a directory."; exit
elif [[ -z "$PASSKEY" ]]; then
echo '$PASSKEY not specified.'; exit
elif [[ ${#PASSKEY} != 32 ]]; then
echo "$PASSKEY is not a valid passkey."; exit
fi

BASE_PATH=$(dirname "$TORRENT_PATH")
BACKUP_DIR="$BASE_PATH/torrents_backup"

if [[ -d "$BACKUP_DIR" ]]; then
echo "$BACKUP_DIR already exists."
echo "Restore or delete this backup and retry the command."
exit
fi

echo -n "Backing up torrents to $BACKUP_DIR... "
cp -r "$TORRENT_PATH" "$BACKUP_DIR"
echo "done."

cd "$TORRENT_PATH"

echo -n "Replacing announce URLs... "

find . -name '*.torrent' -print0 | xargs -0 -- perl -p -i -e \
"s#announce13:announce-listll58:http://landof\\.tv/[0-9a-z]{32}/announce#announce13:announce-listll58:http://landof.tv/$PASSKEY/announce#g; "\
"s#announce78:http://tracker\\.broadcasthe\\.net:34000/[0-9a-z]{32}/announce#announce78:http://tracker.broadcasthe.net:34000/$PASSKEY/announce#g; "

echo "done."

echo "After verifying your torrents are working, you can delete $BACKUP_DIR"
