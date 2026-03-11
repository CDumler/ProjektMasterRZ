<?php

declare(strict_types=1);

return [
    'db_host' => getenv('DB_HOST') ?: 'Mac.fritz.box',
    'db_port' => getenv('DB_PORT') ?: '3306',
    'db_socket' => getenv('DB_SOCKET') ?: '/tmp/mysql.sock',
    'db_name' => getenv('DB_NAME') ?: 'rzatdb',
    'db_user' => getenv('DB_USER') ?: 'root',
    'db_pass' => getenv('DB_PASS') ?: 'christian10',
    'timezone' => getenv('APP_TIMEZONE') ?: 'Europe/Berlin',
    'cors_origin' => getenv('CORS_ORIGIN') ?: '*',
    'debug' => (getenv('APP_DEBUG') ?: '1') === '1',
];
