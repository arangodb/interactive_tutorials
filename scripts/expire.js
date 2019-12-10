'use strict';
const { aql, query, db } = require("@arangodb");
const users = require("@arangodb/users");

const expirationTime = (336 * 60 * 60 * 1000)
const expired = []

let dbs = query`
  FOR i IN aisisInstances
  RETURN {key: i._key, dbName: i.dbName, timestamp: i.timestamp}`

dbs.toArray().map((d) => {
  (Date.now() - expirationTime ) > d.timestamp ? removeDatabase(d.dbName, d.key) : ''
})

query`
FOR key IN ${expired}
REMOVE { _key: key } IN aisisInstances
`

function removeDatabase(dbName, key) {
  console.log(db._engineStats())
  db._dropDatabase(dbName)
  expired.push(key)
}
