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


set +u

if [[ "$WHMCS_MODULES_DOWNLOAD" != "" ]]; then
    echo "WHMCS modules download commencing"

    mkdir /tmp/modules_download/

    for module in $WHMCS_MODULES_DOWNLOAD; do
        if [[ "$module" == "" ]]; then
            continue;
        fi

        echo "WHMCS: Downloading $module"
        wget --directory-prefix=/tmp/modules_download/ "$module"
    done

    # Fix permissions and extract excluding EULA.pdfs which some contain that conflict.
    setpriv --reuid=1000 --regid=1000 --init-groups find /tmp/modules_download/ -maxdepth 1 -type f -exec unzip -n {} -x EULA.pdf -d /app/ \; | tee "/var/log/whmcs-modules-$(date +"%Y_%m_%d_%H_%M_%S").log"
else
    echo "WHMCS: No modules to add"
fi
