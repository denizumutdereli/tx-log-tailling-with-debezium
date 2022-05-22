CREATE TABLE "users" (
  "id" BIGINT,
  "account_id" BIGINT NOT NULL DEFAULT 0,
  "email" varchar UNIQUE NOT NULL,
  "phone" varchar UNIQUE NOT NULL,
  "password" varchar NOT NULL,
  "referral_user_id" BIGINT,
  "referral_key" BIGINT NULL,
  "country" varchar NOT NULL,
  "register_ip" varchar NOT NULL,
  "register_device" varchar NOT NULL,
  "status" varchar NOT NULL,
  "g2fa_enabled" boolean NOT NULL DEFAULT (false),
  "g2fa_secret" varchar,
  "ban" timestamp,
  "last_login" timestamp NOT NULL,
  "last_login_raw" text NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp,
  PRIMARY KEY ("id")
);

CREATE TABLE "kyc" (
  "id" BIGINT PRIMARY KEY,
  "user_id" BIGINT UNIQUE NOT NULL,
  "first_name" varchar,
  "last_name" varchar NOT NULL,
  "birth_date" varchar NOT NULL,
  "id_type" varchar NOT NULL DEFAULT 1,
  "id_card_number" BIGINT UNIQUE NOT NULL,
  "id_card_serial" BIGINT UNIQUE NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE TABLE "admin" (
  "id" BIGINT PRIMARY KEY,
  "account_id" BIGINT NOT NULL DEFAULT 1,
  "email" varchar UNIQUE NOT NULL,
  "password" varchar NOT NULL,
  "phone" varchar UNIQUE NOT NULL,
  "g2fa_enabled" boolean DEFAULT (false),
  "g2fa_secret" varchar,
  "ban" timestamp,
  "last_login" timestamp NOT NULL,
  "last_login_raw" text NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp,
  "deleted_at" timestamp
);

CREATE INDEX ON "users" ("phone");

CREATE INDEX ON "users" ("email");

CREATE INDEX ON "kyc" ("user_id");

CREATE INDEX ON "kyc" ("id_card_number");

CREATE INDEX ON "kyc" ("id_card_serial");

CREATE INDEX ON "admin" ("account_id");

CREATE INDEX ON "admin" ("email");

CREATE INDEX ON "admin" ("phone");

CREATE INDEX ON "admin" ("account_id", "email");

CREATE INDEX ON "admin" ("account_id", "phone");

COMMENT ON COLUMN "users"."account_id" IS 'normal users are 0, cryptom users are 1 and others are incremental';

COMMENT ON COLUMN "users"."last_login_raw" IS 'ip2location implementation';

COMMENT ON COLUMN "users"."updated_at" IS 'syntax should be fixed ON UPDATE statement';

COMMENT ON COLUMN "kyc"."id_type" IS 'Turkish citizens are 1 and others are 2';

COMMENT ON COLUMN "kyc"."updated_at" IS 'syntax should be fixed ON UPDATE statement';

COMMENT ON COLUMN "admin"."account_id" IS 'cryptom users are 1 and others are incremental';

COMMENT ON COLUMN "admin"."last_login_raw" IS 'ip2location implementation';

COMMENT ON COLUMN "admin"."updated_at" IS 'syntax should be fixed ON UPDATE statement';

ALTER TABLE "users" ADD FOREIGN KEY ("referral_user_id") REFERENCES "users" ("id");

ALTER TABLE "kyc" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

CREATE  FUNCTION update_updated_at_user()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_updated_at
    BEFORE UPDATE
    ON
        users
    FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_user();