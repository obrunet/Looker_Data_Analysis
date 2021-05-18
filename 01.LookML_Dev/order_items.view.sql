view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }


  dimension: history_button {
    sql: ${TABLE}.id ;;
    html: <a href=
      "/explore/getting_started_with_lookml/order_items?fields=users.id,order_items.count,orders.created_date,inventory_items.product_id,inventory_items.cost*&f[order_items.order_id]={{ value }}"
      ><button>Order History</button></a>;;
  }


######## Timeframe and Duration Dimensions ########

  #   Dates and timestamps can be represented in Looker using a dimension group of type: time.
  #   Looker converts dates and timestamps to any specified timeframes within the dimension group.

  #   Dimension groups of type: duration can be used to calculate the time between two timestamps.
  #   This can be done using system timestamps or timestamp dimensions within your database.
  #   For example, we can examine the efficiency of our order fulfillment process by calculating the
  #   difference between the time that an order was created and the time in which it shipped.  We show this
  #   in the dimension group "fulfillment" below.

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

  # same thing with created

  dimension_group: fulfillment {
    type: duration
    intervals: [
      hour,
      day,
      week
    ]
    sql_start: ${created_raw} ;;
    sql_end: ${shipped_raw} ;;
  }

  # PRO TIP: Use the raw timeframe when calculating durations.  This will utilize the untransformed timestamp
  #         that exists in the underlying database.

  # Now you try!
  # Exercise: Duration Dimensions
  #           Analyze the efficiency of our shipping service by calculating the difference between
  #           the time that an order was shipped and the time in which it was delivered.

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

  dimension_group: shippingefficiency {
    type: duration
    intervals: [
      hour,
      day,
      week
    ]
    sql_start: ${delivered_raw} ;;
    sql_end: ${shipped_raw} ;;
  }





######## YesNo Dimensions ########

  #   We can use dimensions of type yesno to create boolean logic and indicate whether something is
  #   true or false. In the sql parameter, define the yes (or true) condition.

  #   For example, we can flag orders that took over 7 days to fulfill by defining ${days_fulfillment} > 7
  #   as the yes condition in our sql parameter.

  dimension: long_fulfillment {
    description: "Yes means the order took over 7 days to fulfill."
    type: yesno
    sql: ${days_fulfillment} > 7 ;;
  }

  # Now you try!
  # Exercise: YesNo Dimensions
  #           Flag any items that were returned by creating a YesNo dimension based on the Status field.
  #           If an item has been returned, it will appear as 'Returned'.

  dimension: status {
    description: "Status could be Cancelled, Returned, Complete, Processing, or Shipped"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: return_flag {
    description: "Flag any itmens that is returned"
    type:  yesno
    sql:  ${status} == "Returned ;;
  }




  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    label: "Number of order items"
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      orders.id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }






  ######## Solutions ########


  # Solution: Duration Dimensions

  # dimension_group: in_transit {
  #   type: duration
  #   timeframes: [
  #     raw,
  #     hour,
  #     date
  #   ]
  #   sql_start: ${shipped_raw} ;;
  #   sql_end: ${delivered_raw} ;;
  # }


  # Solution: YesNo Dimensions

  # dimension: item_was_returned {
  #   type: yesno
  #   sql: ${status} = 'Returned' ;;
  # }


}
