SELECT
    SUM(quantity_sold_before_promo) AS total_units_before,

    SUM(quantity_sold_after_promo) AS total_units_after,

    SUM(quantity_sold_after_promo)
        - SUM(quantity_sold_before_promo) AS incremental_units,

    ROUND(
        (
            SUM(quantity_sold_after_promo)::NUMERIC
            - SUM(quantity_sold_before_promo)
        ) / NULLIF(
            SUM(quantity_sold_before_promo), 0
        ) * 100,
        2
    ) AS sales_uplift_pct

FROM fact_events;