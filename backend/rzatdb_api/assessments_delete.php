<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

handleApi(static function (): void {
    expectMethod('DELETE', ['POST']);
    $pdo = pdo();
    $body = readJsonBody();

    $createdBy = trim((string) ($body['created_by'] ?? ''));
    $ids = $body['ids'] ?? null;

    if ($createdBy === '') {
        throw new ApiException('created_by fehlt.', 422);
    }
    if (!is_array($ids)) {
        throw new ApiException('ids muss eine Liste sein.', 422);
    }

    $cleanIds = [];
    foreach ($ids as $id) {
        $value = trim((string) $id);
        if ($value !== '') {
            $cleanIds[] = $value;
        }
    }

    if ($cleanIds === []) {
        respond(['deleted_count' => 0]);
    }

    $placeholders = implode(',', array_fill(0, count($cleanIds), '?'));
    $params = array_merge([$createdBy], $cleanIds);

    $pdo->beginTransaction();
    try {
        $deleteItems = $pdo->prepare(
            "DELETE ai FROM assessment_items ai
             INNER JOIN assessments a ON a.id = ai.assessment_id
             WHERE a.created_by = ? AND a.id IN ($placeholders)"
        );
        $deleteItems->execute($params);

        $deleteAssessments = $pdo->prepare(
            "DELETE FROM assessments
             WHERE created_by = ? AND id IN ($placeholders)"
        );
        $deleteAssessments->execute($params);
        $deletedCount = $deleteAssessments->rowCount();
        $pdo->commit();
    } catch (Throwable $error) {
        $pdo->rollBack();
        throw $error;
    }

    respond([
        'deleted_count' => $deletedCount,
    ]);
});
