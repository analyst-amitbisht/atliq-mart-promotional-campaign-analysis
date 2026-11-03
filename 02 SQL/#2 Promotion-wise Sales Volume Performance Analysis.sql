SELECT
    promo_type,

    SUM(quantity_sold_before_promo) AS units_before,

    SUM(quantity_sold_after_promo) AS units_after,

    SUM(quantity_sold_after_promo)
        - SUM(quantity_sold_before_promo) AS incremental_units,

    ROUND(
        (
            SUM(quantity_sold_after_promo)::NUMERIC
            / NULLIF(SUM(quantity_sold_before_promo), 0)
            - 1
        ) * 100,
        2
    ) AS sales_uplift_pct

FROM fact_events

GROUP BY promo_type

ORDER BY sales_uplift_pct DESC;