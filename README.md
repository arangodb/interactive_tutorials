This branch contains data for the IMDB dataset containing movies, actors, directors, users, and user's ratings on movies.
This dataset is a combination of the two datasets which contained information about either actors and directors,
or users and their ratings.

To restore you can use either arangorestore or arangoimport, there is a dump directory (`data/imdb_dump`), and the individual JSON files are located in this directory.

It is a dump containing four collections:
* imdb_vertices - contains data for movies and people involved in those movies
* Users - Contains user information (Age, Gender, occupation, zip_code).
* Ratings (Edge Collection) - Movie rating and timestamp of rating, showing the relationship of users to the movies they rate.
* imdb_edges (Edge Collection)- contains the relationships between the movies and the people.
