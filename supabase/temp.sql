CREATE EXTENSION IF NOT EXISTS "uuid-ossp" schema public;

CREATE DOMAIN site_type AS TEXT
    CHECK (
        VALUE IN ('church', 'palace', 'house', 'monument', 'cultural institution')
    );

CREATE DOMAIN star_count AS INTEGER
    CHECK (
        VALUE >= 0 AND VALUE <= 4
    );

CREATE DOMAIN location_type AS TEXT
    CHECK (
        VALUE IN ('point', 'polygon')
    );

CREATE DOMAIN association_type AS TEXT
    CHECK (
        VALUE IN ('within', 'contains', 'near')
    );

CREATE TABLE items_root (
        internal_id uuid PRIMARY KEY DEFAULT extensions.uuid_generate_v4(),
        name TEXT,
        alternative_names TEXT[],
        associated_with UUID REFERENCES items_root(internal_id),
        association_type association_type,
        notes TEXT[],
        period TEXT,
        photograph_links TEXT[],
        coordinates TEXT[],
        town_id INT REFERENCES towns_location_data(id)
);

CREATE TABLE items_town_location_data (
        id INT AUTO_INCREMENT PRIMARY KEY,
        town TEXT NOT NULL,
        region TEXT NOT NULL,
        province TEXT NOT NULL,
        country TEXT NOT NULL,
        location_type location_type NOT NULL,
        coordinates TEXT[],
        CONSTRAINT ch_items_town_location_data_c0 UNIQUE(town, region, province)
);

CREATE TABLE items_harvard_list_data (
    id UUID REFERENCES items_root (internal_id)  ON DELETE CASCADE,
    long_list_stars star_count,
    long_list_text TEXT,
    short_list_text TEXT
);

CREATE TABLE items_map_data (
    id UUID REFERENCES items_root (internal_id)  ON DELETE CASCADE,
    acls_name TEXT,
    acls_location_type site_type,
    acls_stars star_count,
    acls_grid_reference TEXT,
    acls_address TEXT,
    acls_atlas_text TEXT,
    acls_map_links TEXT[],

    ca_atlas_title TEXT,
    ca_atlas_type site_type,
    ca_atlas_stars star_count,
    ca_atlas_grid_reference TEXT,
    ca_atlas_address TEXT,
    ca_atlas_text TEXT,
    ca_atlas_links TEXT[]
);

CREATE TABLE items_handbook_data (
    id UUID REFERENCES items_root (internal_id)  ON DELETE CASCADE,
    ca_hb_name TEXT CHECK (ca_hb_name IN ('17A', '17B')),
    ca_hb_type site_type,
    ca_hb_stars star_count,
    ca_hb_address TEXT,
    ca_hb_text TEXT,

    zone_hb_volume TEXT,
    zone_hb_number INT8,
    zone_hb_aux_list BOOL,
    zone_hb_text TEXT
);

CREATE TABLE items_protected_monuments_data (
    id UUID REFERENCES items_root (internal_id)  ON DELETE CASCADE,
    lpm_volume INT8,
    lpm_stars star_count,
    lpm_military_grid TEXT,
    lpm_text TEXT
);

CREATE TABLE items_wartime_damage_data (
    town_id UUID REFERENCES towns (id) ON DELETE CASCADE,
    damage TEXT,
    bibliography_damage TEXT
);

CREATE TABLE ui_column_names (
    field TEXT PRIMARY KEY,
    headerName TEXT,
    filter BOOL DEFAULT TRUE,
    sortable BOOL DEFAULT TRUE,
    type TEXT DEFAULT 'text'
);