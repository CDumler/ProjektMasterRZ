<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

handleApi(static function (): void {
    expectMethod('GET');
    $pdo = pdo();

    $createdBy = trim((string) ($_GET['created_by'] ?? ''));
    if ($createdBy === '') {
        throw new ApiException('created_by ist erforderlich.', 422);
    }

    $query = $pdo->prepare(
        'SELECT a.id, a.name, a.created_by, a.status, a.created_at, COUNT(ai.id) AS item_count
         FROM assessments a
         LEFT JOIN assessment_items ai ON ai.assessment_id = a.id
         WHERE a.created_by = :created_by
         GROUP BY a.id, a.name, a.created_by, a.status, a.created_at
         ORDER BY a.created_at DESC'
    );
    $query->execute([':created_by' => $createdBy]);
    $rows = $query->fetchAll(PDO::FETCH_ASSOC) ?: [];

    $assessments = array_map(
        static fn(array $row): array => [
            'id' => (string) ($row['id'] ?? ''),
            'name' => (string) ($row['name'] ?? ''),
            'created_by' => (string) ($row['created_by'] ?? ''),
            'status' => (string) ($row['status'] ?? ''),
            'created_at' => toIsoDateTimeString($row['created_at'] ?? null),
            'item_count' => (int) ($row['item_count'] ?? 0),
        ],
        $rows
    );

    respond([
        'assessments' => $assessments,
    ]);
});
