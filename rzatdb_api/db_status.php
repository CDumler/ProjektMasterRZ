<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

handleApi(static function (): void {
    expectMethod('GET');
    $pdo = pdo();

    $tables = ['users', 'assessments', 'assessment_items'];
    $counts = [];
    foreach ($tables as $table) {
        $stmt = $pdo->query("SELECT COUNT(*) AS total FROM {$table}");
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        $counts[$table] = (int) ($row['total'] ?? 0);
    }

    $lastUsers = $pdo->query(
        'SELECT id, email, display_prename, display_name, company, address, created_at
         FROM users
         ORDER BY id DESC
         LIMIT 20'
    )->fetchAll(PDO::FETCH_ASSOC);

    $lastAssessments = $pdo->query(
        'SELECT id, name, created_by, status, created_at
         FROM assessments
         ORDER BY id DESC
         LIMIT 20'
    )->fetchAll(PDO::FETCH_ASSOC);

    $lastItems = $pdo->query(
        'SELECT id, assessment_id, control_id, fulfilment_level, has_assessment, scoring_model, risk_level, updated_at
         FROM assessment_items
         ORDER BY id DESC
         LIMIT 20'
    )->fetchAll(PDO::FETCH_ASSOC);

    respond([
        'database' => [
            'name' => (string) appConfig('db_name', ''),
            'host' => (string) appConfig('db_host', ''),
            'socket' => (string) appConfig('db_socket', ''),
        ],
        'counts' => $counts,
        'last_users' => $lastUsers,
        'last_assessments' => $lastAssessments,
        'last_assessment_items' => $lastItems,
    ]);
});
