// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.


import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.flat.io/v2" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("FLAT_ACCESS_TOKEN") : "test_token";
final string testScoreId = isLiveServer ? os:getEnv("FLAT_SCORE_ID") : "a1b2c3d4e5f60718293a4b01";
final string testUserId = isLiveServer ? os:getEnv("FLAT_USER_ID") : "5a1b2c3d4e5f60718293a4b5";
final string testCollectionId = isLiveServer ? os:getEnv("FLAT_COLLECTION_ID") : "8e1f2a3b4c5d60718293a4e1";
final string testClassId = isLiveServer ? os:getEnv("FLAT_CLASS_ID") : "6c1d2e3f4a5b60718293a4c1";
final string testAssignmentId = isLiveServer ? os:getEnv("FLAT_ASSIGNMENT_ID") : "7d1e2f3a4b5c60718293a4d1";
final string testGroupId = isLiveServer ? os:getEnv("FLAT_GROUP_ID") : "9f1a2b3c4d5e60718293a4f1";
final string testTaskId = isLiveServer ? os:getEnv("FLAT_TASK_ID") : "d4e5f60718293a4b5c6d7e01";

final Client flat = check new ({auth: {token}, httpVersion: http:HTTP_1_1}, serviceUrl);

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAuthenticatedUser() returns error? {
    UserDetails response = check flat->getAuthenticatedUser();
    test:assertTrue(response.id.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetUser() returns error? {
    UserPublic response = check flat->getUser(testUserId);
    test:assertTrue(response.username.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetUserScores() returns error? {
    ScoreDetails[] response = check flat->getUserScores(testUserId);
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateScore() returns error? {
    ScoreCreationFileImport payload = {title: "Test score", data: "dGVzdA==", dataEncoding: "base64"};
    ScoreDetails|Task response = check flat->createScore(payload);
    test:assertTrue(response is ScoreDetails || response is Task);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetScore() returns error? {
    ScoreDetails response = check flat->getScore(testScoreId);
    test:assertTrue(response.title.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testEditScore() returns error? {
    ScoreDetails response = check flat->editScore(testScoreId, {title: "Renamed score"});
    test:assertTrue(response.id.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteScore() returns error? {
    ScoreCreationFileImport payload = {title: "Score to delete", data: "dGVzdA==", dataEncoding: "base64"};
    ScoreDetails|Task created = check flat->createScore(payload);
    if created is ScoreDetails {
        check flat->deleteScore(created.id);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetScoreCollaborators() returns error? {
    ResourceCollaborator[] response = check flat->getScoreCollaborators(testScoreId);
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetScoreComments() returns error? {
    ScoreComment[] response = check flat->getScoreComments(testScoreId);
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testAddScoreComment() returns error? {
    ScoreComment response = check flat->addScoreComment(testScoreId, {comment: "Lovely phrasing in measure 4"});
    test:assertTrue(response.comment.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCollections() returns error? {
    Collection[] response = check flat->listCollections();
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateCollection() returns error? {
    Collection response = check flat->createCollection({title: "Practice pieces"});
    test:assertTrue(response.id.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetCollection() returns error? {
    Collection response = check flat->getCollection(testCollectionId);
    test:assertTrue(response.title.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteCollection() returns error? {
    Collection created = check flat->createCollection({title: "Collection to delete"});
    check flat->deleteCollection(created.id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListClasses() returns error? {
    ClassDetails[] response = check flat->listClasses();
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateClass() returns error? {
    ClassDetails response = check flat->createClass({name: "Music Theory 101"});
    test:assertTrue(response.id.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetClass() returns error? {
    ClassDetails response = check flat->getClass(testClassId);
    test:assertTrue(response.name.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateClass() returns error? {
    ClassDetails response = check flat->updateClass(testClassId, {name: "Advanced Music Theory"});
    test:assertTrue(response.id.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListAssignments() returns error? {
    ClassAssignment[] response = check flat->listAssignments(testClassId);
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAssignment() returns error? {
    Assignment response = check flat->getAssignment(testClassId, testAssignmentId);
    test:assertTrue(response.title.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListGroups() returns error? {
    GroupDetails[] response = check flat->listGroups('type = "classStudentsSubGroup");
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateGroup() returns error? {
    GroupDetails response = check flat->createGroup({classroom: testClassId, name: "Section C", 'type: "classStudentsSubGroup"});
    test:assertTrue(response.id.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetGroupDetails() returns error? {
    GroupDetails response = check flat->getGroupDetails(testGroupId);
    test:assertTrue(response.name.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListOrganizationUsers() returns error? {
    UserDetailsAdmin[] response = check flat->listOrganizationUsers();
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetTask() returns error? {
    Task response = check flat->getTask(testTaskId);
    test:assertEquals(response.state, "done");
}
