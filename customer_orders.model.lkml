connection: "performance_test_pg"
explore: customer_order_facts {}
view: customer_order_facts {
  derived_table: {
    sql:
      WITH constants AS (
        SELECT 2 as customer_id, '1900-01-01 00:00:00.000' as time, 12.34 as amount UNION ALL
        SELECT 1 as customer_id, '1900-01-02 00:00:02.000' as time, 12.34 as amount UNION ALL
        SELECT 2 as customer_id, '1900-01-01 00:00:04.000' as time, 45.56 as amount
      )
      SELECT
        customer_id,
        MIN(DATE(time)) AS first_order_date,
        SUM(amount) AS lifetime_amount
      FROM constants
      GROUP BY
        customer_id ;;
  }
  dimension: customer_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.customer_id ;;
  }
  dimension_group: first_order {
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.first_order_date ;;
  }
  dimension: lifetime_amount {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.lifetime_amount ;;
  }
}
