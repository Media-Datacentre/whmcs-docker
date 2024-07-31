#!/bin/bash

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


# WHMCS recommends renaming the admin folder
if [[ "$WHMCS_ADMIN_PATH" == "admin" ]]; then
    echo "WHMCS warning - official recommendation to rename admin folder"
    echo "See https://help.whmcs.com/a/1075203#5-rename-the-whmcs-admin-area-directory for details"
elif [[ -e "/app/${WHMCS_ADMIN_PATH}" ]]; then
    echo "WHMCS admin rename already performed to /app/${WHMCS_ADMIN_PATH}";
elif [[ "$WHMCS_ADMIN_PATH" != "admin" ]]; then
    mv /app/admin /app/${WHMCS_ADMIN_PATH}
    echo "WHMCS admin path set to /app/${WHMCS_ADMIN_PATH}"
fi

# WHMCS will not run if the install folder exists
if [[ "$WHMCS_RM_INSTALL" == "yes" ]]; then
    rm -rf "/app/install/"
    echo "WHMCS install folder deleted (WHMCS_RM_INSTALL was yes)"
else
    echo "WHMCS install folder NOT deleted (make WHMCS_RM_INSTALL yes), WHMCS may not function"
fi

# User bind mounts will remove the default modules
if [[ "$(ls -1 /app/modules/ | wc -l)" -eq 0 ]]; then
    echo "WHMCS modules empty, presuming empty bind, populating"
    tar -Pxvf /usr/src/whmcs/modules.tgz
else
    echo "WHMCS modules folder is not empty, so not populating"
fi

# User bind mounts will remove the default templates
if [[ "$(ls -1 /app/templates/ | wc -l)" -eq 0 ]]; then
    echo "WHMCS templates empty, presuming empty bind, populating"
    tar -Pxvf /usr/src/whmcs/templates.tgz
else
    echo "WHMCS templates folder is not empty, so not populating"
fi

# webdevops/php-nginx doesn't seem to automagically pass this, so we offer setting it
if [[ "$NGINX_SERVER_NAME" != "" ]]; then
    echo "Manually setting nginx SERVER_NAME to $NGINX_SERVER_NAME"

    sed -i "s%\$server_name%$NGINX_SERVER_NAME%" /etc/nginx/fastcgi_params
fi
