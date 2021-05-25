# Key Concepts

## Basic features 

### Dimensions 
- columns in a table or transformations & combinations of those columns (to pivot data)
- the options your users will use to group their data (dimensions always go into the GROUP BY clause of the SQL that Looker generates, so dimensions cannot be aggregates).

### Dimension Groups
allow you to create many dimensions all at once. Currently, solely used with time based data.

### A measure 
= a summary or aggregate calculation (to make filter)

### A view   
= represents / corresponds to one table in your DB or your own table that you create with Looker & then make that into a view

---> stored in view files. Techncially you can define more than one view inside a single view file: not a good practice for clarity & search ability. Suggestion: name your view files according to the view that's inside them.

### Explores  
= define which views will be shown in the menu. You can define join relationships between multiple views to create explores (that contain infos from multiple views).

---> live inside of models.

### A model = 
- contains explores (views the end-users interact with), the place where you'll define your explores. In general one model per database.
- defines multiple views(that can be joined together)
- lives in files
- define certain high-level settings such as what database connection should be used
However, models can be used to control various types of data access, so you might break this rule (see "Access Control & Permission Management" docs).

---> stored in model files. By definition, only one model per model file: you create a model by creating its file. The model name is the name of the file.

### Fields :
five different types:
- Dimensions 
- Dimension Groups = allow you to create many dimensions all at once (currently solely used with time based data).
- Measures
- Filters = in general, you don't need to explicitly create filters: The dimensions and measures you create will automatically be available to your users as filters. However, in some advanced use cases, you'll create a filter that doesn't have a dimension or measure associated with it.
- Parameters (similar to the Filter field type), but used for a slightly different use case.

---> live inside of views



Cohorts with Derived Tables
normalization
create a new set of data in Looker
This grouping is called a "cohort".
be able to compare the number of people with a certain name to the size of their cohort, and get a much better feel for popularity.

You can create new tables of data in Looker with its derived table functionality. Just like a native table in your database, you start by creating a view. However, instead of telling that view which data table to pull from, you write the SQL for a new data table. You can see this in the lesson_5_cohorts view file, which has these contents:



### Anatomy of a view
a view file contains:
- the "sql_table_name"
- view(s)
- dimensions
- mesure  
Fields live inside of views.

```
view: orders {                          # creates a view with the name of orders 
  sql_table_name: public.orders ;;      # tells Looker which database table to associate with this view.

  # When a Looker admin creates a connection in Looker, they define a default schema. 
  # If that's the schema you want, and you name the view with exactly the same name as its table, 
  # you don't even need to add the sql_table_name parameter.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  measure: count {
    type: count
  }
}
```

### Anatomy of a model   
a model file contains:  
- models
- by definition, one model per file: the model name is the name of the file. 
- Explores live inside of models.

```
# determines which database connection this model will query
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
```
include : makes all of the view files in this project available to the model using the wildcard *, but you can list the files individually on multiple rows.

### Derived tables
- many uses: such as calculating summary metrics and pre-aggregating data.
- can be calculated on the fly each time they're queried, or they can be stored in your database - your admins'll need to enable that feature - (if persisted (i.e. "stored") in the db the performance are improved)
- During creation: you'll write a SQL query against your database. The results of that query are then treated as a table within Looker. You can then use that table as normal to create dimensions, measures, etc. in LookML.
- can be used to improve query performance in some contexts. However, many modern databases are so fast that this is unnecessary.

### Anatomy of a model   
```
view: user_order_facts {

  # declares that the view is going to be a derived table.
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
```

### References in the sql Parameter

