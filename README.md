# ArangoDB Interactive Tutorials

![ArangoDB-Logo](https://www.arangodb.com/docs/assets/arangodb_logo_2016_inverted.png)

Here you will find tutorials and interactive notebooks for ArangoDB features. These notebooks allow you to learn about ArangoDB concepts and features without the need to install or sign up for anything. Each notebook uses a free temporary tutorial database that lets you focus on all the cool things ArangoDB has to offer.

## Learn
There are a few sections for getting started with Interactive Tutorials:
* [Machine Learning](#machine-learning): Links to the various ArangoDB machine learning projects and learning content.
* [ArangoDB](#arangodb): The interactive tutorials maintained in this repo that cover all aspects of ArangoDB.
* [Community Notebooks](#community-notebooks): Amazing submissions from the community!
* [Workshop Repositories](#workshop-repositories): Links to the repositories associated with ArangoDB workshops.
* [Feedback](#feedback): Feel free to leave us feedback.
* [Contribute](#contribute): Learn how to contribute your own learning content.


### Machine Learning
In addition to the notebooks listed in the following section, we have example machine learning notebooks with [ArangoML](https://github.com/arangoml), including:
* [ArangoML Pipeline](https://github.com/arangoml/arangopipe/tree/master/examples)
* [ArangoDB NetworkX Adapter](https://github.com/arangoml/networkx-adapter)
    * [Getting Started Notebook](https://colab.research.google.com/github/arangoml/networkx-adapter/blob/master/examples/ArangoDB_NetworkX_Adapter.ipynb)
* ArangoFlix: Movie Recommendations [Demo available on Oasis](https://cloud.arangodb.com/)
    * [Collaborative Filtering with AQL](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/arangoflix/recommend_movie_collaborative_filtering_aql.ipynb)
    * [Content-based Recommendations with ArangoSearch and TFIDF](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/arangoflix/similarMovie_TFIDF_AQL_Inference.ipynb)
    * [Content-based Recommendations with FAISS, TFIDF, and Python](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/arangoflix/similarMovie_TFIDF_ML_Inference.ipynb)
    * [Graph Neural Networks with PyTorch](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/arangoflix/predict_Movie_Rating_GNN.ipynb)
    * [Matrix Factorization](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/arangoflix/similarMovie_MF_ML_Inference.ipynb)


### ArangoDB 
These notebooks are interactive and take the hands-on learning approach, so feel free to play around and change things. Each notebook provides an intoduction to its covered topics along with the ability to immediately see it in action. 

Most notebooks were developed with Google Colab in mind and many have an [![](https://colab.research.google.com/assets/colab-badge.svg)](#) button. 

The following links will open the notebooks directly in Google Colab, the source files are located in [the notebooks folder](https://github.com/arangodb/interactive_tutorials/tree/master/notebooks).
* [AQL CRUD Part 1](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/AqlCrudTutorial.ipynb)
* [AQL CRUD Part 2](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/AqlPart2Tutorial.ipynb)
* [AQL Joins](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/AqlJoinTutorial.ipynb)
* [AQL Graph Traversal](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/AqlTraversalTutorial.ipynb)
* [AQL Geospatial](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/AqlGeospatialTutorial.ipynb)
* [ArangoBnB Data Preparation](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/ArangoBnB_simple_data_exploration.ipynb)
* [ArangoSearch](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/ArangoSearch.ipynb)
* [ArangoSearch Part 2: Advanced Graph Traversal](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/ArangoSearchOnGraphs.ipynb)
* [Best Practices Guide](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/BestPractices.ipynb)
* [Comprehensive GraphSage Guide with PyTorchGeometric and Amazon Product Recommendation Dataset](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Comprehensive_GraphSage_Guide_with_PyTorchGeometric.ipynb)
* [Fuzzy Search](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/FuzzySearch.ipynb)
* [Game of Thrones AQL Tutorial](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/ArangoDB_GOT_Tutorial.ipynb)
* [Graph Analytics: Collaborative Filtering](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Collaborative_Filtering.ipynb)
* [Graph Analytics: Entity Resolution](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/EntityResolution.ipynb)
* [Graph Analytics: Retail Part 1 - Data Exploration](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Graph_Retail_EDA_I.ipynb)
* [Graph Analytics: Retail Part 2 - Feature Selection & RFM](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Graph_Retail_EDA_II.ipynb)
* [Graph Analytics: Retail Part 3 - Descriptive Analytics](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Graph_Retail_DA_I.ipynb)
* [Graph Analytics: Retail Part 4 - Descriptive Analytics, continued](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Graph_Retail_DA_II.ipynb)
* [Graph Embeddings](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Graph_Embeddings.ipynb)
* [Graph Visualization using Graphistry](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/ArangoDB_Graphistry_Visualization.ipynb)
* [Hybrid SmartGraphs](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/HybridSmartGraphs.ipynb)
* [Integrate ArangoDB to PyTorchGeometric to Build Recommendation Systems](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Integrate_ArangoDB_with_PyG.ipynb)
* [NetworkX IMDB Graph Analytics](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/ArangoDB_NetworkX_Interface_Introduction.ipynb)
* [Pregel Introduction](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Pregel.ipynb)
* [RDF Import Example](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/RDF_Import_Example.ipynb)
* [R Language with ArangoDB](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/R_ArangoDB_Managed_Service_Notebook.ipynb)
* [SatelliteGraphs](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/SatelliteGraphs.ipynb)
* [Schema Validation](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Schema_Validation.ipynb)
* [Upsert](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Upsert.ipynb)
* [Window - Time Series Aggregation](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/Window.ipynb)
* [Word Embeddings](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/notebooks/WordEmbeddings.ipynb)

### Community Notebooks
If you have a use case you would like to show off or even a quick tutorial for an ArangoDB feature, this would be very helpful to the ArangoDB community. It's easy to get started with our [Template.ipynb](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/Template.ipynb), which shows you how to use the tutorial endpoint in your notebooks. When ready, open a PR with your submission, and we will add it to the list, share it with the community, and be eternally grateful.

 **Notebooks**:
* [Criando e analisando dados com AQL](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/community_notebooks/BD_g01_ArangoDB.ipynb) - Submitted by [janiosl](https://github.com/janiosl)

### Workshop Repositories
The following is a list of workshops given that cover topics related to ArangoDB.
If you would like to add a workshop that might be interesting to the ArangoDB community, please add it to the list and open a pull request.

* [Graph Powered Machine Learning](https://github.com/joerg84/Graph_Powered_ML_Workshop)
* [NVIDIA Triton meets ArangoDB](https://github.com/sachinsharma9780/AI-Enterprise-Workshop-Building-ML-Pipelines)

### Feedback
Do you have some topics you would like to see a notebook for? Well, read on to the contribute section for details on how to submit a notebook of your own. 

You can also always drop us a line at [learn@arangodb.com](mailto:learn@arangodb.com) or join us on our [community Slack channel](https://arangodb-community.slack.com/).

## Contribute

Do you have a great idea for a notebook? 

Did you see something you think could be better?

Have a cool project that uses ArangoDB that you would like to share with the community?

**Notebooks**

Make a notebook of your own!

We have provided a template that will help you quickly get started creating a notebook that can also generate a temporary database for fellow learners.

Just open up the [Template.ipynb](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/Template.ipynb) file to learn more about what it takes to get started or you can use the [Template_basic.ipynb](https://colab.research.google.com/github/arangodb/interactive_tutorials/blob/master/Template_basic.ipynb) file to get a simple notebook with only the connection code done for you.

Once your notebook is ready for the world to see, you can place it in the [community_notebooks](https://github.com/arangodb/interactive_tutorials/tree/master/community_notebooks) folder and create a pull request.

**Workshops**

If you have a workshop repository that you would like added to the list, add it to the Workshop Repositories section and open a pull request.

**Something Else?**

Open an issue or pull request with your suggestion. You can also drop us a line at learn@arangodb.com or join us on our community Slack channel.
