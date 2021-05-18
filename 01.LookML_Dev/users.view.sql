view: users {
  sql_table_name: public.users ;;

######## String Dimensions: ########

  #   You can create additional fields that do not already exist in our database, like the dimension full_name.
  #   full_name concatinates together the fields ${first_name} and ${last_name}. Because this database is Redshift,
  #   you need to use the Redshift || syntax to concatinate. Notice how you are using substitution syntax to
  #   reference ${first_name} instead of ${TABLE}.first_name

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
  }




  # Now you try!
  # Exercise: String Dimensions
  #           Create a new dimension called city_state that concatinates together the dimensions city
  #           and state with a comma between (Ex: Santa Cruz, California). Be sure to use substitution
  #           syntax to reference the dimensions.

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  dimension: city_state {
    type:  string
    sql:  ${city} || ', ' || ${state};;
  }



######## Tier Dimensions: ########

  #   Tier dimensions can be used to break out numeric dimensions into number ranges. For example, you can
  #   split the age dimension out into ten year intervals (10-20, 20-30, etc.).

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80]
    style: integer
    sql: ${age} ;;
  }

  # Now you try!
  # Exercise: Tier Dimensions
  #           Create a tier dimension that buckets users based on the number of months since they signed up on
  #           our website. The tiers should include the following intervals: 0-1, 1-3, 3-6, 6-12, and 12-24.

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

  dimension_group: since_signup {
    type: duration
    intervals: [
      day
      ,week
      ,month
      ,year
    ]
    sql_start: ${created_raw} ;;
    sql_end: current_date ;;
  }

  dimension: users_bucket {
    type: tier
    tiers: [0, 1, 3, 6, 12, 24]
    style: integer
    sql:  ${months_since_signup} ;;

  }





######## Geographic Dimensions: ########

  #   If longitude and latitude fields are available, these can be combined together to create a single
  #   location field that can be used for mapping points.

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }
  # Try it out!
  # Exercise: Location Dimensions
  #           Below is a partially completed dimension for location. Uncomment the dimension and update
  #           with the appropriate type and sql parameters.

  #   dimension: location {
  #     type:
  #     sql_latitude:  ;;
  #     sql_longitude:  ;;
  #   }


  #   If longitude and latitude fields are not available, map layers can be defined for common geographic
  #   fields such as country, state, and zip code. These can then be used for mapping areas.
  #   For example, in the country dimension, you have added the prebuilt map layer called countries.

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  # Now you try!
  # Exercise: Dimensions with Map Layers
  #           Add a map layer to the zip code dimension for easy mapping of all US zip code areas.

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: zip_map {
    type:  string
    map_layer_name: us_zipcode_tabulation_areas
    sql:  ${zip} ;;
  }





  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      first_name,
      last_name,
      events.count,
      order_items.count,
      orders.count
    ]
  }




  ######## Solutions ########


  # Solution: String Dimensions

  # dimension: city_state {
  #   type: string
  #   sql: ${city} || ', ' || ${state};;
  # }


  # Solution: Tier Dimensions

  # dimension: months_since_signup_tier {
  #   type: tier
  #   tiers: [0, 1, 3, 6, 12, 24]
  #   style: integer
  #   sql: ${months_since_signup} ;;
  # }


  # Solution: Location Dimensions

  # dimension: location {
  #   type: location
  #   sql_latitude: ${TABLE}.latitude ;;
  #   sql_longitude: ${TABLE}.longitude ;;
  # }


  # Solution: Dimensions with Map Layers

  # dimension: zip {
  #   type: zipcode
  #   sql: ${TABLE}.zip ;;
  #   map_layer_name: us_zipcode_tabulation_areas
  # }

}
