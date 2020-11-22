This branch contains the typical IMDB data used in most ArangoDB notebooks and tutorials. 
To restore you can use either arangorestore or arangoimport, there is a dump directory and the invidual JSON files are located in their respective directories.

The dataset consists of two different collections:
* imdb_vertices - contains data for movies and people involved in those movies .
* imdb_edges - contains the relationships between the movies and the people.

If you are looking for the imdb dataset containing users and their movie ratings, see the [imdb_with_ratings](https://github.com/arangodb/interactive_tutorials/tree/imdb_with_ratings) branch.
