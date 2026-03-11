<?php

declare(strict_types=1);

final class ApiException extends RuntimeException
{
    public int $statusCode;

    public function __construct(string $message, int $statusCode = 400, ?Throwable $previous = null)
    {
        parent::__construct($message, 0, $previous);
        $this->statusCode = $statusCode;
    }
}

$__rzatdbConfig = require __DIR__ . '/config.php';
date_default_timezone_set((string) ($__rzatdbConfig['timezone'] ?? 'Europe/Berlin'));

$corsOrigin = (string) ($__rzatdbConfig['cors_origin'] ?? '*');
if ($corsOrigin !== '') {
    header('Access-Control-Allow-Origin: ' . $corsOrigin);
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
}
header('Content-Type: application/json; charset=utf-8');

if (requestMethod() === 'OPTIONS') {
    respond([], 204);
}

function requestMethod(): string
{
    return strtoupper((string) ($_SERVER['REQUEST_METHOD'] ?? 'GET'));
}

function appConfig(string $key, mixed $default = null): mixed
{
    /** @var array<string, mixed> $__rzatdbConfig */
    global $__rzatdbConfig;
    if (array_key_exists($key, $__rzatdbConfig)) {
        return $__rzatdbConfig[$key];
    }
    return $default;
}

function expectMethod(string $method, array $additionalAllowedMethods = []): void
{
    $allowed = array_merge([$method], $additionalAllowedMethods);
    $actual = requestMethod();
    if (!in_array($actual, $allowed, true)) {
        throw new ApiException('Methode nicht erlaubt.', 405);
    }
}

function pdo(): PDO
{
    static $pdo = null;
    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $host = (string) appConfig('db_host', 'localhost');
    $port = (string) appConfig('db_port', '3306');
    $socket = trim((string) appConfig('db_socket', ''));
    $name = (string) appConfig('db_name', '');
    $user = (string) appConfig('db_user', '');
    $pass = (string) appConfig('db_pass', '');

    if ($socket !== '') {
        $dsn = sprintf('mysql:unix_socket=%s;dbname=%s;charset=utf8mb4', $socket, $name);
    } else {
        $dsn = sprintf('mysql:host=%s;port=%s;dbname=%s;charset=utf8mb4', $host, $port, $name);
    }
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);

    return $pdo;
}

function readJsonBody(): array
{
    $raw = file_get_contents('php://input');
    if (!is_string($raw) || trim($raw) === '') {
        return [];
    }

    try {
        $decoded = json_decode($raw, true, flags: JSON_THROW_ON_ERROR);
    } catch (JsonException $error) {
        throw new ApiException('Ungültiger JSON-Body.', 400, $error);
    }

    if (!is_array($decoded)) {
        throw new ApiException('JSON-Body muss ein Objekt sein.', 400);
    }
    return $decoded;
}

function normalizeEmail(string $email): string
{
    return strtolower(trim($email));
}

function findUserById(PDO $pdo, string $userId): ?array
{
    $query = $pdo->prepare('SELECT * FROM users WHERE id = :id LIMIT 1');
    $query->execute([':id' => $userId]);
    $row = $query->fetch(PDO::FETCH_ASSOC);
    return $row === false ? null : $row;
}

function publicUserRow(array $row): array
{
    return [
        'id' => (string) ($row['id'] ?? ''),
        'email' => normalizeEmail((string) ($row['email'] ?? '')),
        'display_prename' => (string) ($row['display_prename'] ?? ''),
        'display_name' => (string) ($row['display_name'] ?? ''),
        'company' => (string) ($row['company'] ?? ''),
        'address' => (string) ($row['address'] ?? ''),
        'created_at' => toIsoDateTimeString($row['created_at'] ?? null),
    ];
}

function countAssessmentItems(PDO $pdo, string $assessmentId): int
{
    $query = $pdo->prepare(
        'SELECT COUNT(*) AS total
         FROM assessment_items
         WHERE assessment_id = :assessment_id'
    );
    $query->execute([':assessment_id' => $assessmentId]);
    $row = $query->fetch(PDO::FETCH_ASSOC);
    return (int) ($row['total'] ?? 0);
}

function findAssessmentById(PDO $pdo, string $assessmentId): ?array
{
    $query = $pdo->prepare(
        'SELECT id, name, created_by, status, created_at
         FROM assessments
         WHERE id = :id
         LIMIT 1'
    );
    $query->execute([':id' => $assessmentId]);
    $row = $query->fetch(PDO::FETCH_ASSOC);
    if ($row === false) {
        return null;
    }

    return [
        'id' => (string) ($row['id'] ?? ''),
        'name' => (string) ($row['name'] ?? ''),
        'created_by' => (string) ($row['created_by'] ?? ''),
        'status' => (string) ($row['status'] ?? ''),
        'created_at' => toIsoDateTimeString($row['created_at'] ?? null),
        'item_count' => countAssessmentItems($pdo, (string) ($row['id'] ?? '')),
    ];
}

