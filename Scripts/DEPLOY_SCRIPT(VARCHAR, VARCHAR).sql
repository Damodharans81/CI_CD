CREATE OR REPLACE PROCEDURE {{ database }}.CI_CD.DEPLOY_SCRIPT("DB_NAME" VARCHAR(16777216), "FILENAME" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS '
var result = "";
try 
{
     var sql_command = `EXECUTE IMMEDIATE FROM :1 USING (dbname =>:2);` 
    // Bind a VARCHAR, a TIMESTAMP_LTZ, a numeric to our INSERT statement.
    result = snowflake.execute(
        { 
        sqlText: sql_command, 
        binds: [FILENAME,DB_NAME] 
        }
        );
   
 
    result = "Succeeded";
} 
catch  (err) 
{
  result =  "Failed: Code: " + err.code + "\n  State: " + err.state;
          result += "\n  Message: " + err.message;
          result += "\nStack Trace:\n" + err.stackTraceTxt; 
}
return result;
';