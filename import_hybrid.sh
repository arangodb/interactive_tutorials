ARANGOIMPORT="${ARANGOIMPORT:-build/bin/arangoimport}"
ARANGOSH="${ARANGOSH:-build/bin/arangosh}"
ARANGO_ENDPOINT="${ARANGO_ENDPOINT:-tcp://127.0.0.1:8529}"
ARANGO_USERNAME="${ARANGO_USERNAME:-root}"
ARANGO_PASSWORD="${ARANGO_PASSWORD:-}"
ARANGO_DATABASE="${ARANGO_DATABASE:-SF10_benchmark}"
REPLICATION_FACTOR="${REPLICATION_FACTOR:-1}"
NUMBER_OF_SHARDS="${NUMBER_OF_SHARDS:-3}"
DATADIR="${DATADIR:-.}"
JAVASCRIPT_DIRECTORY="${JAVASCRIPT_DIRECTORY:-js}";

create_smart_graph () {	
  local jsScriptCode='graph_module = require("@arangodb/smart-graph"); 
  try { 
    graph_module._drop("ldbc", true);   
  } catch(err) { 

   } 

  var rel = [];

  rel.push(graph_module._relation("Comment_hasTag_Tag", ["Comment"], ["Tag"]));
  rel.push(graph_module._relation("Person_hasCreated_Comment", ["Comment"], ["Person"]));
  rel.push(graph_module._relation("Person_hasCreated_Post", ["Post"], ["Person"])); 
  rel.push(graph_module._relation("Person_knows_Person", ["Person"], ["Person"]));
  rel.push(graph_module._relation("Person_likes_Comment", ["Person"], ["Comment"]));
  rel.push(graph_module._relation("Person_likes_Post", ["Person"], ["Post"]));
  rel.push(graph_module._relation("Post_hasTag_Tag", ["Post"], ["Tag"]));
  rel.push(graph_module._relation("isSubclassOf", ["TagClass"], ["TagClass"]));
  rel.push(graph_module._relation("Person_workAt_Company", ["Person"], ["Organisation"]));
  rel.push(graph_module._relation("Person_studyAt_University", ["Person"], ["University"]));
  rel.push(graph_module._relation("Forum_hasMember_Person", ["Forum"], ["Person"]));
  rel.push(graph_module._relation("Forum_hasTag_Tag", ["Forum"], ["Tag"]));
  rel.push(graph_module._relation("Forum_containerOf_Post", ["Forum"], ["Post"]));
  rel.push(graph_module._relation("Person_hasInterest_Tag", ["Person"], ["Tag"]));
  
  graph_module._create("ldbc", rel, [], {"numberOfShards": 3, "smartGraphAttribute": "CreatorPersonId", "satellites":["Tag", "TagClass", "Organisation", "University", "Forum"]});
    
  '
  echo "$jsScriptCode" | $ARANGOSH --server.endpoint "$ARANGO_ENDPOINT" --server.database "$ARANGO_DATABASE" --server.username "$ARANGO_USERNAME" --server.password "$ARANGO_PASSWORD" --javascript.startup-directory "$JAVASCRIPT_DIRECTORY"
}

run_import () {
  local collection="$1"
  local file="$2"
  local type="$3"
  shift 3
  $ARANGOIMPORT --type csv --collection "$collection" --separator "|" --create-collection true --create-collection-type "$type" --file "$file" --server.endpoint "$ARANGO_ENDPOINT" --server.database "$ARANGO_DATABASE" --server.username "$ARANGO_USERNAME" --server.password "$ARANGO_PASSWORD" "$@" --overwrite true
  import_result=$?
}

