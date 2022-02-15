# intro-to-knowledge-graphs
Repository for the Hacktoberfest Knowledge Graph Meetup

### Contributing
You can find the Hacktoberfest meetup video here: https://www.youtube.com/watch?v=ZZt6xBmltz4

The slides for the talk are here: https://www.slideshare.net/arangodb/hacktoberfest-2020-intro-to-knowledge-graphs

You can run the example notebook in Colab, and when ready, you can submit it in the submissions folder.

### Overview
The [N-Triple](https://en.wikipedia.org/wiki/N-Triples) document provided contains statements about Sir Arthur Conan Doyle. This data was originally pulled from [DBPedia](http://dbpedia.org).

The notebook provides a very basic example of inserting a triple into ArangoDB as a property graph. The goal of the submissions was to suggest new ways to insert RDF data into ArangoDB. The approach shown simply creates vertices out of the Subject and Object and then creates a connecting edge with the Predicate. Many different variables are involved in making RDF useable in a property graph that is not addressed with this approach. 

Some additional issues that are needed for a full-fledge solution include:
* How to handle blank nodes
* Dealing with literals and type conservation
* How to handle special characters, especially concerning the `_key` attribute of ArangoDB documents
* Prefix handling
* Nesting properties and metadata 
* More?

### Get in Touch
We would love to hear from you if you have an interest in making RDF work better with property graphs.
Contact me via:
* [ArangoDB Community Slack](https://join.slack.com/t/arangodb-community/shared_invite/zt-d3a8xnj8-Uf66flfhU8pQARwjOXx~Tg) Chris.ArangoDB
* [Email](mailto:christopher@arangodb.com)
* [ArangoDB Website](https://www.arangodb.com/)


## RDF-star
One approach to make RDF and property graphs work better together is RDF-star.
Olaf Hartig originally introduced this specification, and more information can be found on the [W3C specification page](https://w3c.github.io/rdf-star/).


Good luck and get hacking!




