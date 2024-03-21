-- v0 -> v12: Latest revision
CREATE TABLE signalmeow_device (
    aci_uuid              TEXT PRIMARY KEY,

    aci_identity_key_pair bytea   NOT NULL,
    registration_id       INTEGER NOT NULL CHECK ( registration_id >= 0 AND registration_id < 4294967296 ),

    pni_uuid              TEXT    NOT NULL,
    pni_identity_key_pair bytea   NOT NULL,
    pni_registration_id   INTEGER NOT NULL CHECK ( pni_registration_id >= 0 AND pni_registration_id < 4294967296 ),

    device_id             INTEGER NOT NULL,
    number                TEXT    NOT NULL DEFAULT '',
    password              TEXT    NOT NULL DEFAULT ''
);

CREATE TABLE signalmeow_pre_keys (
    account_id TEXT    NOT NULL,
    service_id TEXT    NOT NULL,
    key_id     INTEGER NOT NULL,
    is_signed  BOOLEAN NOT NULL,
    key_pair   bytea   NOT NULL,

    PRIMARY KEY (account_id, service_id, key_id, is_signed),
    FOREIGN KEY (account_id) REFERENCES signalmeow_device (aci_uuid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE signalmeow_kyber_pre_keys (
    account_id     TEXT    NOT NULL,
    service_id     TEXT    NOT NULL,
    key_id         INTEGER NOT NULL,
    key_pair       bytea   NOT NULL,
    is_last_resort BOOLEAN NOT NULL,

    PRIMARY KEY (account_id, service_id, key_id),
    FOREIGN KEY (account_id) REFERENCES signalmeow_device (aci_uuid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE signalmeow_identity_keys (
    account_id       TEXT    NOT NULL,
    their_service_id TEXT    NOT NULL,
    key              bytea   NOT NULL,
    trust_level      TEXT    NOT NULL,

    PRIMARY KEY (account_id, their_service_id),
    FOREIGN KEY (account_id) REFERENCES signalmeow_device (aci_uuid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE signalmeow_sessions (
    account_id       TEXT    NOT NULL,
    service_id       TEXT    NOT NULL,
    their_service_id TEXT    NOT NULL,
    their_device_id  INTEGER NOT NULL,
    record           bytea   NOT NULL,

    PRIMARY KEY (account_id, service_id, their_service_id, their_device_id),
    FOREIGN KEY (account_id) REFERENCES signalmeow_device (aci_uuid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE signalmeow_profile_keys (
    account_id     TEXT  NOT NULL,
    their_aci_uuid TEXT  NOT NULL,
    key            bytea NOT NULL,

    PRIMARY KEY (account_id, their_aci_uuid),
    FOREIGN KEY (account_id) REFERENCES signalmeow_device (aci_uuid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE signalmeow_sender_keys (
    account_id       TEXT    NOT NULL,
    sender_uuid      TEXT    NOT NULL, -- note: this may actually be a service id
    sender_device_id INTEGER NOT NULL,
    distribution_id  TEXT    NOT NULL,
    key_record       bytea   NOT NULL,

    PRIMARY KEY (account_id, sender_uuid, sender_device_id, distribution_id),
    FOREIGN KEY (account_id) REFERENCES signalmeow_device (aci_uuid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE signalmeow_groups (
    account_id     TEXT NOT NULL,
    group_identifier TEXT NOT NULL,
    master_key       TEXT NOT NULL,

    PRIMARY KEY (account_id, group_identifier)
);

CREATE TABLE signalmeow_contacts (
    account_id          TEXT   NOT NULL,
    aci_uuid            TEXT   NOT NULL,
    e164_number         TEXT   NOT NULL,
    contact_name        TEXT   NOT NULL,
    contact_avatar_hash TEXT   NOT NULL,
    profile_key         bytea,
    profile_name        TEXT   NOT NULL,
    profile_about       TEXT   NOT NULL,
    profile_about_emoji TEXT   NOT NULL,
    profile_avatar_path TEXT   NOT NULL,
    profile_fetched_at  BIGINT,

    PRIMARY KEY (account_id, aci_uuid),
    FOREIGN KEY (account_id) REFERENCES signalmeow_device (aci_uuid) ON DELETE CASCADE ON UPDATE CASCADE
);
