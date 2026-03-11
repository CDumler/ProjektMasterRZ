<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

handleApi(static function (): void {
    expectMethod('POST');
    $pdo = pdo();
    $body = readJsonBody();

    $name = trim((string) ($body['name'] ?? ''));
    $createdBy = trim((string) ($body['created_by'] ?? ''));
    $status = trim((string) ($body['status'] ?? 'in_progress'));

    if ($name === '') {
        throw new ApiException('Prüfungsname fehlt.', 422);
    }
    if ($createdBy === '') {
        throw new ApiException('created_by fehlt.', 422);
    }
    if ($status === '') {
        $status = 'in_progress';
    }

    $insert = $pdo->prepare(
        'INSERT INTO assessments (name, created_by, status, created_at)
         VALUES (:name, :created_by, :status, NOW())'
    );
    $insert->execute([
        ':name' => $name,
        ':created_by' => $createdBy,
        ':status' => $status,
    ]);

    $assessment = findAssessmentById($pdo, (string) $pdo->lastInsertId());
    if ($assessment === null) {
        throw new ApiException('Prüfung konnte nicht geladen werden.', 500);
    }

    respond([
        'assessment' => $assessment,
    ], 201);
});