process_directory () {
  local directory="$1"	
  local collection="$2"
  local type="$3"
  shift 3
  
  # uncomment to clean up collection beforehand
  # echo "db._drop('$collection');" | $ARANGOSH --server.endpoint "$ARANGO_ENDPOINT" --server.database "$ARANGO_DATABASE" --server.username "$ARANGO_USERNAME" --server.password "$ARANGO_PASSWORD" --javascript.startup-directory "$JAVASCRIPT_DIRECTORY"
  # import_result="$?"
  # if [[ "x$import_result" != "x0" ]]; then
  #   exit "$import_result"
  # fi

  # echo "db._create('$collection', {numberOfShards: $NUMBER_OF_SHARDS, replicationFactor: $REPLICATION_FACTOR}, '$type');" | $ARANGOSH --server.endpoint "$ARANGO_ENDPOINT" --server.database "$ARANGO_DATABASE" --server.username "$ARANGO_USERNAME" --server.password "$ARANGO_PASSWORD" --javascript.startup-directory "$JAVASCRIPT_DIRECTORY"
  # import_result="$?"
  # if [[ "x$import_result" != "x0" ]]; then
  #   exit "$import_result"
  # fi
  
  # import all csv files for collection
  for file in `find "$DATADIR/$directory" -type f -name "*.csv"`; do
    run_import "$collection" "$file" "$type" $@
    if [[ "x$import_result" != "x0" ]]; then
      exit "$import_result"
    fi
  done
}

create_smart_graph 

# Merge attributes to smartify
process_directory "dynamic/Comment" "Comment" "document" "--datatype CreatorPersonId=string" "--datatype ParentCommentId=string" "--datatype LocationCountryId=string" "--datatype ParentPostId=string" "--datatype ParentCommmentId=string" "--merge-attributes _key=[CreatorPersonId]:[id]"
#Comment_hasReply_Comment defined in create_smart_graph and requires post processing to obtain smartified person who replied and smartified commentId
#Comment_hasTag_Tag_standard is imported below but needs the comment field smartified post import
process_directory "dynamic/Comment_hasTag_Tag" "Comment_hasTag_Tag_standard" "edge" "--from-collection-prefix=Comment" "--to-collection-prefix=Tag" "--merge-attributes _from=[CommentId]" "--merge-attributes _to=[TagId]:[TagId]" 
# ModeratorPersonId could be 'smartified' in Forum but not necessary for queries
process_directory "dynamic/Forum" "Forum" "document" "--datatype ModeratorPersonId=string" "--merge-attributes _key=[id]:[id]" "--merge-attributes CreatorPersonId=[ModeratorPersonId]"

process_directory "dynamic/Forum_hasMember_Person" "Forum_hasMember_Person" "edge" "--from-collection-prefix=Forum" "--to-collection-prefix=Person" "--merge-attributes _from=[ForumId]:[ForumId]" "--merge-attributes _to=[PersonId]:[PersonId]" 
# Skipping Forum_hasPost_Post as it isn't being used in query
process_directory "dynamic/Forum_hasTag_Tag" "Forum_hasTag_Tag" "edge" "--from-collection-prefix=Forum" "--to-collection-prefix=Tag" "--merge-attributes _from=[ForumId]:[ForumId]" "--merge-attributes _to=[TagId]:[TagId]"

process_directory "static/Organisation" "Organisation" "document" "--merge-attributes _key=[id]:[id]"
process_directory "dynamic/Person" "Person" "document" "--datatype id=string" "--datatype LocationCityId=string" "--merge-attributes CreatorPersonId=[id]" "--datatype CreatorPersonId=string" "--merge-attributes _key=[CreatorPersonId]:[CreatorPersonId]"

