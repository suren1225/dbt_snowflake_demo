1. Go to project folder
cd c:\dbt-demo

2. Activate environment (if using venv)
python -m venv dbt-env
dbt-env\Scripts\activate

cd C:\dbt-demo\dbt_snowflake_demo

3. Check dbt connection, Clear local cache,Install packages, Show final SQL
dbt debug
dbt clean
dbt deps
dbt compile

4. Load seed data (reference tables)
dbt seed

5. Load RAW → STAGING models
dbt run --select staging

6. Run STAGING tests
dbt test --select staging

7. Build INTERMEDIATE layer
dbt run --select intermediate

8. Test INTERMEDIATE layer (custom + generic)
dbt test --select intermediate

9. Run SNAPSHOTS (if you created them)
dbt snapshot

10. Build MARTS layer
dbt run --select marts

11. Run MART tests (relationships + validations)
dbt test --select marts

12. Run FULL PIPELINE - Rebuild everything
dbt build --full-refresh

13. Run FULL PIPELINE 
dbt build

14. Run custom SQL tests
dbt test --select test_type:singular

15. Generate documentation
dbt docs generate

16. Serve dbt documentation UI
dbt docs serve --host 0.0.0.0 --port 8081

 http://localhost:8081
 
Note:
====
dbt run (all models)
dbt run --select stg_orders+ (downstream)
dbt run --select +mart_daily_sales (upstream)
dbt run --select models/mart (sepcific model all files)
dbt run --select models/mart/mart_customer_history  (sepcific model file)


--git integration
================
bash

cd C:\dbt-demo\dbt_snowflake_demo
git init
git status
git remote add origin https://github.com/suren1225/dbt_snowflake_demo.git
git remote -v
git add .
git commit -m "initial dbt snowflake project"
git branch -M main
git push -u origin main
