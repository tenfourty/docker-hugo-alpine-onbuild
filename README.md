tenfourty/hugo-alpine-onbuild
==============

Inspired by [`publysher/hugo`](https://github.com/publysher/docker-hugo).

`tenfourty/hugo-alpine-onbuild ` is a [Docker](https://www.docker.io) base image for static sites generated with [Hugo](http://gohugo.io).

This image is not intended to be run directly, you should always use the docker `FROM` directive to inherit from this image.

Images derived from this image can either run as a stand-alone server, or function as a volume image for your web server.

Prerequisites
-------------

The image is based on the following directory structure:

```
.
├── Dockerfile
└── site
    ├── config.toml
    ├── content
    │   └── ...
    ├── layouts
    │   └── ...
    └── static
└── ...
```

You should put your Hugo site in the `site` directory, and create a simple Dockerfile:

```Dockerfile
FROM tenfourty/hugo-alpine-onbuild
MAINTAINER Jeremy Brown <jeremy@tenfourty.com>
```

**Note: If you don't include a `site` directory in the same directory as your newly created `Dockerfile` then the `FROM` directive will fail.**

Building your site
------------------

Once you've created the `Dockerfile` as per above and populated the `site` directory you can easily build an image for your site:

> $ docker build -t my-site-image-name .

Your site is automatically generated during this build.


Using your site
---------------

There are two options for using the image you generated:

- as a stand-alone image
- as a volume image for your webserver

Using your image as a stand-alone image is the easiest, we are going to mount our local `site` directory into this image so that hugo picks up any changes we make to the local filesystem:

> $ docker run -rm -p 1313:1313 -v [path to this dir]/site/:/site my-site-image-name

or as a daemon:

> $ docker run -d -p 1313:1313 -v [path to this dir]/site/:/site my-site-image-name

This will automatically start `hugo server`, and your blog is now available on http://localhost:1313.

The image is also suitable for use as a volume image for a web server, such as [nginx](https://registry.hub.docker.com/_/nginx/)

	docker run -d -v /usr/share/nginx/html --name site-data my-site-image-name
	docker run -d --volumes-from site-data --name site-server -p 80:80 nginx


Examples
--------

For an example of a Hugo site using this base image check out https://github.com/tenfourty/tenfourty.com


Building this base image
------------------

To build this base image just git clone this repository, cd inside and run the command:

> $ docker build -t tenfourty/hugo-alpine-onbuild .
