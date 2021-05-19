# LookML Developer

Table of content:
- [Getting started](#1-getting-started)
- [Building Reports](#2-building-reports)
- [LookerML](#3-lookerml)

Other ressources:
- [API and SDK](https://github.com/obrunet/Looker_Data_Analysis/blob/main/01.LookML_Dev/python_api.md) 
- [What you need to know for the certification](https://github.com/obrunet/Looker_Data_Analysis/blob/main/01.LookML_Dev/what_to_know.md)

## 1. Getting started:

### Why Looker: 
for EDA, dataviz, creating dashboards -> quick & accurate decisions with data analytics.

### Concepts
- __Looks__ = saved reports thats provide answer to a single data question
- __Dashboards__ = answer to a set of related questions with a collection of tiles (list, chart, map...) - each provide answer to a specific question

One can click on a part / an area of a chart to see the underlying data in a new window. There are also update option / clean cacha & refresh in order to use newer data.

Changes can be made temporary & only for "me" with filters.
Depending on how they are made, tiles can listen or ignore some filters.

__Share & send content__: 

once:
  - a snapshot: download it or send the data
  - current: share the URL

repeatedly: schedule it

## 2. Building Reports:

Side note: Looker lets you create an alert on a specific metric with scheduled checks (one can specify the frequence of the checks)

__Dimensions__ = attributes records can be grouped by.

__Measures__ = calculations on groups (count, total, avg...)

__Filters__ created with:
- the icon in the dimensions / measures left panel
- or the gear in tables

applied on:
- dimension: filter raw data - done behind the scene - could lead to misinterpretation
- measures: filter on rows from the result
- or an user attribures by clicking on a dimension value

__Folders__ are either shared, personnal, "all" depending on your permissions / rights.

3. Creation of a dashboard from
- an explore
- a look
- a blank dashboard

3 types of piles:
- query tiles: you specify the data you want to show, defined from an explore or the dashboard itself
- look link tiles: use the query & viz of a saved report (Look). The linked look must be in the same folder. Used when several dashboards need the same tile.
- text tiles: headers, descriptions...

## 3. LookerML:

0. __Why__:   
you create a DB & a model once, people without an in-depth knowledge can explore the data for themselves.
LookerML is build around SQL with improvements: modularity, reusability & VCS such as git.

1. The language  
__Looker builds & executes SQL queries__: it’s important to understand how Looker generates SQL so that you can write __the most efficient__ queries.

You define your __business logic based on columns__ in your table. When you add a dimension field to the Explore, Looker constructs a SQL query that includes that field and sends the query to your database. __A filter__ will populate the __WHERE clause__ of the query. If you filter by a field that is __an aggregate__, Looker will automatically apply that filter in __the HAVING clause__.

2. Two states of a Looker Data Model: 
- __Production__: The data model is shared across all users & the LookML files are treated as read-only. 
- In order to write or __change__ LookML in Looker, you'll need to __turn on Development Mode__. Then a separate version of the data model is provided so that you can edit and test without affecting end users.

3. VCS:
- production = points to the code in the master git branch. 
- development mode = your own branch: only visible to developers viewing this Git branch

--> easier for collaboration with multiple developers (Git will identify this scenario as a merge conflict and ask you to review the code)

4. IDE
- code, project & git setting are written / edited inside of the IDE.
- organization:
  - file, or object browser, search
  - Git Actions
  - Project Settings

5. Git Branching
- When in dev mode, it automatically creates a personal dev branch for you (read-only to all other devs). You are able to view and test, but not change, code in other dev' personal branches.
- you can also create other Git branch in order to implement a quick fix: choose the branch you want to fork, make your fix & deploy to production.  
- one can create a shared branch allowing easy collaboration on larger projects.


6. Writing LookerML

- LookerML = abstracted form of SQL
- A view = your table defined in Looker. The columns of the table in your db will initially be created in Looker as dimensions. Use LookML to build additional dimensions & measures

Syntax

```sql
parameter: value // dimension with curly brackets

sql_table_name: public.orders;;

dimension: email {
  type: string
  sql: ${TABLE}.email;;     // a SQL statement to indicate which field you are referring to
                            // ${} substitution syntax
}

```
The email dimension can be reused by referring to it with ${email}.

7. Views

In a project, you can generate view files that represent tables in your DB. 
A dimension will be automatically generated for each column in a table & a count measure.

A view represents a table of data in Looker, whether a native database table or a derived table. Typically, views are declared in a view file with one view per file.

8. Creation of dimensions

__Dimensions__ = 
  - columns in the DB or row-level calculations based on columns in the DB
  - the most fundamental building block in LookML
  - come in a variety of types: number, date, and string...
  
__String__:
- used for any columns with CHAR or VARCHAR datatypes
- the default dimension type in Looker

string concatenation example:
```sql
view: users {
  sql_table_name: public.users ;;

  # here Redshift is used so the  || syntax to concatinate
  # substitution syntax: ${first_name} instead of ${TABLE}.first_name

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
    sql: ${first_name} || ' - ' || ${last_name} ;;
  }
```

__Number__: similar logic, allow you to add, subtract, or transform any numeric columns.

```sql
  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
    value_format_name: usd
  }

  dimension: tax_amount {
    type: number
    sql: ${cost}*0.06 ;;
    value_format_name: usd
  }

  dimension: cost_including_tax {
    type:  number
    sql:  ${cost} + ${tax_amount} ;;
    value_format_name: usd
  }
```

__Timeframe__: Timestamps & dates in Looker are handled in a unique way. A timestamp from your  DB --> a dimension group is created with a type: time.

This dimension group converts the timestamps into a variety of date and time parts (see various parameters).

The raw timestamp from the DB won’t appear for end users (useful for time zone conversions...). When one of the dimension group timeframes is selected, SQL will be generated with the appropriate dialect-specific date and time conversions.

```sql
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
```
substitution syntax: ${dimensiongroup_field} for example ${created_month}.  
${created_date} is a string.

__Duration__: dimension group which calculate the difference between a start and end date. 

The sql_start and sql_end dates can take columns in your DB, or any valid SQL expression (timestamp, datetime, date, epoch, or yyyymmdd format). 
```sql
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
```

__YesNo__: ie boolean, rather than a result of true or false, this type of dimension results in an output of yes or no.
You only need to specify the yes condition, and Looker'll build a case statement (blank & null values will also return a no result). 
In the generated SQL of an Explore, will appear the corresponding CASE WHEN statement.

```sql
  dimension: long_fulfillment {
    description: "Yes means the order took over 7 days to fulfill."
    type: yesno
    sql: ${days_fulfillment} > 7 ;;
  }
```

__Tier__: for bucketing to sort values into the ranges you specify.
'style' indictates how the value groupings will appear in the front-end UI.
```sql
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
```
__Geographic__: 
- Static area dimensions (country, state, or zip code) --> map layers in Looker. 

Specify the map_layer_name parameter ie the map name where to visualize data.
```sql
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
```
- Latitude & longitude values --> point mapping.

A new dimension named location of type: location. Most dimensions require only one SQL parameter, location dimensions require 2 specified by substitution syntax:
```sql
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
```
9. Creation of measures

Measures = objects used by Looker to represent aggregate functions (sum, count, averages, count_distinct...), created in a similar manner to dimensions.
```sql
  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  measure: count_distinct_sku {
    type: count_distinct
    sql: ${product_sku} ;;
  }
```
an other example (one can use also sum)
```
  measure: average_cost {
    type: average
    sql: ${cost} ;;
    value_format_name: usd
  }
```
Do not confuse aggregate measures & non-aggregate dimensions in an Explore.

10. UX Enhancement

How fields are labeled & organized ? --> adjust parameters for their appearence in the UI.

__Hidden parameter__: not helpful for users (mainly used for creating aggregations) & no need to be exposed to users.
```sql
  dimension: id {
    hidden:  yes
    type:  number
    sql:  ${TABLE}.id ;;
  }
```
__Label parameter__: change the way a field’s name appears in the UI. By default, based on the LookML object name (1st letter of each word capitalized, & the underscores converted into spaces) 
A custom name can be more recognizable to users or help to distinguish multiple count for instance.
```sql
  dimension: count {
    label:  "Number of order items"
    type:  number
    drill_fields: [detail*]
  }
```
__Description parameter__: provides a definition of what a dimension/measure actually means
```sql
  dimension: long_fulfillment {
    description: "Yes means the order took over 7 days to fulfill."
    type: yesno
    sql: ${days_fulfillment} > 7 ;;
  }
```

__Drill Fields__: helpful to have the option to see the more detailed data behind the aggregate number & specify what data should be available to users.
```sql
  measure: count {
    label: "Number of order items"
    type: count
    drill_fields: [order_id, user_id]
  }
```
used when you click on a number of a view to have more details in the new window.

__Sets__: allow you to define a list of fields in one place that you can then reuse as many times as you need. Update the list once to change it everywhere.

To use a set in a drill on a measure: reference the name of the set followed by an __*__. 
```sql
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
```
11. Explore creation

The FROM  clause in an SQL query is determined by an object called an Explore. It can include a single or multiple tables. You create Explores in the model file using the same logic.
```sql
explore: order_items {}
```
or with a join (available types: left outer join, inner join, full outer join, and cross join) a left join is used by defaut if type not mentionned:

```sql
explore: order_items {
  
  join: orders {
    type: left_outer    
    sql_on: ${order_items.order_id} = ${orders.id} ;;   
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
```
it's a starting points for users to query their data. Avoid having too many Explores (confusion) --> a clear purpose.

__Symmetric Aggregation__ = analytical pattern to ensure that measures are calculated properly, even if [a Fanout Problem](https://looker.com/blog/aggregate-functions-gone-bad-and-the-joins-who-made-them-that-way) occurs (aggregates & joints can go wrong)

2 things that must be done in order for symmetric aggregation to work:
- Specify primary keys within all view files (a UID for the view).
- Correctly specify the relationship parameter within a join. It indicates where fanout may occur: with many-to-one relationship the table on the "one" side might be fanned out when the join is executed.