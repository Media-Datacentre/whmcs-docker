FROM webdevops/php-nginx:8.1

# MIT License
#
# Copyright (c) 2024 Media Datacentre
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#ARG WHMCS_ZIP_FILENAME="whmcs_v880_full.zip"
ARG WHMCS_MODULES_DOWNLOAD=""

# Don't adjust any ENV vars here, set them in compose, helm chart,
# or other container service configuration

ENV WHMCS_DB_HOST="mysql"
ENV WHMCS_DB_PORT="3306"
ENV WHMCS_DB_NAME="whmcs"
ENV WHMCS_DB_USERNAME="whmcs"
ENV WHMCS_DB_PASSWORD="whmcs"

# The WHMCS license key
ENV WHMCS_LICENSE=""

# The hash used by WHMCS for CCs.
ENV WHMCS_CC_HASH="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012345678900"

# To rename the admin folder
# https://help.whmcs.com/a/1075203#5-rename-the-whmcs-admin-area-directory
ENV WHMCS_ADMIN_PATH="admin"

# If using a bind mount or persistent volume for modules, set to yes during version change
# This should only be used for local development, production environments should build
# their modules into the container image.
ENV WHMCS_UPGRADE_FILES="no"

# To run the installer. WHMCS_RM_INSTALL happens after the installer is run
ENV WHMCS_RUN_INSTALLER="no"

# To delete the WHMCS install folder (WHMCS recommendation)
ENV WHMCS_RM_INSTALL="yes"

# Whether to write the user convenience .my.cnf
ENV WHMCS_WRITE_MY_CNF="yes"

# Set to your hostname, the base webdevops/php-nginx doesn't seem to automagically pick this up
ENV NGINX_SERVER_NAME=""

# Newer docker dislikes ADD ${WHMCS_ZIP_FILENAME} /tmp/whmcs.zip from compose context
ADD ./whmcs_full.zip /tmp/whmcs.zip

# 1. Do updates (security!)
# 2. Add packages (below for notes)
# 3. Update CA certs (security!)
# 4. Extract WHMCS
# 5. Backup modules/templates/install for later use (dev/debug)
# 6. Ensure permissions
# 7. Add certbot for letsencrypt support
RUN set -ex; \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        mariadb-client \
        python3 python3-venv libaugeas0 \
    && rm -rf /var/lib/apt/lists/* \
    && update-ca-certificates \
    && unzip -d /usr/src/ /tmp/whmcs.zip \
    && mv -T /usr/src/whmcs/ /app/ \
    && chown -R 1000:1000 /app \
    && mkdir /usr/src/whmcs/ \
    && tar -Pczf /usr/src/whmcs/modules.tgz /app/modules/ \
    && tar -Pczf /usr/src/whmcs/templates.tgz /app/templates/ \
    && tar -Pczf /usr/src/whmcs/install.tgz /app/install/ \
    && chown -R 1000:1000 /usr/src/whmcs/ \
    && python3 -m venv /opt/certbot/ \
    && /opt/certbot/bin/pip install --upgrade pip \
    && /opt/certbot/bin/pip install certbot certbot-nginx \
    && ln -s /opt/certbot/bin/certbot /usr/bin/certbot

# mariadb-client is for developer convenience
# python is for the certbot client

ADD entrypoint.d/10-modules.sh /opt/docker/provision/entrypoint.d/10-modules.sh
ADD entrypoint.d/10-write-whmcs.sh /opt/docker/provision/entrypoint.d/10-write-whmcs.sh
ADD entrypoint.d/10-write-mycnf.sh /opt/docker/provision/entrypoint.d/10-write-mycnf.sh
ADD entrypoint.d/15-installer.sh /opt/docker/provision/entrypoint.d/15-installer.sh
ADD entrypoint.d/16-post-setup.sh /opt/docker/provision/entrypoint.d/16-post-setup.sh

ADD nginx/vendor.conf /opt/docker/etc/nginx/vhost.common.d/vendor.conf

# Executed now in case of modules provided by build arg
RUN /opt/docker/provision/entrypoint.d/10-modules.sh
