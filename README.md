# Sandbox creation endpoint for use with tutorials
To use locally, zip entire directory and install service on system database.

Currently, endpoint is accessible via https://a0434a558688.arangodb.cloud:8529/_db/_system/tutorialDB/tutorialDB

**/tutorialDB**
* Returns dbName, username, password, hostname address
* Creates tutorialInstances collection that has all existing username and database information.
* Deletes databases every 4 hours, checks once an hour.
* When a database is dropped some information, including email is transferred to expiredtutorialInstances collection.
