# The content image for sdk.hive.co: the built site in /site, on busybox.
#
# It isn't a web server. In aws-infra (kubernetes/apps/base/sdk-docs), an init
# container runs `cp -Rp /site/. /srv/site/` in this image, and stock nginx
# serves the copy. .github/workflows/build-image.yml builds and pushes it.
#
# Local build and check:
#   docker build -t sdk-docs:local .
#   docker run --rm sdk-docs:local ls -l /site

# The site is plain HTML, CSS and JS, so it's built once on the builder's own
# platform and the same files go into every platform's image.
#
# Same Slate image as docker-compose.yaml. Its Ruby and gems are the only
# ones the site is built with; this repo has no Gemfile of its own.
FROM --platform=$BUILDPLATFORM docker.io/slatedocs/slate:v2.13.1@sha256:941a9021d749e6070c901a781322c1fc0be08f224ccbbaccd8a68fe6549e1dd2 AS build
WORKDIR /srv/slate

# Our config.rb and lib/ instead of upstream's. Upstream's config.rb adds a
# content hash to every asset's file name (stylesheets/screen-b7ddc37d.css),
# which would change the URL of every image, stylesheet and script the site
# serves.
RUN rm -rf config.rb lib source
COPY config.rb ./
COPY lib lib
COPY source source
# Middleman copies static files with their mode from git (the fonts are
# 100755), so set 644 files and 755 directories explicitly
RUN ./slate.sh build \
 && find build -type d -exec chmod 755 {} + \
 && find build -type f -exec chmod 644 {} +

FROM docker.io/library/busybox:1.37@sha256:a7dbc319b1438115a207e11930dc4bb3e643dcb3ec0bdd694bb36cd8fad289ec
# COPY makes everything owned by root:root
COPY --from=build /srv/slate/build /site
