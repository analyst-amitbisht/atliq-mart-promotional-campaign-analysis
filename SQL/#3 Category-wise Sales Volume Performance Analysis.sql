SELECT
    p.category,

    SUM(f.quantity_sold_before_promo) AS units_before,

    SUM(f.quantity_sold_after_promo) AS units_after,

    SUM(f.quantity_sold_after_promo)
        - SUM(f.quantity_sold_before_promo) AS incremental_units,

    ROUND(
        (
            SUM(f.quantity_sold_after_promo)::NUMERIC
            / NULLIF(SUM(f.quantity_sold_before_promo), 0)
            - 1
        ) * 100,
        2
    ) AS sales_uplift_pct

FROM fact_events f

JOIN dim_products p
    ON f.product_code = p.product_code

GROUP BY p.category

ORDER BY sales_uplift_pct DESC;