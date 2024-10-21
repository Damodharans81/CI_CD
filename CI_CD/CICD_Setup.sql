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


CREATE OR REPLACE PROCEDURE {{dbname}}.GIT.DEPLOY_CHANGES(DB_NAME VARCHAR,REPO_NAME VARCHAR, REPO_PATH VARCHAR, FILELIST VARCHAR)
  RETURNS STRING
    LANGUAGE JAVASCRIPT
    STRICT
    EXECUTE AS CALLER
  AS     
  $$ 
  try 
  {

  var sql_command = `INSERT INTO CI_CD.CHANGE_HISTORY(VERSION_ID, SCRIPT,MODIFIED_DATE) 
            SELECT -1,  :2 || table1.value as script, current_timestamp() 
            FROM table(split_to_table(:1, '|')) AS table1
            where table1.value !=''and CONTAINS(table1.value, '.sql') =true
            order by table1.value asc;`;
    var stmt = snowflake.createStatement(
              {
              sqlText: sql_command,
              binds: [FILELIST,REPO_PATH]
              }
              );
    stmt.execute();

    //Refresh the Repo to get the latest files
   var sql_command = "ALTER GIT REPOSITORY " + REPO_NAME + " FETCH";
        
   var stmt = snowflake.createStatement(
      {
      sqlText: sql_command
      }
      );
   stmt.execute();

    // Generate a new number
    var release_no = snowflake.execute({sqlText: "select MAX(COALESCE(VERSION_ID,0)) as version_no from CI_CD.CHANGE_HISTORY;"});
    release_no.next();
    var ver_id = release_no.getColumnValue(1) + 1;
    
    sql_command = "Select CHANGE_ID, SCRIPT from CI_CD.CHANGE_HISTORY where VERSION_ID = -1 and STATUS = 'Initiated' ";
    stmt = snowflake.createStatement( {sqlText: sql_command} );
    result_set1 = stmt.execute();   
    
    // Loop through the change file list and deploy the files, processing one row at a time... 
    while (result_set1.next())  
    {

    try{
               var change_id = result_set1.getColumnValue(1);
               var filename = result_set1.getColumnValue(2);
        
               sql_command = "EXECUTE IMMEDIATE FROM " + filename +" USING (dbname =>'"+ DB_NAME + "');";       
         
               snowflake.execute ( {sqlText: sql_command} );
        
               sql_command = `Update CI_CD.CHANGE_HISTORY
                                SET VERSION_ID = :1,                       
                                    STATUS = 'Deployed',
                                    INSTALLED_BY = 'CI_CD',
                                    INSTALLED_ON = current_timestamp()
                                where CHANGE_ID =:2`;
        
               stmt = snowflake.createStatement(
                  {
                  sqlText: sql_command,
                  binds: [ver_id,change_id]
                  }
                  );
               stmt.execute();
        }
       catch(err1)
       {

           sql_command = `Update CI_CD.CHANGE_HISTORY
                            SET STATUS = 'Deployment FAILED',
                            INSTALLED_BY = 'CI_CD',
                            INSTALLED_ON = current_timestamp()
                            where CHANGE_ID =:1`;
    
           stmt = snowflake.createStatement(
              {
              sqlText: sql_command,
              binds: [change_id]
              }
           )
           stmt.execute();
           
       }
    }
    
    return "Succeeded.";   // Return a success indicator.
        
    }
    catch (err)  
    {
        return "Failed: " + err;   // Return a error indicator.
    }
$$
;
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