**If you are looking for the IMDB movies and actors dataset used in most ArangoDB notebooks and tutorials, [please use this branch.](https://github.com/arangodb/interactive_tutorials/tree/imdb_no_ratings)**

This branch contains data for the IMDB dataset containing users and their ratings on movies.
It is a dump containing three collections:
* Movies - Contains information for movies (genre, title, release data).
* Users - Contains user information (Age, Gender, occupation, zip_code).
* Ratings (Edge Collection) - Movie rating and timestamp of rating, showing the relationship of users to the movies they rate.
