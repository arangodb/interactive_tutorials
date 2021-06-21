## ArangoBnB Without Calendar
Example restore command: `arangorestore --server.database abnb_geo_data --create-database --input-directory .\data\arangobnb_no_calendar\`

This branch contains a dump for the arangobnb dataset.
It drops the `calendar` collection; the included collections are:
* listings
* neighborhoods
* reviews

It also contains an ArangoSearch View with the following defintion:
```
{
  "writebufferIdle": 64,
  "type": "arangosearch",
  "writebufferSizeMax": 33554432,
  "consolidationPolicy": {
    "type": "tier",
    "segmentsBytesFloor": 2097152,
    "segmentsBytesMax": 5368709120,
    "segmentsMax": 10,
    "segmentsMin": 1,
    "minScore": 0
  },
  "primarySort": [
    {
      "field": "number_of_reviews",
      "asc": false
    },
    {
      "field": "review_scores_rating",
      "asc": false
    }
  ],
  "globallyUniqueId": "h23E0006467FF/8345760",
  "id": "8345760",
  "storedValues": [],
  "writebufferActive": 0,
  "consolidationIntervalMsec": 1000,
  "cleanupIntervalStep": 2,
  "commitIntervalMsec": 1000,
  "links": {
    "listings": {
      "analyzers": [
        "identity"
      ],
      "fields": {
        "number_of_reviews": {
          "analyzers": [
            "text_en",
            "identity"
          ]
        },
        "room_type": {},
        "price": {},
        "amenities": {
          "analyzers": [
            "text_en",
            "identity"
          ]
        },
        "neighborhood_cleansed": {},
        "description": {
          "analyzers": [
            "text_en"
          ]
        },
        "host_id": {},
        "location": {
          "analyzers": [
            "geo"
          ]
        },
        "review_scores_rating": {
          "analyzers": [
            "text_en",
            "identity"
          ]
        },
        "neighborhood": {
          "analyzers": [
            "text_en"
          ]
        }
      },
      "includeAllFields": false,
      "storeValues": "none",
      "trackListPositions": false
    },
    "neighborhoods": {
      "analyzers": [
        "identity"
      ],
      "fields": {
        "properties": {
          "fields": {
            "neighborhood": {
              "analyzers": [
                "text_en"
              ]
            }
          }
        },
        "geometry": {
          "analyzers": [
            "geo"
          ]
        }
      },
      "includeAllFields": false,
      "storeValues": "none",
      "trackListPositions": false
    }
  },
  "primarySortCompression": "lz4"
}
```

