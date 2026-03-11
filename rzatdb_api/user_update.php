<?php

declare(strict_types=1);

require __DIR__ . '/bootstrap.php';

handleApi(static function (): void {
    expectMethod('PUT', ['POST']);
    $pdo = pdo();

    $userId = trim((string) ($_GET['id'] ?? ''));
    if ($userId === '') {
        throw new ApiException('Ungültige User-ID.', 422);
    }

    $body = readJsonBody();
    $email = normalizeEmail((string) ($body['email'] ?? ''));
    $displayPrename = trim((string) ($body['display_prename'] ?? ''));
    $displayName = trim((string) ($body['display_name'] ?? ''));
    $company = trim((string) ($body['company'] ?? ''));
    $address = trim((string) ($body['address'] ?? ''));
    $password = (string) ($body['password'] ?? '');

    if ($email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        throw new ApiException('Bitte eine gültige E-Mail-Adresse angeben.', 422);
    }
    if ($password !== '' && mb_strlen($password) < 8) {
        throw new ApiException('Passwort muss mindestens 8 Zeichen haben.', 422);
    }

    $currentUser = findUserById($pdo, $userId);
    if ($currentUser === null) {
        throw new ApiException('Benutzer wurde nicht gefunden.', 404);
    }

    $mailCheck = $pdo->prepare(
        'SELECT id FROM users WHERE LOWER(email) = LOWER(:email) AND id <> :id LIMIT 1'
    );
    $mailCheck->execute([
        ':email' => $email,
        ':id' => $userId,
    ]);
    if ($mailCheck->fetch(PDO::FETCH_ASSOC) !== false) {
        throw new ApiException('Für diese E-Mail-Adresse existiert bereits ein Konto.', 409);
    }

    $sql = 'UPDATE users
            SET email = :email,
                display_prename = :display_prename,
                display_name = :display_name,
                company = :company,
                address = :address';
    $params = [
        ':id' => $userId,
        ':email' => $email,
        ':display_prename' => $displayPrename,
        ':display_name' => $displayName,
        ':company' => $company,
        ':address' => $address,
    ];
    if ($password !== '') {
        $sql .= ', password_hash = :password_hash';
        $params[':password_hash'] = password_hash($password, PASSWORD_DEFAULT);
    }
    $sql .= ' WHERE id = :id';

    $update = $pdo->prepare($sql);
    $update->execute($params);

    $updated = findUserById($pdo, $userId);
    if ($updated === null) {
        throw new ApiException('Benutzer konnte nicht aktualisiert werden.', 500);
    }

    respond([
        'message' => 'Profil gespeichert.',
        'user' => publicUserRow($updated),
    ]);
});
