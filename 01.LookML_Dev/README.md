# LookML Developer

## Personnal notes:

### 1. Getting started:

#### Why Looker: 
for EDA, dataviz, creating dashboards -> quick & accurate decisions with data analytics.

#### Concepts
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

2. Building Reports:

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

## Recommended Looker knowledge & Looker Tools:
- Maintain and debug LookML code
- Build user-friendly Explores
- Design robust models
- Define caching policies
- Understand various datasets and associated schemas
- Looker IDE
- Text editor
- Looker’s SQL Runner
- Content Validator
- LookML Validator
- Version control

## Exam details:

Get ready for development
- How a project works in Looker
- Development Mode and Production Mode
- LookML project files
- Understanding model and view files
- Working with folders in the IDE
- How Looker generates SQL
- SQL Runner basics
- Configuring project version control settings
- Using version control and deploying
Write LookML
- What is LookML?
- LookML terms and concepts
- Editing and validating LookML
- Content Validation
- Incorporating SQL and referring to LookML objects
- Additional LookML basics
- Working with joins in LookML
- Using derived tables
- Caching queries and rebuilding PDTs with datagroups
- LookML quick reference


## What does the Looker LookML Developer Certification exam cover?
__Section 1__: Model management — 39%
  1. Troubleshoot errors in existing data models. For example: 
  - Determine error sources. 
  - Apply procedural concepts to resolve errors.

2. Apply procedural concepts to implement data security requirements. For example: 
- Implement permissions for users.
- Decide which Looker features to use to implement data security (e.g., access filters, field-level access controls, row-level access controls).

3. Analyze data models and business requirements to create LookML objects. For example: 
- Determine which views and tables to use. - Determine how to join views into Explores.
- Build project-based needs (e.g., data sources, replication, mock reports provided by clients).

4. Maintain the health of LookML projects in a given scenario. For example: 
- Ensure existing contents are working (e.g., use Content Validator, audit, search for errors). 
- Resolve errors.

__Section 2__: Customization — 30%
1. Design new LookML dimensions or measures with given requirements. For example:
- Translate business requirements (specific metrics) into the appropriate LookML structures (e.g., dimensions, measures, and derived tables).
- Modify existing project structure to account for new reporting needs.
- Construct SQL statements to use with new dimensions and measures.
2. Build Explores for users to answer business questions. For example:
- Analyze business requirements and determine LookML code implementation to meet requirements (e.g., models, views, join structures).
- Determine which additional features to use to refine data (e.g., sql_always_where, always_filter, only showing certain fields using hidden: fields:, etc.).

__Section 3__: Optimization — 18%
1. Apply procedural concepts to optimize queries and reports for performance. For example:
- Determine which solution to use based on performance implications (e.g., Explores, merged results, derived tables).
- Apply procedural concepts to evaluate the performance of queries and reports.
- Determine which methodology to use based on the query and reports performance sources (e.g., A/B testing, SQL principles).
2. Apply procedural concepts to implement persistent derived tables and caching policies based on requirements. For example:
-Determine appropriate caching settings based on data warehouse’s update frequency (e.g., hourly, weekly, based on ETL completion).
- Determine when to use persistent derived tables based on runtime and complexity of Explore queries, and on users’ needs.
- Determine appropriate solutions for improving data availability (e.g., caching query data, persisting tables, combination solutions).

__Section 4__: Quality — 13%
1. Implement version control based on given requirements. For example:

- Determine appropriate setup for Git branches (e.g., shared branches, pull from remote production).
- Reconcile merge conflicts with other developer branches (e.g., manage multiple users).
- Validate the pull request process.
2. Assess code quality. For example:

- Resolve validation errors and warnings.
- Utilize features to increase usability (e.g., descriptions, labels, group labels).
- Use appropriate coding for project files (e.g., one view per file).
3. Utilize SQL Runner for data validation in a given scenario. For example:

- Determine why specific queries return results by looking at the generated SQL in SQL Runner.
- Resolve inconsistencies found in the system or analysis (e.g., different results than expected, non-unique primary keys).
- Optimize SQLs for cost or efficiency based on business requirements.