import streamlit as st
from snowflake.snowpark.context import get_active_session

session = get_active_session()

st.title("Sales Dashboard")

sales = session.sql("""
SELECT SUM(SALES_AMOUNT)
FROM SALES_DB.DASHBOARD.SALES
""").collect()[0][0]

st.metric(
    "Total Sales",
    f"${sales:,.0f}"
)

regions = session.sql("""
SELECT DISTINCT REGION
FROM SALES_DB.DASHBOARD.SALES
""").to_pandas()

selected_region = st.selectbox(
    "Select Region",
    regions["REGION"]
)

df = session.sql(f"""
SELECT *
FROM SALES_DB.DASHBOARD.SALES
WHERE REGION='{selected_region}'
""").to_pandas()

st.subheader("Sales Data")

st.dataframe(df)

chart_df = session.sql(f"""
SELECT
PRODUCT,
SUM(SALES_AMOUNT) SALES
FROM SALES_DB.DASHBOARD.SALES
WHERE REGION='{selected_region}'
GROUP BY PRODUCT
""").to_pandas()

st.subheader("Sales By Product")

st.bar_chart(
    chart_df,
    x="PRODUCT",
    y="SALES"
)

daily_sales = session.sql("""
SELECT
SALE_DATE,
SUM(SALES_AMOUNT) SALES
FROM SALES_DB.DASHBOARD.SALES
GROUP BY SALE_DATE
ORDER BY SALE_DATE
""").to_pandas()

st.subheader("Daily Trend")

st.line_chart(
    daily_sales,
    x="SALE_DATE",
    y="SALES"
)