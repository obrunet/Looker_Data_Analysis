view: user_order_facts {
  derived_table: {
    sql:
      SELECT
        user_id,
        MIN(DATE(created_at)) AS first_order_date
      FROM
        orders
      GROUP BY
        user_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    primary_key: yes
    hidden: yes
  }

  dimension: first_order_date {
    type: date
    sql: ${TABLE}.first_order_date ;;
  }
}
