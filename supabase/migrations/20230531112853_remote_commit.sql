
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";

CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

CREATE DOMAIN "public"."location_type" AS "text"
	CONSTRAINT "location_type_check" CHECK ((VALUE = ANY (ARRAY['point'::"text", 'polygon'::"text"])));

ALTER DOMAIN "public"."location_type" OWNER TO "postgres";

CREATE DOMAIN "public"."site_type" AS "text"
	CONSTRAINT "site_type_check" CHECK ((VALUE = ANY (ARRAY['church'::"text", 'palace'::"text", 'house'::"text", 'monument'::"text", 'cultural institution'::"text"])));

ALTER DOMAIN "public"."site_type" OWNER TO "postgres";

CREATE DOMAIN "public"."star_count" AS integer
	CONSTRAINT "star_count_check" CHECK (((VALUE >= 0) AND (VALUE <= 4)));

ALTER DOMAIN "public"."star_count" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE "public"."items_handbook_data" (
    "id" "uuid",
    "ca_hb_name" "text",
    "ca_hb_type" "public"."site_type",
    "ca_hb_stars" "public"."star_count",
    "ca_hb_address" "text",
    "ca_hb_text" "text",
    "zone_hb_volume" "text",
    "zone_hb_number" bigint,
    "zone_hb_aux_list" boolean,
    "zone_hb_text" "text",
    CONSTRAINT "items_handbook_data_ca_hb_name_check" CHECK (("ca_hb_name" = ANY (ARRAY['17A'::"text", '17B'::"text"])))
);

ALTER TABLE "public"."items_handbook_data" OWNER TO "postgres";

CREATE TABLE "public"."items_harvard_list_data" (
    "id" "uuid",
    "long_list_stars" "public"."star_count",
    "long_list_text" "text",
    "short_list_text" "text"
);

ALTER TABLE "public"."items_harvard_list_data" OWNER TO "postgres";

CREATE TABLE "public"."items_location_data" (
    "id" "uuid",
    "town" "text",
    "country" "text",
    "region" "text",
    "province" "text",
    "location_type" "public"."location_type",
    "coordinates" "text"[]
);

ALTER TABLE "public"."items_location_data" OWNER TO "postgres";

CREATE TABLE "public"."items_map_data" (
    "id" "uuid",
    "acls_name" "text",
    "acls_location_type" "public"."site_type",
    "acls_stars" "public"."star_count",
    "acls_grid_reference" "text",
    "acls_address" "text",
    "acls_atlas_text" "text",
    "acls_map_links" "text"[],
    "ca_atlas_title" "text",
    "ca_atlas_type" "public"."site_type",
    "ca_atlas_stars" "public"."star_count",
    "ca_atlas_grid_reference" "text",
    "ca_atlas_address" "text",
    "ca_atlas_text" "text",
    "ca_atlas_links" "text"[]
);

ALTER TABLE "public"."items_map_data" OWNER TO "postgres";

CREATE TABLE "public"."items_protected_monuments_data" (
    "id" "uuid",
    "lpm_volume" bigint,
    "lpm_stars" "public"."star_count",
    "lpm_military_grid" "text",
    "lpm_text" "text"
);

ALTER TABLE "public"."items_protected_monuments_data" OWNER TO "postgres";

CREATE TABLE "public"."items_root" (
    "internal_id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text",
    "alternative_names" "text"[],
    "associated_with" "uuid",
    "association_type" "text",
    "damage" "text",
    "notes" "text"[],
    "period" "text",
    "photograph_links" "text"[],
    "bibliography_damage" "text",
    CONSTRAINT "items_root_association_type_check" CHECK (("association_type" = ANY (ARRAY['within'::"text", 'contains'::"text", 'near'::"text"])))
);

ALTER TABLE "public"."items_root" OWNER TO "postgres";

CREATE TABLE "public"."ui_column_names" (
    "field" "text" NOT NULL,
    "headername" "text",
    "filter" boolean DEFAULT true,
    "sortable" boolean DEFAULT true,
    "type" "text" DEFAULT 'text'::"text"
);

ALTER TABLE "public"."ui_column_names" OWNER TO "postgres";

ALTER TABLE ONLY "public"."items_root"
    ADD CONSTRAINT "items_root_pkey" PRIMARY KEY ("internal_id");

ALTER TABLE ONLY "public"."ui_column_names"
    ADD CONSTRAINT "ui_column_names_pkey" PRIMARY KEY ("field");

ALTER TABLE ONLY "public"."items_handbook_data"
    ADD CONSTRAINT "items_handbook_data_id_fkey" FOREIGN KEY ("id") REFERENCES "public"."items_root"("internal_id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."items_harvard_list_data"
    ADD CONSTRAINT "items_harvard_list_data_id_fkey" FOREIGN KEY ("id") REFERENCES "public"."items_root"("internal_id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."items_location_data"
    ADD CONSTRAINT "items_location_data_id_fkey" FOREIGN KEY ("id") REFERENCES "public"."items_root"("internal_id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."items_map_data"
    ADD CONSTRAINT "items_map_data_id_fkey" FOREIGN KEY ("id") REFERENCES "public"."items_root"("internal_id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."items_protected_monuments_data"
    ADD CONSTRAINT "items_protected_monuments_data_id_fkey" FOREIGN KEY ("id") REFERENCES "public"."items_root"("internal_id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."items_root"
    ADD CONSTRAINT "items_root_associated_with_fkey" FOREIGN KEY ("associated_with") REFERENCES "public"."items_root"("internal_id");

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON TABLE "public"."items_handbook_data" TO "anon";
GRANT ALL ON TABLE "public"."items_handbook_data" TO "authenticated";
GRANT ALL ON TABLE "public"."items_handbook_data" TO "service_role";

GRANT ALL ON TABLE "public"."items_harvard_list_data" TO "anon";
GRANT ALL ON TABLE "public"."items_harvard_list_data" TO "authenticated";
GRANT ALL ON TABLE "public"."items_harvard_list_data" TO "service_role";

GRANT ALL ON TABLE "public"."items_location_data" TO "anon";
GRANT ALL ON TABLE "public"."items_location_data" TO "authenticated";
GRANT ALL ON TABLE "public"."items_location_data" TO "service_role";

GRANT ALL ON TABLE "public"."items_map_data" TO "anon";
GRANT ALL ON TABLE "public"."items_map_data" TO "authenticated";
GRANT ALL ON TABLE "public"."items_map_data" TO "service_role";

GRANT ALL ON TABLE "public"."items_protected_monuments_data" TO "anon";
GRANT ALL ON TABLE "public"."items_protected_monuments_data" TO "authenticated";
GRANT ALL ON TABLE "public"."items_protected_monuments_data" TO "service_role";

GRANT ALL ON TABLE "public"."items_root" TO "anon";
GRANT ALL ON TABLE "public"."items_root" TO "authenticated";
GRANT ALL ON TABLE "public"."items_root" TO "service_role";

GRANT ALL ON TABLE "public"."ui_column_names" TO "anon";
GRANT ALL ON TABLE "public"."ui_column_names" TO "authenticated";
GRANT ALL ON TABLE "public"."ui_column_names" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";

RESET ALL;
