### Key Concepts

### Dimensions 
- columns in a table or transformations & combinations of those columns (to pivot data)
- the options your users will use to group their data (dimensions always go into the GROUP BY clause of the SQL that Looker generates, so dimensions cannot be aggregates).



a measure = a summary or aggregate calculation (to make filter)


a view = represents / corresponds to one table in your DB or your own table that you create with Looker & then make that into a view

---> stored in view files. Techncially you can define more than one view inside a single view file: not a good practice for clarity & search ability. Suggestion: name your view files according to the view that's inside them.


Explores = define which views will be shown in the menu. You can define join relationships between multiple views to create explores (that contain infos from multiple views).

---> live inside of models.


model = 
- contain explores (views the end-users interact with), 
- defines multiple views(that can be joined together)
- live in files
- the place where you'll define your explores. In general one model per database. 
However, models can be used to control various types of data access, so you might break this rule (see "Access Control & Permission Management" docs).

---> stored in model files. By definition, only one model per model file: you create a model by creating its file. The model name is the name of the file.




Fields :
- five different types:
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



## Anatomy of a view

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