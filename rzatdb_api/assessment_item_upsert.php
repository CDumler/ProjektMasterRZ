<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

handleApi(static function (): void {
    expectMethod('PUT', ['POST']);
    $pdo = pdo();

    $assessmentId = trim((string) ($_GET['assessment_id'] ?? ''));
    $controlId = trim((string) ($_GET['control_id'] ?? ''));
    if ($assessmentId === '' || $controlId === '') {
        throw new ApiException('assessment_id und control_id sind erforderlich.', 422);
    }
    if (findAssessmentById($pdo, $assessmentId) === null) {
        throw new ApiException('Prüfung nicht gefunden.', 404);
    }

    $body = readJsonBody();
    $body['control_id'] = $controlId;
    $item = upsertAssessmentItem($pdo, $assessmentId, $body);

    respond([
        'item' => $item,
    ]);
});
