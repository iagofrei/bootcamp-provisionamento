DROP DATABASE dbgp3 IF EXISTS;
CREATE DATABASE dbgp3;
USE dbgp3;

CREATE TABLE s3_notification_event (
    event_name  VARCHAR(100),
    bucket_name VARCHAR(64),
    object_name VARCHAR(300),
    user_name   VARCHAR(100),
    updated_at  TIMESTAMP
);