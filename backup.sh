#!/bin/bash
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin
# Get timestamp
: ${BACKUP_SUFFIX:=.$(date +"%Y-%m-%d-%H-%M-%S")}
readonly tarball=$BACKUP_NAME$BACKUP_SUFFIX.tar.gz

# Create a gzip compressed tarball with the volume(s)
tar czf $tarball $BACKUP_TAR_OPTION $PATHS_TO_BACKUP

# decrypt backup, if encryption enabled
if [[ ! -z "$PASSPHRASE" ]]; then
  echo "Encrypting $tarball..."
  # encrypts and adds .gpg extension
  gpg --cipher-algo AES256 --passphrase $PASSPHRASE --output "$tarball.gpg" --batch --yes --no-tty --force-mdc -c $tarball
  # remove plaintext one after encryption is done
  rm $tarball
  tarball="$tarball.gpg"
fi

# Create bucket, if it doesn't already exist
BUCKET_EXIST=$(aws s3 ls | grep $S3_BUCKET_NAME | wc -l)
if [ $BUCKET_EXIST -eq 0 ];
then
  aws s3 mb s3://$S3_BUCKET_NAME
fi

# Upload the backup to S3 with timestamp
aws s3 --region $AWS_DEFAULT_REGION cp $tarball s3://$S3_BUCKET_NAME/$tarball

# Clean up
rm $tarball
