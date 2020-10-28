import json
import requests
import sys
import time

from pyArango.connection import *
from arango import ArangoClient

# retrieving credentials from ArangoDB tutorial service
def getTempCredentials(tutorialName=None,credentialProvider="https://tutorials.arangodb.cloud:8529/_db/_system/tutorialDB/tutorialDB"):
    with open("creds.dat","r+") as cacheFile: 
        contents = cacheFile.readline()
        if len(contents) > 0:
            login = None
            url = ""
           
            # check if credentials are still valid
            try:
                login = json.loads(contents)
                url = "https://"+login["hostname"]+":"+str(login["port"])
            except:
                # Incorrect data in cred file and retrieve new credentials
                cacheFile.truncate(0) 
                pass
        
            conn =""
            if (login is not None):
                try: 
                    conn = Connection(arangoURL=url, username=login["username"], password=login["password"],)
                    print("Reusing cached credentials.")
                    return login
                except:
                    print("Credentials expired.")
                    pass # Ignore and retrieve new 
    
        # Retrieve new credentials from Foxx Service
        print("Requesting new temp credentials.")
        if (tutorialName is not None):
             body = {
            "tutorialName": tutorialName
             }
        else:
            body = "{}"
        
        url = credentialProvider
        x = requests.post(url, data = json.dumps(body))

        if x.status_code != 200:
            print("Error retrieving login data.")
            sys.exit()
        # Caching credentials
        cacheFile.truncate(0) 
        cacheFile.write(x.text)
        print("Temp database ready to use.")
        return json.loads(x.text)

# Connect against an oasis DB and return pyarango connection
def connect(login):
    url = "https://"+login["hostname"]+":"+str(login["port"])
    conn = None
    try:
        conn = Connection(arangoURL=url, username=login["username"], password=login["password"],)
    except:
        time.sleep(1)
        conn = Connection(arangoURL=url, username=login["username"], password=login["password"],)
    return conn
        
# Connect against an oasis DB and return pyarango connection
def connect_python_arango(login):
    url = "https://"+login["hostname"]+":"+str(login["port"])
    database = None
    # Initialize the ArangoDB client.
    client = ArangoClient(hosts=url)
    try:
        database = client.db(login["dbName"], username=login["username"], password=login["password"])
    except:
        time.sleep(1)
        database = client.db(login["dbName"], username=login["username"], password=login["password"])
    return database   
    
    