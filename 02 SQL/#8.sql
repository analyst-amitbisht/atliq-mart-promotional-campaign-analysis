-- Products above ₹500 under BOGOF
SELECT DISTINCT
    p.product_code,
    p.product_name,
    f.base_price,
    f.promo_type
FROM fact_events f
JOIN dim_products p
    ON f.product_code = p.product_code
WHERE f.base_price > 500
  AND f.promo_type = 'BOGOF'
ORDER BY f.base_price DESC;

-- Store count by city

SELECT
    city,
    COUNT(DISTINCT store_id) AS total_stores
FROM dim_stores
GROUP BY city
ORDER BY total_stores DESC, city;

-- Diwali Category-wise ISU%
WITH diwali_category AS (
    SELECT
        p.category,
        SUM(f.quantity_sold_before_promo) AS units_before_promo,
        SUM(f.quantity_sold_after_promo) AS units_after_promo,
        SUM(f.quantity_sold_after_promo)
            - SUM(f.quantity_sold_before_promo) AS incremental_units
    FROM fact_events f
    JOIN dim_campaigns c
        ON f.campaign_id = c.campaign_id
    JOIN dim_products p
        ON f.product_code = p.product_code
    WHERE c.campaign_name = 'Diwali'
    GROUP BY p.category
)
SELECT
    category,
    units_before_promo,
    units_after_promo,
    incremental_units,
    ROUND(
        incremental_units::numeric
        / NULLIF(units_before_promo, 0) * 100,
        2
    ) AS isu_pct,
    RANK() OVER (
        ORDER BY
            incremental_units::numeric
            / NULLIF(units_before_promo, 0) DESC
    ) AS category_rank
FROM diwali_category
ORDER BY category_rank, category;