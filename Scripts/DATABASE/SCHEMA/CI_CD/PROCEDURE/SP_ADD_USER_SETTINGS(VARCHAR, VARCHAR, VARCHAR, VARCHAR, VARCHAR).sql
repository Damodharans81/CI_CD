#!jinja 

CREATE OR REPLACE PROCEDURE {{ database }}.CI_CD.SP_ADD_USER_SETTINGS("SF_USER_LOGIN" VARCHAR(16777216), "USER_ID" VARCHAR(16777216), "PAT" VARCHAR(16777216), "REPO" VARCHAR(16777216), "BRANCH" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
DECLARE
    existing_id INT;
BEGIN
    -- Check if a record with the given name already exists
    SELECT COALESCE(id,0) INTO :existing_id FROM settings WHERE SF_Username = :sf_user_login;
    
    IF (:existing_id IS NOT NULL) THEN
        
        UPDATE settings
        SET GIT_USERID = :user_id,
            GIT_PAT = :pat,
            DEFAULT_REPO = :repo,
            DEFAULT_BRANCH = :branch,
            LAST_MODIFIED = CURRENT_TIMESTAMP()
        WHERE id = :existing_id;
        
        RETURN ''User settings updated successfully'';
    ELSE
        -- Insert new entry  
        INSERT INTO settings(SF_Username,GIT_USERID, GIT_PAT, DEFAULT_REPO, DEFAULT_BRANCH)
        VALUES(:sf_user_login,:user_id, :pat, :repo, :branch);
        
        RETURN ''New user settings added successfully.'';
    END IF;
END;
';