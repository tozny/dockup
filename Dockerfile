FROM alpine:3.9

RUN apk add --no-cache bash py-pip gnupg \
  && pip install awscli

ADD backup.sh /backup.sh
ADD restore.sh /restore.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

VOLUME /tmp/backups/

CMD ["/run.sh"]
