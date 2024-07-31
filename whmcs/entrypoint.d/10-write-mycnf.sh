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


USER_MY_CNF="$(awk -F: -v v="application" '{if ($1==v) print $6}' /etc/passwd)/.my.cnf"

if [[ "$WHMCS_WRITE_MY_CNF" == "yes" ]]; then
    cat << EOF > $USER_MY_CNF
[client]
host="${WHMCS_DB_HOST}"
database="${WHMCS_DB_NAME}"
user="${WHMCS_DB_USERNAME}"
password="${WHMCS_DB_PASSWORD}"

EOF

    chmod 600 $USER_MY_CNF
    chown 1000:1000 $USER_MY_CNF

    echo "WHMCS $USER_MY_CNF written"
fi
