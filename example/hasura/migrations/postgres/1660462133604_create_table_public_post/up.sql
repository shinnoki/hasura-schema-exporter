CREATE TABLE "public"."post" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "title" text NOT NULL, PRIMARY KEY ("id") );
CREATE EXTENSION IF NOT EXISTS pgcrypto;
