import json
import requests
import sys
import time

from pyArango.connection import Connection
from arango import ArangoClient


# retrieving credentials from ArangoDB tutorial service
def getTempCredentials(
    tutorialName=None,
    credentialProvider="https://tutorials.arangodb.cloud:8529/_db/_system/tutorialDB/tutorialDB",
):
    with open("creds.dat", "r") as cacheFile:
        contents = cacheFile.readline()
        if contents:
            try:  # check if credentials are still valid
                login = json.loads(contents)
                url = "https://" + login["hostname"] + ":" + str(login["port"])
                Connection(
                    arangoURL=url,
                    username=login["username"],
                    password=login["password"],
                )
                print("Reusing cached credentials.")
                return login
            except:  # Incorrect data in cred file and retrieve new credentials
                print("Invalid/expired expired.")

        # Retrieve new credentials from Foxx Service
        with open("creds.dat", "w+") as cacheFile:
            print("Requesting new temp credentials.")
            body = {"tutorialName": tutorialName} if tutorialName else "{}"
            x = requests.post(credentialProvider, data=json.dumps(body))
            if x.status_code != 200:
                print("Error retrieving login data.")
                sys.exit()

            # Caching credentials
            cacheFile.write(x.text)
            cacheFile.close()
            time.sleep(5) # Wait for DB provisioning
            print("Temp database ready to use.")
            return json.loads(x.text)


# Connect against an oasis DB and return pyarango connection
def connect(login: dict):
    url = "https://" + login["hostname"] + ":" + str(login["port"])
    return Connection(
        arangoURL=url, username=login["username"], password=login["password"]
    )


# Connect against an oasis DB and return python-arango connection
def connect_python_arango(login: dict):
    url = "https://" + login["hostname"] + ":" + str(login["port"])
    return ArangoClient(hosts=url).db(
        login["dbName"],
        username=login["username"],
        password=login["password"],
        verify=True,
    )
