-- name: CreateUser :one
INSERT INTO users (
    account_id,
    email,
    phone,
    password,
    referral_user_id,
    referral_key,
    country,
    register_ip,
    register_device,
    status,
    g2fa_enabled,
    g2fa_secret,
    ban,
    last_login,
    last_login_raw
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
) RETURNING *;

-- name: GetUser :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: ListUsers :many
SELECT * FROM users
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: GetUserForUpdate :one
SELECT * FROM users
WHERE id = $1 LIMIT 1 FOR UPDATE;

-- name: UpdatUserStatus :exec
UPDATE users SET status = $2
WHERE id = $1;

-- name: DeleteUSer :exec
DELETE FROM users WHERE id = $1;