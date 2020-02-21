'use strict';
const db = require('@arangodb').db;
const collectionName = 'tutorialInstances';
const expiredCollectionName = "expired"+collectionName;

// Creates collection to hold current user and instance information, to be deleted
if (!db._collection(collectionName)) {
  db._createDocumentCollection(collectionName);
}
// Creates collection to hold expired documents
if (!db._collection(expiredCollectionName)) {
  db._createDocumentCollection(expiredCollectionName);
}
const queues = require('@arangodb/foxx/queues');
const queue = queues.create('tutorialExpirationQueue');

// Creates the expire job to check if databases should be expired and dropped.
queue.push(
  {mount: '/tutorialDB', name: 'expire'},
  {},
  {
    repeatTimes: Infinity,
    repeatUntil: -1, // Forever
    repeatDelay: (60 * 60 * 1000) // Every hour
  }
);
