connection: "thelook_events"
include: "*.view.lkml"

explore: order_items {
  join: orders {
    sql_on: ${orders.id} = ${order_items.order_id} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: users {
    sql_on: ${users.id} = ${orders.user_id} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: user_order_facts {
    sql_on: ${user_order_facts.user_id} = ${users.id} ;;
    type: left_outer
    relationship: one_to_one
  }

  join: inventory_items {
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
    type: left_outer
    relationship: one_to_one
  }

  join: products {
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
    type: left_outer
    relationship: many_to_one
  }

  join:  distribution_centers {
    sql_on: ${distribution_centers.id} = ${inventory_items.distribution_center_id} ;;
    type: left_outer
    relationship: many_to_one
  }
}

explore: products { }

explore: orders { }

explore: user_order_facts { }

explore: users {
  fields: [ALL_FIELDS*, -users.distance_from_distribution_center]
}

explore:distribution_centers { }
