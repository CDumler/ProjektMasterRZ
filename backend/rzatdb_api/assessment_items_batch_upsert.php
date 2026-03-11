<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

handleApi(static function (): void {
    expectMethod('POST');
    $pdo = pdo();

    $assessmentId = trim((string) ($_GET['assessment_id'] ?? ''));
    if ($assessmentId === '') {
        throw new ApiException('assessment_id ist erforderlich.', 422);
    }
    if (findAssessmentById($pdo, $assessmentId) === null) {
        throw new ApiException('Prüfung nicht gefunden.', 404);
    }

    $body = readJsonBody();
    $items = $body['items'] ?? null;
    if (!is_array($items)) {
        throw new ApiException('items muss eine Liste sein.', 422);
    }

    $upserted = 0;
    $pdo->beginTransaction();
    try {
        foreach ($items as $entry) {
            if (!is_array($entry)) {
                continue;
            }
            upsertAssessmentItem($pdo, $assessmentId, $entry);
            $upserted++;
        }
        $pdo->commit();
    } catch (Throwable $error) {
        $pdo->rollBack();
        throw $error;
    }

    respond([
        'upserted_count' => $upserted,
    ]);
});