![tablet](https://github.com/obrunet/Looker_Data_Analysis/blob/main/01.LookML_Dev/ref_sql_param.png)


### Dimension Options

- Defining __a primary key__ is very important: it gives Looker the info it needs to properly calculate measures (otherwise Looker will generally hide measures from that view to avoid displaying bad information to users).
- __Link__
```
view: view_name {
  dimension: field_name {
    link: {
      label: "desired label name"
      url: "desired_url"
      icon_url : "url_of_an_image_file"
    }
    # Possibly more links
  }
}
```
- __Case__
allows you to specify several SQL conditions & the value that will appear to users if the condition is satisfied (similar to the SQL CASE WHEN function).

From the order_items View File
``` 
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
```
The conditions are evaluated in the order that you write them. As soon as one condition evaluates to true that label is assigned to that row of data.

- __value_format_name__ and __value_format__  
allow you to easily format dimensions for your users, lets you specify one of several pre-defined formats. You can create additional named formats by using the named_value_format parameter.
```
  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }
```

### Dimension Groups
allow you to create a set of dimensions all at once, based on a time column in your db. Currently, only used for timeframes.
```
  dimension_group: created {
    type: time
    datatype: datetime
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
```
Referenced & named by combining the dimension group name and the timeframe: ``` ${created_time}```

### Anatomy of a Measure
types: count, sum, average, min, max ,number
```
  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }
```
The number type should be used to combine multiple measures, or when performing math on a measure.
```
  measure: total_profit {
    type: number
    sql: ${total_sale_price} - ${products.total_cost} ;;
  }
```

### Measure Options
- __drill_fields__: an option to show all of the records that comprise a measure when a user clicks it
```
measure: count {
  type: count
  drill_fields: [user_details*]
}
set: user_details {
  fields: [id, name, city, state, country]
}
```
- __filters__: users can apply filters on the Explore page to everything, whereas this feature allows you to filter only a specific measure.
```
  measure: female_count {
    type: count
    filters: {
      field: gender
      value: "Female"
    }
  }
```

# Advanced features

### Labeling

- __description__: available to end-users, useful way to document precise definitions or usage notes ("i" info symbol in the field picker)
```
  measure: sale_price_metric {
    description: "Use with the Sale Price Metric Picker filter-only field"
    type: number
    label_from_parameter: sale_price_metric_picker
    sql: {% parameter sale_price_metric_picker %}(${sale_price}) ;;
    value_format_name: usd
  }
```
- __label__: everything in LookML can take a label (Models, Explores, Views, Dimensions, Measures and other fields..) except joins which can be re-named in other ways. It simply replaces the name as end-users see it in Looks, Dashboards, and the Explore page.
```
explore: order_items_warehouse {
  extends: [order_items]
  label: "Order Items for the Warehouse"
```
- __view_label__: allows you to combine fields into the same view in the field picker, even if they aren't combined from a modeling perspective.

```
join: users {

... lower in the file ...

join: user_order_facts {
  view_label: "Users"
```
- __group_label__: allows you to combine fields into a group in the field picker, within a given view. This automatically happens with dimension groups, but you can also do it manually with other fields.
```
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
```
### Datagroups
By default, the results of all the queries are stored securely for 60 min (ie "cached" to improve performance instead of querying the db again).

You can change this amount of time, or coordinate them with a feature called datagroups.
```
datagroup: standard_data_load {
  sql_trigger: SELECT MAX(completed_at) FROM etl_jobs ;;
  max_cache_age: "24 hours"
}
```
The ```sql_trigger``` provides a query that Looker runs every 5 minutes. If the result of the query changes during one of those checks, Looker knows that it needs to run fresh queries. If the result of the query has not changed, Looker knows it may use the cached results.   
The ```max_cache_age``` tells Looker the maximum amount of time cached results may be used.

__Applying a Datagroup__: by using the ```persist_with``` parameter at the model level to set a default for all explores or at the explore level to override that default.
```
persist_with: standard_data_load
```
### Persistent Derived Table
- By saving the results in your db, you can query the derived table more quickly. 
- use datagroups to define how often it should be re-queried & re-saved.
```
view: user_order_facts {
  derived_table: {
    sql:
      SELECT
        user_id,
        MIN(DATE(created_at)) AS first_order_date,
        COUNT(1) AS lifetime_orders
      FROM
        orders
      GROUP BY
        user_id ;;
    datagroup_trigger: standard_data_load
    distribution: "user_id"
    sortkeys: ["first_order_date"]
  }
```
### Extensions
- useful to re-use certain bits of code, in order to reduce repeated code and keep things better organized
- for example: a basic view with a set of basic dimensions & measures. Then, additional extended views are created to add more options.
```
explore: order_items {
  view_name: order_items
  from: order_items

... lower in the file ...

explore: order_items_warehouse {
  extends: [order_items]
```
### Liquid Templating
to create more dynamic content:
  - The action parameter
  - The html parameter
  - The label parameter of a field
  - The link parameter
  - Parameters that begin with sql (such as sql and sql_on)

in __HTML__:
```
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
```
in __Links__: for example a Google search option
```
From the products View File
dimension: brand {
  type: string
  sql: ${TABLE}.brand ;;
  link: {
    label: "Google Search"
    url: "http://www.google.com/search?q={{ value }}+Clothing"
    icon_url: "http://google.com/favicon.ico"
  }
}
```
in __SQL__: for example masks the customer user ID if the Looker end-user is not allowed to see it (sensitive info)
```
dimension: safe_id {
  sql:
    CASE
      WHEN '{{ _user_attributes['can_see_id'] }}' = 'Yes'
      THEN ${id}::varchar
      ELSE MD5(${id})
    END
  ;;
}
```
### Parameters & Templated Filters
- dimension, measure, sql, and type are all LookML parameters but this features is named with a Capital "P".
- to expand the possible functionality
- are forms of Liquid

1. create a filter (for Templated Filters) or a parameter (for Parameters) to accept user input that will appear to the user as "Filter-only Fields" in the field picker.
2. apply that user input to your data model by using Liquid.

__Templated Filters__ are quite similar to Parameters. Key difference:
- Parameters insert the user input directly into your Liquid tag (if you need very precise input)
- Templated Filters interpret the user input (the user have more freedom)