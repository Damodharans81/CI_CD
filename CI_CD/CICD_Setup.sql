#!jinja

CREATE DATABASE IF NOT EXISTS {{dbname}};

CREATE SCHEMA IF NOT EXISTS {{dbname}}.CI_CD;

CREATE OR ALTER TABLE {{dbname}}.CI_CD.CONFIG 
(
    ID NUMBER(38, 0) AUTOINCREMENT START 1 INCREMENT 1,
    TYPE VARCHAR,
    SEQ_ORDER NUMBER(38, 0) NULL,
    LASTMODIFIED_DATE  TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT OVERWRITE INTO {{dbname}}.CI_CD.CONFIG (TYPE,SEQ_ORDER)
  VALUES
  ('DATABASE',1),
  ('SCHEMA',2),
  ('TABLE',3),
  ('STORED_PROCEDURE',4),
  ('VIEW',5);

CREATE TABLE IF NOT EXISTS {{dbname}}.CI_CD.CHANGE_HISTORY 
(

    CHANGE_ID NUMBER(38, 0) AUTOINCREMENT START 1 INCREMENT 1,
    VERSION_ID NUMBER(38, 0) NULL,
    DESCRIPTION VARCHAR,
    SCRIPT VARCHAR,
    SCRIPT_TYPE VARCHAR,
    MODIFIED_DATE  TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP(),
    STATUS VARCHAR,
    INSTALLED_BY VARCHAR,
    INSTALLED_ON TIMESTAMP_LTZ
);

- DDL for the Sequence object
CREATE OR REPLACE SEQUENCE {{dbname}}.CI_CD.RELEASE_SEQ START = 1 INCREMENT = 1 ORDER;


-- CREATE OR REPLACE PROCEDURE {{dbname}}.CI_CD.Deploy_PROC
-- (RELEASE_TITLE VARCHAR(500))
-- // Fetch the latest updates from Github
-- snowflake.execute({sqlText: " ALTER GIT REPOSITORY ATOBIN_GIT_REPO FETCH;"});
-- // Generate a new number from our sequence to associate with the release.
-- release_no = snowflake.execute({sqlText: "select common.release_seq.nextval;"});
-- release_no = release_no.getColumnValue(1);
-- // Retrieve a list of files to be deployed in this release.
-- deploy_files = snowflake.execute({sqlText: "Select $1 from @ATOBIN_GIT_REPO/branches/main/gitint/deploy.sql"});
-- file_counter = deploy_files.getRowCount();
-- // If files are listed, deploy the code and make an entry into the log table.
-- result = "No files specified for release";
-- for (i=0; i < file_counter; i++)
-- deploy_file = deploy_files.getColumnValue(1);
-- //{Placeholder for testing logic}
-- snowflake.execute({sqlText: `execute immediate from @atobin_git_repo/branches/main${deploy_file}`});
-- snowflake.execute({sqlText: `
-- insert into COMMON.RELEASE_LOG(RELEASE_NO, RELEASE_TITLE, FILE_NAME, RELEASED_BY, RELEASE_TIMESTAMP) values
-- (${release_no}, '${RELEASE_TITLE}', '${deploy_file}', current_user(), current_timestamp())`

-- });