# Backend (PHP + MySQL, ohne Rewrite)

Dieses Backend nutzt eine einfache lokale PHP-Dateistruktur mit direkten `*.php`-Endpoints.

Es speichert genau die drei Bereiche:
- `users`
- `assessments`
- `assessment_items`

Der Checklisten-Katalog bleibt in Flutter lokal.

## Zielpfad im lokalen Webserver

Im Repository existiert der API-Ordner bereits unter:

- `rzatdb_api/`

Wenn dein Webroot auf dieses Projekt zeigt, ist die API direkt erreichbar unter:

- `http://localhost/rzatdb_api/index.php`

Alternativ kann `rzatdb_api/` in deinen lokalen Apache-Webroot kopiert werden.

## Flutter Base URL

In Flutter ist die Base URL auf deinen Wert gesetzt:

- `http://localhost/rzatdb_api`

Optional überschreibbar:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost/rzatdb_api
```

## Endpunkte (direkte Dateien)

- `POST /rzatdb_api/auth_register.php`
- `POST /rzatdb_api/auth_login.php`
- `PUT /rzatdb_api/user_update.php?id={user_id}`
- `POST /rzatdb_api/assessments_create.php`
- `GET /rzatdb_api/assessments_list.php?created_by={user_id}`
- `DELETE /rzatdb_api/assessments_delete.php`
- `GET /rzatdb_api/assessment_get.php?id={assessment_id}`
- `PUT /rzatdb_api/assessment_item_upsert.php?assessment_id={assessment_id}&control_id={control_id}`
- `POST /rzatdb_api/assessment_items_batch_upsert.php?assessment_id={assessment_id}`
- `GET /rzatdb_api/db_status.php`

## Datenbankdefaults (in `config.php`)

- `DB_HOST=localhost`
- `DB_NAME=rzatdb`
- `DB_USER=root`
- `DB_PASS=christian10`

`backend/rzatdb_api/config.php` kann weiterhin über Umgebungsvariablen überschrieben werden.

## Passwort-Hashing

- Speicherung: `password_hash(..., PASSWORD_DEFAULT)`
- Login-Prüfung: `password_verify(...)`

Es werden keine Klartext-Passwörter gespeichert.

## Diagnose bei Fehlern

1. API-Status:
   - `http://localhost:8000/index.php`
2. DB-Verbindung und aktuelle Datensätze:
   - `http://localhost:8000/db_status.php`

Wenn `APP_DEBUG=1` (Default), liefert die API bei 500 den technischen Fehlertext mit zurück.
