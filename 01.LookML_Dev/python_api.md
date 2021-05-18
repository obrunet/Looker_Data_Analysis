What:

A Restfull secure API for managing the Looker intances & fetching data

Why:
- write applications
- create automation scripts
- run queries
- intergrate datasets or viz into other process / workflows in internal or external web portals

How:

with HTTP methods
- GET: show me the ressources
- POST: make a new ressource
- PATCH: update an existing ressource
- DELETE: remove the ressource

```
GET https://<company>.api.looker.com/api/3.0/looks/7
```
returns infos about the look #7
To get authorized > admin > users > edit > edit keys --> new API3 key

Is instance up ? (HTTP 200)
```
curl -i https://adress.looker.com:1999/alive
```
Authenticate (to get a temporary token)

```
curl -i -d "client_id=$ID&client_secret=$SECRET" https://adress.looker.com:1999/login
```
Retrieve the value of a look with id 666:

```
curl -i -H "Authorization: token XXX" https://adress.looker.com:1999/api/3.1/looks/666/run/txt
```
SDK

a client SDK = a set of functions that resides in your app, that encapsulate all HTTP requests

Examples in Python: [Looker's Github specific repo](https://github.com/looker-open-source/sdk-examples/tree/master/python)