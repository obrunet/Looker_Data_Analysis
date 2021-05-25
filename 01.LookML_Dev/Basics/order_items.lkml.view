view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format_name: id
  }

  dimension: order_id {
    type: number
    hidden: yes
    sql: ${TABLE}.order_id ;;
    value_format_name: id
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
    value_format_name: id
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  dimension: price_range {
    case: {
      when: {
        sql: ${sale_price} < 20 ;;
        label: "Inexpensive"
      }
      when: {
        sql: ${sale_price} >= 20 AND ${sale_price} < 100 ;;
        label: "Normal"
      }
      when: {
        sql: ${sale_price} >= 100 ;;
        label: "Expensive"
      }
      else: "Unknown"
    }
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    html:
      {% if value == 'Complete' %}
        <div style="background-color:#D5EFEE">{{ value }}</div>
      {% elsif value == 'Processing' or value == 'Shipped' %}
        <div style="background-color:#FCECCC">{{ value }}</div>
      {% elsif value == 'Cancelled' or value == 'Returned' %}
        <div style="background-color:#EFD5D6">{{ value }}</div>
      {% endif %}
    ;;
  }

  measure: count {
    type: count
    drill_fields: [
      id,
      created_time,
      shipped_time,
      delivered_time,
      returned_time,
      sale_price,
      status,
      products.name
    ]
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Sale Price"
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Sale Price"
  }

  measure: least_expensive_item {
    type: min
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Sale Price"
  }

  measure: most_expensive_item {
    type: max
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Sale Price"
  }

  parameter: sale_price_metric_picker {
    description: "Use with the Sale Price Metric measure"
    type: unquoted
    allowed_value: {
      label: "Total Sale Price"
      value: "SUM"
    }
    allowed_value: {
      label: "Average Sale Price"
      value: "AVG"
    }
    allowed_value: {
      label: "Maximum Sale Price"
      value: "MAX"
    }
    allowed_value: {
      label: "Minimum Sale Price"
      value: "MIN"
    }
  }

  measure: sale_price_metric {
    description: "Use with the Sale Price Metric Picker filter-only field"
    type: number
    label_from_parameter: sale_price_metric_picker
    sql: {% parameter sale_price_metric_picker %}(${sale_price}) ;;
    value_format_name: usd
  }

  filter: category_count_picker {
    description: "Use with the Category Count measure"
    type: string
    suggest_explore: order_items_warehouse
    suggest_dimension: products.category
  }

  measure: category_count {
    description: "Use with the Category Count Picker filter-only field"
    type: sum
    sql:
      CASE
        WHEN {% condition category_count_picker %} ${products.category} {% endcondition %}
        THEN 1
        ELSE 0
      END
    ;;
  }

  measure: total_profit {
    type: number
    sql: ${total_sale_price} - ${products.total_cost} ;;
    value_format_name: usd
  }
}
