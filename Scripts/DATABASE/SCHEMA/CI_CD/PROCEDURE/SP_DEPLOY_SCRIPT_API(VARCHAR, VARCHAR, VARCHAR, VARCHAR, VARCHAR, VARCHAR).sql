#!jinja 

CREATE OR REPLACE PROCEDURE {{ database }}.CI_CD.SP_DEPLOY_SCRIPT_API("GIT_USERID" VARCHAR(16777216), "GIT_PAT" VARCHAR(16777216), "GIT_REPO" VARCHAR(16777216), "BRANCH_NAME" VARCHAR(16777216), "SCRIPT_FILE" VARCHAR(16777216), "TARGET_DB_NAME" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS '

    var scripts_status = '''';
    try 
    {
        var sql_command = `
            with obj_dependencies as
                (
                    select Concat(cat.object_catalog,''.'',cat.object_schema,''.'',cat.object_name)as Full_Qualified_Name,
                    cat.Object_CATALOG,OBJECT_SCHEMA,OBJECT_NAME,TYPE,SCRIPT_PATH 
                    from {{ database }}.CI_CD.CATALOG cat    
                ),
                
                deployable as
                (
                    SELECT 
                    s.Object_CATALOG,s.OBJECT_SCHEMA,s.OBJECT_NAME,s.TYPE,s.SCRIPT_PATH,
                    f.value::VARCHAR AS dependent_object,
                    CASE
                    WHEN f.value IS NULL THEN NULL
                    ELSE ROW_NUMBER() OVER(PARTITION BY s.object_name ORDER BY f.index)
                    END AS SEQ_ID
                    FROM 
                    {{ database }}.CI_CD.CATALOG  s
                    LEFT JOIN LATERAL FLATTEN(input => parse_json(s.DOWNSTREAM_DEPENDENCY), OUTER => TRUE) f 
                    where s.SCRIPT_PATH = :1
                )  ,
                tmp_Deployable as
                (  Select DISTINCT SCRIPT_PATH as Script, 0 as SEQ_ID from deployable 
                    union all
                    Select od.SCRIPT_PATH as script,d.Seq_id from obj_dependencies od
                    inner join deployable d on d.dependent_object  = od.Full_Qualified_Name
                    order by seq_ID
                )            
                Select Script from tmp_Deployable order by SEQ_ID asc 
                `;
        
        var statement1 = snowflake.createStatement(
                                        {sqlText: sql_command,
                                        binds: [SCRIPT_FILE]
                                        }
                                        );
    
    
        var result_set = statement1.execute();
    
        
        
        // Process the result set if needed
        while (result_set.next()) 
        {
            var script_path = result_set.getColumnValue(1);
    
           //var script_abspath =  BRANCH_NAME + script_path;    
            // var cmd = "EXECUTE IMMEDIATE FROM ''" + script_abspath + "'' USING (database => ''"+ TARGET_DB_NAME + "'')";
            
            var cmd = "CALL CI_CD.SP_Deploy_ScriptToDB(?,?,?,?,?,?)";
            var stmt = snowflake.createStatement({ sqlText: cmd , binds:[GIT_USERID,GIT_PAT,GIT_REPO,BRANCH_NAME,script_path,TARGET_DB_NAME]} );
            stmt.execute();   
    
            scripts_status = scripts_status  + script_path + '';\n'';
            
        }
    
        scripts_status = scripts_status + ''\n were deployed SUCCESSFULLY!!! :\n'' ;

    } catch (err) 
    {
    
    scripts_status = "ERROR while deploying file : " + SCRIPT_FILE+ " \n Exception: " + err;
    
    }
    
    return  scripts_status;
';