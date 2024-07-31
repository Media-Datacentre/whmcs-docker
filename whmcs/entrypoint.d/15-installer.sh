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


if [[ "$WHMCS_RUN_INSTALLER" == "no" ]]; then
    echo "WHMCS Developer Hint: To install the database (if you're using docker locally and you get errors), either:"
    echo "- Start the container with WHMCS_RUN_INSTALLER=yes"
    echo "- run a \`docker exec -it -u application \$WHMCS_CONTAINER_NAME php /app/install/bin/installer.php -i -n\`"
fi

if [[ "$WHMCS_UPGRADE_FILES" == "yes" ]]; then
    echo "WHMCS: Upgrading files in mounted area (WHMCS_UPGRADE_FILES=yes) - don't do this if not mounted!"
    echo "WHMCS: Extracting /usr/src/whmcs/modules.tgz"
    tar -Pxf /usr/src/whmcs/modules.tgz
    echo "WHMCS: Extracting /usr/src/whmcs/templates.tgz"
    tar -Pxf /usr/src/whmcs/templates.tgz
    echo "WHMCS: File upgrade finished"
fi

if [[ "$WHMCS_RUN_INSTALLER" == "yes" ]]; then
    echo "WHMCS: Checking for mysql@$WHMCS_DB_HOST to come up"

    while ! mysqladmin ping -h"$WHMCS_DB_HOST" --silent; do
        sleep 5
        echo "WHMCS: Checking again for $WHMCS_DB_HOST"
    done

    echo "WHMCS: Triggering installer"
    gosu application php /app/install/bin/installer.php --install --non-interactive
fi
