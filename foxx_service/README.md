# Sandbox creation endpoint for use with tutorials
This is a simple Foxx microservice that we use to provide temporary databases for our notebooks. To use locally, zip the entire directory including the Readme and install the service on `_system` database.

Currently, the endpoint is accessible via https://tutorials.arangodb.cloud:8529/_db/_system/tutorialDB/tutorialDB

**/tutorialDB**
* Optionally Accepts:
    * dbName
    * username
    * password
    * email
    * tutorialName
* Returns 
    * dbName
    * username
    * password
    * hostname
    * port
* Creates tutorialInstances collection that has all existing username(not password) and database information.
* Deletes databases every 4 hours, checks once an hour. These values can be updated in expire.js or setup.js, respectively.  
* When a database is dropped, some information including email, if provided, is transferred to expiredtutorialInstances collection.
