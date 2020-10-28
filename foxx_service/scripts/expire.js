'use strict';
const { aql, query, db } = require("@arangodb");
const users = require("@arangodb/users");

const expirationTime = (4 * 60 * 60 * 1000) // 4 hours or use (30 * 1000) for 30 seconds
const expired = [];

let dbs = query`
  FOR i IN tutorialInstances
  RETURN {key: i._key, dbName: i.dbName, timestamp: i.timestamp, username: i.username}`;

dbs.toArray().map((d) => {
  (Date.now() - expirationTime ) > d.timestamp ? removeDatabase(d.dbName, d.key, d.username) : ''
})

let cleanupCollection = query`
FOR key IN ${expired}
FOR i IN tutorialInstances
FILTER i._key == key
INSERT {email: i.email, username: i.username, dbName: i.dbName, timestamp: i.timestamp, tutorialName: i.tutorialName} INTO expiredtutorialInstances
REMOVE { _key: key } IN tutorialInstances`;

function removeDatabase(dbName, key, username) {
  if (users.exists(username)){
    users.remove(username);
  }
  try {
    db._dropDatabase(dbName);
    expired.push(key);
  } catch (err) {

  }
}

