FROM alpine:latest
MAINTAINER Jeremy Brown <jeremy@tenfourty.com>

################################################################################
#
# Hugo
#
################################################################################

ENV HUGO_VERSION 0.16
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit

# Install packages curl (for install) and pygments (for syntax highlighting) then download and install Hugo
RUN apk add --no-cache --update curl py-pygments && \
    mkdir /usr/local/hugo_${HUGO_VERSION} && \
    cd /usr/local/hugo_${HUGO_VERSION} && \
    curl -L https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tgz | tar zxvf - && \
    apk del curl && \
    ln -s /usr/local/hugo_${HUGO_VERSION}/hugo /usr/local/bin/hugo_${HUGO_VERSION} && \
    ln -s /usr/local/hugo_${HUGO_VERSION}/hugo /usr/local/bin/hugo

# create our /site directory where we will be running this from
RUN mkdir /site
WORKDIR /site

# expose port 1313 for hugo
EXPOSE 1313

# by default serve up the local site mounted at /site, ideally from the ONBUILD below
CMD ["hugo", "server", "--bind", "0.0.0.0", "--cleanDestinationDir", "--forceSyncStatic", "--buildDrafts"]

# add our files from the local folder into this docker image
ONBUILD COPY site /site
