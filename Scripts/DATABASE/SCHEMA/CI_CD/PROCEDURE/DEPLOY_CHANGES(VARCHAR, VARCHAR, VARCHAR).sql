#!jinja 

CREATE OR REPLACE PROCEDURE {{ database }}.CI_CD.DEPLOY_CHANGES("DATABASENAME" VARCHAR(16777216), "REPO_PATH" VARCHAR(16777216), "SCRIPT" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS 'DECLARE
  query VARCHAR;
BEGIN

    query :=  concat(:repo_path,:script,'' using ( dbname=>'''''',:databasename,'''''' ) '') ; 

    -- execute immediate from :query;
    

    
    RETURN query;--''Finished Deploying Changes Successfully'';
  
END';