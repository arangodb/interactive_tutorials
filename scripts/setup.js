'use strict';
const db = require('@arangodb').db;
const collectionName = 'aisisInstances';

if (!db._collection(collectionName)) {
  db._createDocumentCollection(collectionName);
}
const queues = require('@arangodb/foxx/queues');
const queue = queues.create('expirationQueue');

// Creates the expire job to check if databases should be expired and dropped.
queue.push(
  {mount: '/createDB', name: 'expire'},
  {},
  {
    repeatTimes: Infinity,
    repeatUntil: -1, // Forever
    repeatDelay: (24 * 60 * 60 * 1000) // Daily
  }
);
