# Dockup

Docker image to backup your Docker container volumes

Why the name? Docker + Backup = Dockup

# Usage

You have a container running with one or more volumes:

```
$ docker run -d --name mysql mysql
```

From executing a `$ docker inspect mysql` we see that this container has two volumes:

```
"Volumes": {
            "/etc/mysql": {},
            "/var/lib/mysql": {}
        }
```

## Backup
Launch `dockup` container with the following flags:

```
$ docker run --rm \
--env-file dockup.env \
--env-file x.env \
--volumes-from mysql \
--name dockup tozny/dockup:latest
```

The contents of `dockup.env` being:

```
AWS_ACCESS_KEY_ID=<key_here>
AWS_SECRET_ACCESS_KEY=<secret_here>
AWS_DEFAULT_REGION=us-east-1
BACKUP_NAME=mysql
PATHS_TO_BACKUP=/etc/mysql /var/lib/mysql
S3_BUCKET_NAME=docker-backups.example.com
RESTORE=false
# Passphrase optional if you want AES256 encryption. AES key is derived from passphrase.
PASSPHRASE=securepassphraseforAES256encryption
```

## Encryption

Functionality has been added using `gpg` for AES256 encryption. To use encryption, simply set a passphrase with the `PASSPHRASE=somepassphras` environment variable. If you do not want to use encrypted backups, simply omit the `PASSPHRASE` environment variable from your configuration.

`dockup` will use your AWS credentials to create a new bucket with name as per the environment variable `S3_BUCKET_NAME`, or if not defined, using the default name `docker-backups.example.com`. The paths in `PATHS_TO_BACKUP` will be tarballed, gzipped, time-stamped and uploaded to the S3 bucket.


## Restore
To restore your data simply set the `RESTORE` environment variable to `true` - this will restore the latest backup from S3 to your volume.
