FROM alpine:3.4
MAINTAINER Jeremy Brown <jeremy@tenfourty.com>

ENV HUGO_VERSION 0.16
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit

# Install packages curl and pygments (for syntax highlighting)
RUN apk add --update curl py-pygments && rm -rf /var/cache/apk/*

################################################################################
#
# Hugo
#
################################################################################

# Download and Install hugo
RUN mkdir /usr/local/hugo_${HUGO_VERSION} && cd /usr/local/hugo_${HUGO_VERSION} && \
    curl -L https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tgz | tar zxvf - && \
    ln -s /usr/local/hugo_${HUGO_VERSION}/hugo /usr/local/bin/hugo_${HUGO_VERSION} && \
    ln -s /usr/local/hugo_${HUGO_VERSION}/hugo /usr/local/bin/hugo

# create our /site directory where we will be running this from
RUN mkdir /site
WORKDIR /site

# expose port 1313 for hugo
EXPOSE 1313

# by default serve up the local site mounted at /site, ideally from the ONBUILD below
CMD ["hugo", "--bind", "0.0.0.0", "--cleanDestinationDir", "--buildDrafts", "server"]

# add our files from the local folder into this docker image
ONBUILD COPY site /site

# run a hugo build to generate the static files for nginx (can be mounted as a data dir in nginx)
ONBUILD RUN hugo -d /usr/share/nginx/html/
