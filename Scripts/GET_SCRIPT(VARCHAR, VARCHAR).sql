CREATE OR REPLACE PROCEDURE {{ database }}.CI_CD.GET_SCRIPT("OBJ_TYPE" VARCHAR(16777216), "OBJ_NAME" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS OWNER
AS '
   var sql = "select get_ddl (''" + OBJ_TYPE + "'', ''" + OBJ_NAME + "'',true)" ;
   var st1= snowflake.createStatement( { sqlText: sql } );
   
   var resultSet = st1.execute();
   resultSet.next();
   var v_result = resultSet.getColumnValue(1);
   
   return v_result;
';