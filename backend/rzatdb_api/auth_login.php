<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

handleApi(static function (): void {
    expectMethod('POST');
    $pdo = pdo();
    $body = readJsonBody();

    $email = normalizeEmail((string) ($body['email'] ?? ''));
    $password = (string) ($body['password'] ?? '');

    if ($email === '' || $password === '') {
        throw new ApiException('E-Mail-Adresse und Passwort sind erforderlich.', 422);
    }

    $query = $pdo->prepare('SELECT * FROM users WHERE LOWER(email) = LOWER(:email) LIMIT 1');
    $query->execute([':email' => $email]);
    $row = $query->fetch(PDO::FETCH_ASSOC);

    if ($row === false || !password_verify($password, (string) ($row['password_hash'] ?? ''))) {
        throw new ApiException('E-Mail-Adresse oder Passwort ist falsch.', 401);
    }

    respond([
        'message' => 'Anmeldung erfolgreich.',
        'user' => publicUserRow($row),
    ]);
});
