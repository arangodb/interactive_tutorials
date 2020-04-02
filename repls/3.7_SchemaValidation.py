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
    db['Customers'].delete()
  except:
    pass
  db.reload()
 

#################################################################

# Retrieve tmp credentials from ArangoDB Tutorial Service
login = getTempCredentials()

# Connect to your temp database
url = "https://"+login["hostname"]+":"+str(login["port"])
conn = Connection(arangoURL=url, username=login["username"], password=login["password"],)
db = conn[login["dbName"]] 

# Cleanup (just in case the example is rerun)
cleanupCollections(db)

# Create Customer Collection
collection = db.createCollection(name="Customers")

# insert some documents
docs = []
doc = collection.createDocument()
doc["firstName"] = "James"
doc["lastName"] = "Cole"
docs.append(doc)

doc = collection.createDocument()
doc["firstName"] = "Claudius"
doc["lastName"] = "Weinberger"
doc["email"] = "info@arango.com"
docs.append(doc)
collection.bulkSave(docs)

# Check customers
print("Check Customers")
aql = """
  FOR customer in Customers
    return customer
  """
queryResult = db.AQLQuery(aql)
for customer in queryResult:
  print(customer)

# Set Validation
print()
print("Adding validation rule: requiring [email, lastname, firstname]")
validation = {
    "rule" : {
      "type" : "object",
      "properties": {
        "firstName": {
            "type": "string",
            "minLength" : 2,
            "maxLength" : 20,
        },
        "lastName": {
            "type": "string",
            "minLength" : 2,
            "maxLength" : 20,
        },
        "email": {
            "type": "string",
            "minLength" : 5,
            "maxLength" : 20,
        },
    },
    "required" : ["firstName", "lastName", "email"],
  },
  "level": "moderate"
}


db["Customers"].delete() # drop
db.reloadCollections() 


print()
print("Recreate Collection with validation rule")
collection = db.createCollection(
        name = "Customers",
        validation = validation
    )

#  Try to insert same documents
docs = []
doc = collection.createDocument()
doc["firstName"] = "James"
doc["lastName"] = "Cole"
# Note we are missing the required email attribute
docs.append(doc)

doc = collection.createDocument()
doc["firstName"] = "Claudius"
doc["lastName"] = "Weinberger"
doc["email"] = "info@arango.com"
docs.append(doc)

try:
  collection.bulkSave(docs)
except Exception as exc:
  print("Expected exception as only one of docs is confirming the validation rule.")
  print(exc)

# Check customers
print()
print("Checking customers added with validation")
aql = """
  FOR customer in Customers
    return customer
  """
queryResult = db.AQLQuery(aql)
for customer in queryResult:
  print(customer)


# Next Steps
print()
print("For next steps feel free to explore the ArangoDB UI at:")
print("https://"+login["hostname"]+":"+str(login["port"]))
print("Username: " + login["username"])
print("Password: " + login["password"])
print("Recall this is a temp database which will be autodeleted!")



