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


cat << EOF > /app/configuration.php
<?php
// The full WHMCS license key.
\$license = '${WHMCS_LICENSE}';

// The admin path
\$customadminpath = "${WHMCS_ADMIN_PATH}";

// Database connection settings.
\$db_host = '${WHMCS_DB_HOST}';
\$db_port = '${WHMCS_DB_PORT}';
\$db_username = '${WHMCS_DB_USERNAME}';
\$db_password = '${WHMCS_DB_PASSWORD}';
\$db_name = '${WHMCS_DB_NAME}';

// Optional values to enable and configure encrypted database connections.
// See https://go.whmcs.com/1781/.
\$db_tls_ca = '';
\$db_tls_ca_path = '';
\$db_tls_cert = '';
\$db_tls_cipher = '';
\$db_tls_key = '';
\$db_tls_verify_cert = '';

// The MySQL client character set. Caution: Changing the charset from the default database
// schema can result in unwanted behavior and data loss.
\$mysql_charset = 'utf8';

// A value used during symmetric encryption of data at rest. This value must be 64 characters
// long and contain only  a–z, A–Z, and 0–9 ASCII values. It is recommended to generate this
// value with a high-entropy random data source or a cryptographic password generation tool.
\$cc_encryption_hash = '${WHMCS_CC_HASH}';

// The directory to cache compiled templates.
\$templates_compiledir = 'templates_c';

//END
EOF

# https://help.whmcs.com/a/1075203#securing-the-configuration-file
chmod 400 /app/configuration.php
chown 1000:1000 /app/configuration.php

echo "WHMCS configuration.php written"
