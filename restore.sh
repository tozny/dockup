#!/bin/bash

# Find last backup file
: ${LAST_BACKUP:=$(aws s3 ls s3://$S3_BUCKET_NAME | awk -F " " '{print $4}' | grep ^$BACKUP_NAME | sort -r | head -n1)}

# Download backup from S3
aws s3 cp s3://$S3_BUCKET_NAME/$LAST_BACKUP $LAST_BACKUP

# decrypt backup, if encryption enabled
if [[ ! -z "$PASSPHRASE" ]]; then
  echo "Decrypting $LAST_BACKUP..."
  # decrypts and removes .gpg extension
  gpg --output "$(basename "$LAST_BACKUP" .gpg)" --passphrase $PASSPHRASE --batch --yes --no-tty --decrypt $LAST_BACKUP
  # remove encrypted tarball since it is no longer needed
  rm $LAST_BACKUP
  # set backup filename to one without .gpg extension
  LAST_BACKUP="$(basename "$LAST_BACKUP" .gpg)"
else

# Extract backup
tar xzf $LAST_BACKUP $RESTORE_TAR_OPTION
# remove tarball
rm $LAST_BACKUP