function assessmentItemRowToPayload(array $row): array
{
    return [
        'id' => (string) ($row['id'] ?? ''),
        'assessment_id' => (string) ($row['assessment_id'] ?? ''),
        'control_id' => (string) ($row['control_id'] ?? ''),
        'fulfilment_level' => (int) ($row['fulfilment_level'] ?? 0),
        'has_assessment' => (int) ($row['has_assessment'] ?? 0),
        'note' => (string) ($row['note'] ?? ''),
        'scoring_model' => (string) ($row['scoring_model'] ?? 'conformity'),
        'risk_level' => (int) ($row['risk_level'] ?? 1),
        'updated_at' => toIsoDateTimeString($row['updated_at'] ?? null),
    ];
}

function normalizeScoringModel(string $scoringModel): string
{
    $normalized = strtolower(trim($scoringModel));
    return $normalized === 'maturity' ? 'maturity' : 'conformity';
}

function toBoolInt(mixed $value): int
{
    if (is_bool($value)) {
        return $value ? 1 : 0;
    }
    if (is_numeric($value)) {
        return ((int) $value) !== 0 ? 1 : 0;
    }
    if (is_string($value)) {
        $normalized = strtolower(trim($value));
        return in_array($normalized, ['1', 'true', 'yes', 'y'], true) ? 1 : 0;
    }
    return 0;
}

function clampInt(int $value, int $min, int $max): int
{
    if ($value < $min) {
        return $min;
    }
    if ($value > $max) {
        return $max;
    }
    return $value;
}

function upsertAssessmentItem(PDO $pdo, string $assessmentId, array $payload): array
{
    $controlId = trim((string) ($payload['control_id'] ?? ''));
    if ($controlId === '') {
        throw new ApiException('control_id ist erforderlich.', 422);
    }

    $fulfilmentLevel = clampInt((int) ($payload['fulfilment_level'] ?? 0), 0, 5);
    $hasAssessment = toBoolInt($payload['has_assessment'] ?? 0);
    $note = trim((string) ($payload['note'] ?? ''));
    $scoringModel = normalizeScoringModel((string) ($payload['scoring_model'] ?? 'conformity'));
    $riskLevel = clampInt((int) ($payload['risk_level'] ?? 1), 1, 5);

    $find = $pdo->prepare(
        'SELECT id
         FROM assessment_items
         WHERE assessment_id = :assessment_id
           AND control_id = :control_id
         LIMIT 1'
    );
    $find->execute([
        ':assessment_id' => $assessmentId,
        ':control_id' => $controlId,
    ]);
    $existing = $find->fetch(PDO::FETCH_ASSOC);

    if ($existing !== false) {
        $update = $pdo->prepare(
            'UPDATE assessment_items
             SET fulfilment_level = :fulfilment_level,
                 has_assessment = :has_assessment,
                 note = :note,
                 scoring_model = :scoring_model,
                 risk_level = :risk_level,
                 updated_at = NOW()
             WHERE id = :id'
        );
        $update->execute([
            ':id' => (string) ($existing['id'] ?? ''),
            ':fulfilment_level' => $fulfilmentLevel,
            ':has_assessment' => $hasAssessment,
            ':note' => $note,
            ':scoring_model' => $scoringModel,
            ':risk_level' => $riskLevel,
        ]);
    } else {
        $insert = $pdo->prepare(
            'INSERT INTO assessment_items
                (assessment_id, control_id, fulfilment_level, has_assessment, note, scoring_model, risk_level, updated_at)
             VALUES
                (:assessment_id, :control_id, :fulfilment_level, :has_assessment, :note, :scoring_model, :risk_level, NOW())'
        );
        $insert->execute([
            ':assessment_id' => $assessmentId,
            ':control_id' => $controlId,
            ':fulfilment_level' => $fulfilmentLevel,
            ':has_assessment' => $hasAssessment,
            ':note' => $note,
            ':scoring_model' => $scoringModel,
            ':risk_level' => $riskLevel,
        ]);
    }

    $query = $pdo->prepare(
        'SELECT id, assessment_id, control_id, fulfilment_level, has_assessment, note, scoring_model, risk_level, updated_at
         FROM assessment_items
         WHERE assessment_id = :assessment_id
           AND control_id = :control_id
         LIMIT 1'
    );
    $query->execute([
        ':assessment_id' => $assessmentId,
        ':control_id' => $controlId,
    ]);
    $row = $query->fetch(PDO::FETCH_ASSOC);

    if ($row === false) {
        throw new ApiException('Item konnte nicht gespeichert werden.', 500);
    }

    return assessmentItemRowToPayload($row);
}

function toIsoDateTimeString(mixed $value): ?string
{
    if ($value === null) {
        return null;
    }

    $text = trim((string) $value);
    if ($text === '') {
        return null;
    }

    $timestamp = strtotime($text);
    if ($timestamp === false) {
        return null;
    }

    return gmdate('c', $timestamp);
}

function respond(array $payload, int $statusCode = 200): never
{
    http_response_code($statusCode);
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function handleApi(callable $handler): never
{
    try {
        $handler();
        respond([], 204);
    } catch (ApiException $error) {
        respond(['message' => $error->getMessage()], $error->statusCode);
    } catch (Throwable $error) {
        error_log('[rzatdb_api] ' . $error->getMessage());
        $debug = (bool) appConfig('debug', false);
        $message = $debug
            ? 'Interner Serverfehler: ' . $error->getMessage()
            : 'Interner Serverfehler.';
        respond(['message' => $message], 500);
    }
}