process_directory "dynamic/Comment" "Person_hasCreated_Comment"  "edge" "--from-collection-prefix=Comment" "--to-collection-prefix=Person" "--merge-attributes _from=[CreatorPersonId]:[id]" "--merge-attributes _to=[CreatorPersonId]:[CreatorPersonId]" "--remove-attribute browserUsed" "--remove-attribute content" "--remove-attribute creationDate" "--remove-attribute deletionDate" "--remove-attribute locationIP" "--remove-attribute length" "--remove-attribute language" "--remove-attribute explicitlyDeleted" "--remove-attribute LocationCountryId" "--remove-attribute ContainerForumId" 
process_directory "dynamic/Post" "Person_hasCreated_Post"  "edge" "--from-collection-prefix=Post" "--to-collection-prefix=Person" "--merge-attributes _from=[CreatorPersonId]:[id]" "--merge-attributes _to=[CreatorPersonId]:[CreatorPersonId]" "--remove-attribute browserUsed" "--remove-attribute content" "--remove-attribute creationDate" "--remove-attribute deletionDate" "--remove-attribute locationIP" "--remove-attribute length" "--remove-attribute language" "--remove-attribute explicitlyDeleted" "--remove-attribute LocationCountryId" "--remove-attribute ContainerForumId" 
process_directory "dynamic/Person_knows_Person" "Person_knows_Person" "edge" "--from-collection-prefix=Person" "--to-collection-prefix=Person" "--merge-attributes _from=[Person1Id]:[Person1Id]" "--merge-attributes _to=[Person2Id]:[Person2Id]" 
#Person_likes_Comment (created via smartGraph) requires post import lookup for Comment as post CreatorPersonId is not known for edge on import
process_directory "dynamic/Person_likes_Comment" "Person_likes_Comment_standard" "edge" "--from-collection-prefix=Person" "--to-collection-prefix=Comment" "--merge-attributes _from=[PersonId]:[PersonId]" "--merge-attributes _to=[CommentId]" 
#Person_likes_Post (created via smartGraph) requires post import lookup for Post as post CreatorPersonId is not known for edge on import
process_directory "dynamic/Person_likes_Post" "Person_likes_Post_standard" "edge" "--from-collection-prefix=Person" "--to-collection-prefix=Post" "--merge-attributes _from=[PersonId]:[PersonId]" "--merge-attributes _to=[PostId]" 
process_directory "dynamic/Person_studyAt_University" "Person_studyAt_University" "edge" "--from-collection-prefix=Person" "--to-collection-prefix=Organisation" "--datatype UniversityId=string" "--merge-attributes CreatorPersonId=[PersonId]" "--merge-attributes _from=[CreatorPersonId]:[CreatorPersonId]" "--merge-attributes _to=[UniversityId]:[UniversityId]"
process_directory "dynamic/Person_workAt_Company" "Person_workAt_Company" "edge" "--from-collection-prefix=Person" "--to-collection-prefix=Organisation" "--merge-attributes _from=[PersonId]:[PersonId]" "--merge-attributes _to=[CompanyId]:[CompanyId]"
process_directory "static/Place" "Place" "document" "--merge-attributes _key=[id]:[id]"
process_directory "dynamic/Post" "Post" "document" "--datatype CreatorPersonId=string" "--datatype ContainerForumId=string" "--datatype LocationForumId=string" "--merge-attributes _key=[CreatorPersonId]:[id]"
#Post_hasReply_Comment defined in create_smart_graph and requires post processing to obtain smartified person who replied and smartified commentId
#Post_hasTag_Tag requires post processing for the smartified postId
process_directory "dynamic/Post_hasTag_Tag" "Post_hasTag_Tag_standard" "edge" "--from-collection-prefix=Post" "--to-collection-prefix=Tag" "--merge-attributes _from=[PostId]" "--merge-attributes _to=[TagId]:[TagId]"
process_directory "static/Tag" "Tag" "document" "--datatype id=string" "--merge-attributes CreatorPersonId=[id]" "--merge-attributes _key=[CreatorPersonId]:[id]"

process_directory "static/TagClass" "TagClass" "document" "--datatype id=string" "--merge-attributes _key=[id]:[id]" "--datatype SubclassOfTagClassId=string"
process_directory "static/TagClass" "isSubclassOf" "edge" "--from-collection-prefix=TagClass" "--to-collection-prefix=TagClass" "--datatype id=string" "--datatype SubclassOfTagClassId=string" "--merge-attributes _from=[id]:[id]" "--merge-attributes _to=[SubclassOfTagClassId]:[SubclassOfTagClassId]" "--remove-attribute name" "--remove-attribute url"

process_directory "dynamic/Post" "Forum_containerOf_Post" "edge" "--datatype ContainerForumId=string" "--datatype id=string" "--datatype CreatorPersonId=string" "--from-collection-prefix=Forum" "--to-collection-prefix=Post" "--merge-attributes _from=[ContainerForumId]:[ContainerForumId]" "--merge-attributes _to=[CreatorPersonId]:[id]" "--remove-attribute browserUsed" "--remove-attribute content" "--remove-attribute creationDate" "--remove-attribute deletionDate" "--remove-attribute locationIP" "--remove-attribute length" "--remove-attribute language" "--remove-attribute explicitlyDeleted" "--remove-attribute LocationCountryId"
process_directory "dynamic/Person_hasInterest_Tag" "Person_hasInterest_Tag" "edge" "--datatype personId=string" "--datatype TagId=string" "--from-collection-prefix=Person" "--to-collection-prefix=Tag" "--merge-attributes _from=[personId]:[personId]" "--merge-attributes _to=[interestId]:[interestId]"

