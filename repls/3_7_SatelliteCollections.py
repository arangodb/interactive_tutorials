import json
import requests
import sys

from pyArango.connection import *
from pyArango.collection import Collection, Edges, Field
from pyArango.graph import Graph, EdgeDefinition
from pyArango.collection import BulkOperation as BulkOperation


# retrieving credentials from ArangoDB tutorial service
def getTempCredentials():
  with open("creds.dat","r+") as cacheFile: 
    contents = cacheFile.read()
    if len(contents) > 0:
      #. check if credentials are still valid
      login = json.loads(contents)
      url = "https://"+login["hostname"]+":"+str(login["port"])
      conn =""
      try: 
        conn = Connection(arangoURL=url, username=login["username"], password=login["password"],)
        print("Reusing cached credentials.")
        return login
      except:
        print("Credentials expired.")
        pass # Ignore and retrieve new 
    
    # Retrieve new credentials from Foxx Service
    print("Requesting new temp credentials.")
    url = 'https://5904e8d8a65f.arangodb.cloud:8529/_db/_system/alpha/tutorialDB'
    x = requests.post(url, data = "{}")

    if x.status_code != 200:
      print("Error retrieving login data.")
      sys.exit()
    # Caching credentials
    cacheFile.write(x.text)
  return json.loads(x.text)

def cleanupCollections(db):
  try:
    db['Location'].delete()
  except:
    pass
  try:
    db['Sensor'].delete()
  except:
    pass
  try:
    db['SensorLocation'].delete()
  except:
    pass
  try: 
    db['Sensordata'].delete()
  except:
    pass
  try:
    db.graphs['MySatelliteGraph'].delete()
  except:
    pass
  db.reload()
  db.dropAllCollections() 

#################################################################

# Retrieve tmp credentials from ArangoDB Tutorial Service
login = getTempCredentials()

# Connect to your temp database
url = "https://"+login["hostname"]+":"+str(login["port"])
conn = Connection(arangoURL=url, username=login["username"], password=login["password"],)
db = conn[login["dbName"]] 

# Cleanup (just in case the example is rerun)
cleanupCollections(db)

# Define large (i.e., in reality shareded) collection]
collection = db.createCollection(name="Sensordata")
docs= []
for i in range(100):
    doc = collection.createDocument()
    doc["id"] = i
    doc["data"] = "Large amount of data"
    docs.append(doc)
collection.bulkSave(docs)


# Define our Satellite Graph
class Location(Collection):
    _fields = {
        "Location": Field()
    }
class Sensor(Collection):
    _fields = {
        "id": Field()
    }
class SensorLocation(Edges):
    _fields = {
        "lifetime": Field()
    }

class MySatelliteGraph(Graph) :
    _edgeDefinitions = [EdgeDefinition("SensorLocation", fromCollections=["Location"], toCollections=["Sensor"])]
    _orphanedCollections = []

theSatelliteGraph = db.createSatelliteGraph("MySatelliteGraph")
print("Our first SatellitGraph: " + str(theSatelliteGraph))

# Add data to  MySatelliteGraph
s1 = theSatelliteGraph.createVertex('Sensor', {"id": 1})
s2 = theSatelliteGraph.createVertex('Sensor', {"id": 2})
l1 = theSatelliteGraph.createVertex('Location', {"location": "CA"})
l2 = theSatelliteGraph.createVertex('Location', {"location": "WA"})
theSatelliteGraph.link('SensorLocation', l1, s1, {"lifetime": "eternal"})
theSatelliteGraph.link('SensorLocation', l2, s2, {"lifetime": "eternal"})

# Join between the SatelliteGraph and "sharded" collection
print("Joining SatelliteGraph and 'sharded' collection")
aql = """
FOR loc in Location
    FILTER loc.location == "CA"
    FOR sensor IN 1..1 OUTBOUND loc._id GRAPH "MySatelliteGraph"
      // Join with large collection
      For sensordata in Sensordata
        FILTER sensordata.id == 1 //== sensordata.id
        RETURN {
         "sensor" : sensor.id,
         "data" : sensordata.data
         }
  """


queryResult = db.AQLQuery(aql, rawResults=True, batchSize=1)
document = queryResult[0]
print(document)

# Next Steps
print()
print("For next steps feel free to use the Explain feature from the ArangoDB UI at:")
print("https://"+login["hostname"]+":"+str(login["port"]))
print("Username: " + login["username"])
print("Password: " + login["password"])
print("Recall this is a temp database which will be autodeleted!")