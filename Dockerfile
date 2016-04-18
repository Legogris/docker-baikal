FROM alpine:3.2
MAINTAINER Dmitry Prazdnichnov <dp@bambucha.org>

RUN apk --update add unzip lighttpd php-cgi php-ctype php-dom php-pdo_sqlite php-pdo_mysql php-xml openssl php-openssl php-json php-xmlreader \
    && rm -rf /var/cache/apk/*

ENV VERSION	0.4.4
ENV CHECKSUM	b2f63542bf8371729944085561992544

RUN wget -O baikal.zip https://github.com/fruux/Baikal/releases/download/$VERSION/baikal-$VERSION.zip \
    && echo "$CHECKSUM  baikal.zip" | md5sum -c - \
    && unzip baikal.zip -d / \
    && rm baikal.zip \
    && chmod 755 /baikal \
    && chown -R lighttpd:lighttpd /baikal \
    && sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/php.ini \
    && mkdir /baikal/html/.well-known

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf

EXPOSE 80

VOLUME /baikal/Specific

ENTRYPOINT ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
