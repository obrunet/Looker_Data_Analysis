# LookML Developer

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
- look link tiles: use teh qury & viz of a saved report (Look). The linked look must be in the same folder. Used when several dashboards need the same tile.
- text tiles: headers, descriptions...

## 3. LookerML:

0. __Why__: you create a DB & a model once, people without an in-depth knowledge can explore the data for themselves.
LookerML is build around SQL with improvements: modularity, reusability & VCS such as git.

1. The language
__Looker builds & executes SQL queries__: it’s important to understanding how Looker generates SQL so that you can write __the most efficient__ queries.

You define your __business logic based on columns__ in your table. When you add a dimension field to the Explore, Looker constructs a SQL query that includes that field and sends the query to your database. __A filter__ will populate the __WHERE clause__ of the query. If you filter by a field that is __an aggregate__, Looker will automatically apply that filter in __the HAVING clause__.

2. 2 states of a Looker Data Model: 
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
- When in dev mode, it automatically creates a personal dev branch for you (read-only to all other devs). You areable to view and test, but not change, code in other dev' personal branches.
- you can also create other Git branch in order to implement a quick fix: choose the branch you want to fork, make your fix & deploy to production.  
- one can create a shared branch allowing easy collaboration on larger projects.


6. Writing LookerML

- LookerML = abstracted form of SQL
- A view = your table defined in Looker. The columns of the table in your db will initially be created in Looker as dimensions. Use LookML to build additional dimensions & measures

Syntax

```
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

= represent tables in your db. 

A dimension will be automatically generated for each column in a table & a count measure.