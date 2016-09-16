FROM alpine:3.4

RUN apk add --no-cache bash py-pip && pip install awscli

ADD backup.sh /backup.sh
ADD restore.sh /restore.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

CMD ["/run.sh"]
