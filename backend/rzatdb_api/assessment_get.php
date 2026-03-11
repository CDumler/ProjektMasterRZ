<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

handleApi(static function (): void {
    expectMethod('GET');
    $pdo = pdo();

    $assessmentId = trim((string) ($_GET['id'] ?? ''));
    if ($assessmentId === '') {
        throw new ApiException('Ungültige Assessment-ID.', 422);
    }

    $assessment = findAssessmentById($pdo, $assessmentId);
    if ($assessment === null) {
        throw new ApiException('Prüfung nicht gefunden.', 404);
    }

    $queryItems = $pdo->prepare(
        'SELECT id, assessment_id, control_id, fulfilment_level, has_assessment, note, scoring_model, risk_level, updated_at
         FROM assessment_items
         WHERE assessment_id = :assessment_id
         ORDER BY control_id ASC'
    );
    $queryItems->execute([':assessment_id' => $assessmentId]);
    $rows = $queryItems->fetchAll(PDO::FETCH_ASSOC) ?: [];

    $items = array_map('assessmentItemRowToPayload', $rows);
    respond([
        'assessment' => $assessment,
        'items' => $items,
    ]);
});
