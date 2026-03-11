<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

handleApi(static function (): void {
    expectMethod('POST');
    $pdo = pdo();
    $body = readJsonBody();

    $email = normalizeEmail((string) ($body['email'] ?? ''));
    $password = (string) ($body['password'] ?? '');
    $displayPrename = trim((string) ($body['display_prename'] ?? ''));
    $displayName = trim((string) ($body['display_name'] ?? ''));
    $company = trim((string) ($body['company'] ?? ''));
    $address = trim((string) ($body['address'] ?? ''));

    if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        throw new ApiException('Bitte eine gültige E-Mail-Adresse angeben.', 422);
    }
    if (mb_strlen($password) < 8) {
        throw new ApiException('Passwort muss mindestens 8 Zeichen haben.', 422);
    }

    $existing = $pdo->prepare('SELECT id FROM users WHERE LOWER(email) = LOWER(:email) LIMIT 1');
    $existing->execute([':email' => $email]);
    if ($existing->fetch(PDO::FETCH_ASSOC) !== false) {
        throw new ApiException('Für diese E-Mail-Adresse existiert bereits ein Konto.', 409);
    }

    $insert = $pdo->prepare(
        'INSERT INTO users (email, password_hash, display_prename, display_name, company, address, created_at)
         VALUES (:email, :password_hash, :display_prename, :display_name, :company, :address, NOW())'
    );
    $insert->execute([
        ':email' => $email,
        ':password_hash' => password_hash($password, PASSWORD_DEFAULT),
        ':display_prename' => $displayPrename,
        ':display_name' => $displayName,
        ':company' => $company,
        ':address' => $address,
    ]);

    $user = findUserById($pdo, (string) $pdo->lastInsertId());
    if ($user === null) {
        throw new ApiException('Benutzer konnte nicht geladen werden.', 500);
    }

    respond([
        'message' => 'Konto erstellt.',
        'user' => publicUserRow($user),
    ], 201);
});
