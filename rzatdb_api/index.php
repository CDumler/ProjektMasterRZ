<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

respond([
    'name' => 'rzatdb_api',
    'status' => 'ok',
    'endpoints' => [
        'auth_register.php',
        'auth_login.php',
        'user_update.php?id={user_id}',
        'assessments_create.php',
        'assessments_list.php?created_by={user_id}',
        'assessments_delete.php',
        'assessment_get.php?id={assessment_id}',
        'assessment_item_upsert.php?assessment_id={assessment_id}&control_id={control_id}',
        'assessment_items_batch_upsert.php?assessment_id={assessment_id}',
        'db_status.php',
    ],
]);
