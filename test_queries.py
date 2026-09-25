import duckdb

con = duckdb.connect('C:/Users/harsh/dbt-ecommerce-pipeline/ecommerce_pipeline/dev.duckdb')

queries = {
    "1. Monthly Revenue": """
        SELECT DATE_TRUNC('month', first_order_date) AS order_month,
               COUNT(DISTINCT customer_unique_id) AS new_customers,
               ROUND(SUM(lifetime_value), 2) AS total_revenue
        FROM mart_customer_orders
        WHERE first_order_date IS NOT NULL
        GROUP BY 1 ORDER BY 1 LIMIT 5
    """,
    "2. Top 10 Customers": """
        SELECT customer_unique_id, customer_state, total_orders,
               ROUND(lifetime_value, 2) AS lifetime_value
        FROM mart_customer_orders
        ORDER BY lifetime_value DESC LIMIT 10
    """,
    "3. Customer Segments": """
        SELECT CASE WHEN total_orders = 1 THEN '1-One-time'
                    WHEN total_orders BETWEEN 2 AND 3 THEN '2-3-Occasional'
                    WHEN total_orders BETWEEN 4 AND 6 THEN '4-6-Regular'
                    ELSE '7+-Loyal' END AS segment,
               COUNT(*) AS customer_count,
               ROUND(AVG(lifetime_value), 2) AS avg_ltv
        FROM mart_customer_orders GROUP BY 1 ORDER BY 2 DESC
    """,
    "4. Revenue by State": """
        SELECT customer_state,
               COUNT(DISTINCT customer_unique_id) AS total_customers,
               ROUND(SUM(lifetime_value), 2) AS total_revenue
        FROM mart_customer_orders
        GROUP BY 1 ORDER BY total_revenue DESC LIMIT 10
    """,
    "5. Repeat Rate by State": """
        SELECT customer_state, COUNT(*) AS total_customers,
               SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
               ROUND(100.0 * SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS repeat_rate_pct
        FROM mart_customer_orders
        GROUP BY 1 HAVING COUNT(*) > 100 ORDER BY repeat_rate_pct DESC LIMIT 5
    """
}

for name, sql in queries.items():
    print(f"\n--- {name} ---")
    print(con.execute(sql).fetchdf())