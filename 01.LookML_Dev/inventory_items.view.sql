view: inventory_items {
  sql_table_name: public.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

######## Number Dimensions: ########

  #   You can use dimensions of type: number to perform numeric transformations on other dimensions.
  #   I can add, subtract or transform any columns in my database. For example, if I pay a 6%
  #   tax on all inventory items, I can calculate that using a simple multiplication of 0.06 times the
  #   cost of an item.

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
    value_format_name: usd
  }

  dimension: tax_amount {
    type: number
    sql: ${cost}*0.06  ;;
    value_format_name: usd
  }

  # Now you try!
  # Exercise: Numeric Dimensions
  #         Create a new dimension of type: number, called cost_including_tax, which adds together the
  #         cost and import_tax dimensions into a single field. Be sure to use substitution syntax.


dimension: cost_including_tax {
  type:  number
  sql:  ${cost} + ${tax_amount} ;;
  value_format_name: usd
}


######## Sum and Average Measures: ########

  #   Similar to the sum function in SQL, you can use a measure of type: sum to add values in a field.
  #   For example, to add up the total cost of all inventory items, you would create a new measure
  #   called total cost, set the type to sum, and then reference the cost dimension in the sql parameter.

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

  #   You can also calculate the average value of a set of fields using a measure of type: average.
  #   To find the average cost across inventory items, you would create a new measure called average
  #   cost, set the type to average, and then reference the cost dimension in the sql parameter.

  measure: average_cost {
    type: average
    sql: ${cost} ;;
    value_format_name: usd
  }

  # PRO TIP: For reusability, be sure to use substitution syntax to reference the dimension name when
  #          creating new measures.

  # Now you try!
  # Exercise: Sum and Average Measures
  #         Create two new measures for calculating the sum and average tax amounts.



######## Count Distinct Measures ########

  #   You can use measures of type count_distinct to find the number of unique values in a
  #   given field. You use a sql parameter to indicate which field should be counted.

  #   For example, you can get a count of unique product SKUs that are in inventory by creating a
  #   measure of type count_distinct and specifying the dimension product_sku in the sql parameter.

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  measure: count_distinct_sku {
    type: count_distinct
    sql: ${product_sku} ;;
  }

  # Now you try!
  # Exercise: Count Distinct Measures
  #           Find the unique number of brands represented in inventory.
  #           Brands can be uniquely identified using the product_brand dimension.

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
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

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension_group: sold {
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
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }



  ######## Solutions ########


  # Solution: Numeric Dimensions

  # dimension: cost_plus_tax {
  #   type: number
  #   sql: ${cost} + ${import_tax} ;;
  #   value_format_name: usd
  # }


  # Solution: Count Distinct Measures

  # measure: count_distinct_brands {
  #   type: count_distinct
  #   sql: ${product_brand} ;;
  # }


  # Solution: Count Distinct Measures

  # measure: total_tax_amount {
  #   type: sum
  #   sql: ${tax_amount} ;;
  #   value_format_name: usd
  # }

  # measure: average_tax_amount {
  #   type: average
  #   sql: ${tax_amount} ;;
  #   value_format_name: usd
  # }



}
