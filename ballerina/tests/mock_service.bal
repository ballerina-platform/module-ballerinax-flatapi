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

listener http:Listener ep0 = new (9090);

service / on ep0 {
    # Delete the collection
    #
    # + collection - Unique identifier of the collection.
    # The following collection aliases are supported:
    # - `root`: **Deprecated.** The root collection of the account
    # - `app`: Alias for the current app collection
    # - `trash`: Automatically contains resources that have been deleted
    # The following virtual collections are supported:
    # - `allScores`: All the scores contained in the user account
    # - `collaborations`: All shared scores by the user or someone else
    # - `likes`: Liked scores
    # + return - returns can be any of following types 
    # http:NoContent (Collection deleted)
    # http:Forbidden (Not granted to access to this collection)
    # http:NotFound (Collection not found)
    # http:DefaultStatusCodeResponse (Error)
    resource function delete collections/[string collection]() returns http:NoContent|FlatErrorResponseForbidden|FlatErrorResponseNotFound|FlatErrorResponseDefault {
        return http:NO_CONTENT;
    }

    # Delete a score
    #
    # + score - Unique identifier of the score document. This can be a Flat Score unique identifier (i.e. `ScoreDetails.id`) or, if the score is also a Google Drive file, the Drive file unique identifier prefixed with `drive-` (e.g. `drive-0B000000000`)
    # + now - If `true`, the score deletion will be scheduled as soon as possible
    # + return - returns can be any of following types 
    # http:NoContent (The score has been removed)
    # http:Forbidden (Not granted to manage this score)
    # http:NotFound (Score not found)
    # http:DefaultStatusCodeResponse (Error)
    resource function delete scores/[string score](boolean now = false) returns http:NoContent|FlatErrorResponseForbidden|FlatErrorResponseNotFound|FlatErrorResponseDefault {
        return http:NO_CONTENT;
    }

    # List the classes available for the current user
    #
    # + state - Filter the classes by state
    # + return - returns can be any of following types 
    # http:Ok (The list of classes)
    # http:DefaultStatusCodeResponse (Error)
    resource function get classes("active"|"inactive"|"archived" state = "active") returns ClassDetails[]|FlatErrorResponseDefault {
        return [mockClass("6c1d2e3f4a5b60718293a4c1", "Music Theory 101"), mockClass("6c1d2e3f4a5b60718293a4c2", "Orchestra Ensemble")];
    }

    # Get the details of a single class
    #
    # + 'class - Unique identifier of the class
    # + return - returns can be any of following types 
    # http:Ok (The new class details)
    # http:DefaultStatusCodeResponse (Error)
    resource function get classes/[string 'class]() returns ClassDetails|FlatErrorResponseDefault {
        return mockClass('class, "Music Theory 101");
    }

    # Assignments listing
    #
    # + 'class - Unique identifier of the class
    # + return - returns can be any of following types 
    # http:Ok (List of assignments for the class)
    # http:DefaultStatusCodeResponse (Error)
    resource function get classes/[string 'class]/assignments() returns ClassAssignment[]|FlatErrorResponseDefault {
        return [mockAssignment("7d1e2f3a4b5c60718293a4d1", "Scales practice"), mockAssignment("7d1e2f3a4b5c60718293a4d2", "Sight reading")];
    }

    # Get an assignment
    #
    # + 'class - Unique identifier of the class
    # + assignment - Unique identifier of the assignment
    # + return - returns can be any of following types 
    # http:Ok (The assignment has been retrieved)
    # http:DefaultStatusCodeResponse (Error)
    resource function get classes/[string 'class]/assignments/[string assignment]() returns Assignment|FlatErrorResponseDefault {
        return mockAssignment(assignment, "Scales practice");
    }

    # List the collections
    #
    # + parent - List the collections contained in this `parent` collection.
    # When set to `user` (default), returns the user's own collections as well as
    # collections shared with the user.
    # Using `root` or `sharedWithMe` is **deprecated** and will be treated as `user`
    # + sort - Sort
    # + direction - Sort direction
    # + 'limit - This is the maximum number of objects that may be returned
    # + next - An opaque string cursor to fetch the next page of data.
    # The paginated API URLs are returned in the `Link` header when requesting the API. These URLs will contain a `next` and `previous` cursor based on the available data
    # + previous - An opaque string cursor to fetch the previous page of data.
    # The paginated API URLs are returned in the `Link` header when requesting the API. These URLs will contain a `next` and `previous` cursor based on the available data
    # + return - returns can be any of following types 
    # http:Ok (List of collections)
    # http:DefaultStatusCodeResponse (Error)
    resource function get collections("creationDate"|"modificationDate"|"title"? sort, "asc"|"desc"? direction, string? next, string? previous, string parent = "user", int 'limit = 25) returns Collection[]|FlatErrorResponseDefault {
        return [mockCollection("8e1f2a3b4c5d60718293a4e1", "Favorites"), mockCollection("8e1f2a3b4c5d60718293a4e2", "Practice pieces")];
    }

    # Get collection details
    #
    # + collection - Unique identifier of the collection.
    # The following collection aliases are supported:
    # - `root`: **Deprecated.** The root collection of the account
    # - `app`: Alias for the current app collection
    # - `trash`: Automatically contains resources that have been deleted
    # The following virtual collections are supported:
    # - `allScores`: All the scores contained in the user account
    # - `collaborations`: All shared scores by the user or someone else
    # - `likes`: Liked scores
    # + sharingKey - This sharing key must be specified to access to a score or collection with a `privacy` mode set to `privateLink` and the current user is not a collaborator of the document
    # + return - returns can be any of following types 
    # http:Ok (Collection details)
    # http:Forbidden (Not granted to access to this collection)
    # http:NotFound (Collection not found)
    # http:DefaultStatusCodeResponse (Error)
    resource function get collections/[string collection](string? sharingKey) returns Collection|FlatErrorResponseForbidden|FlatErrorResponseNotFound|FlatErrorResponseDefault {
        return mockCollection(collection, "Favorites");
    }

    # List groups
    #
    # + 'type - The type of groups to list
    # + classroom - Classroom ID to filter by
    # + assignment - Assignment ID to filter by
    # + return - returns can be any of following types 
    # http:Ok (List of groups)
    # http:BadRequest (Bad Request - Invalid type or missing required parameters)
    # http:Forbidden (Forbidden - Insufficient permissions)
    # http:NotFound (Not Found - Classroom or assignment not found)
    # http:DefaultStatusCodeResponse (Error)
    resource function get groups("classStudentsSubGroup"|"assignmentStudentsSubGroup" 'type, string? classroom, string? assignment) returns GroupDetails[]|FlatErrorResponseBadRequest|FlatErrorResponseForbidden|FlatErrorResponseNotFound|FlatErrorResponseDefault {
        return [mockGroup("9f1a2b3c4d5e60718293a4f1", "Section A"), mockGroup("9f1a2b3c4d5e60718293a4f2", "Section B")];
    }

    # Get group information
    #
    # + group - Unique identifier of a Flat group
    # + return - returns can be any of following types 
    # http:Ok (The group details)
    # http:NotFound (Not Found - Group not found or insufficient permissions)
    # http:DefaultStatusCodeResponse (Error)
    resource function get groups/[string group]() returns GroupDetails|FlatErrorResponseNotFound|FlatErrorResponseDefault {
        return mockGroup(group, "Section A");
    }

    # Get current user account
    #
    # + onlyId - Only return the user id
    # + return - returns can be any of following types 
    # http:Ok (Current user details)
    # http:DefaultStatusCodeResponse (Error)
    resource function get me(boolean onlyId = false) returns UserDetails|FlatErrorResponseDefault {
        return mockUser();
    }

    # List the organization users
    #
    # + sort - The order to sort the user list.
    # * `creationDate`: Order by account creation.
    # * `firstname`, `lastname`, `username`: Order by the user identity.
    # * `lastActivityDate`: Order by the last recorded activity.
    # * `licenseExpirationDate`: Order by the expiration of the active license
    # + direction - Sort direction
    # + next - An opaque string cursor to fetch the next page of data.
    # The paginated API URLs are returned in the `Link` header when requesting the API. These URLs will contain a `next` and `previous` cursor based on the available data
    # + previous - An opaque string cursor to fetch the previous page of data.
    # The paginated API URLs are returned in the `Link` header when requesting the API. These URLs will contain a `next` and `previous` cursor based on the available data
    # + role - Filter users by role
    # + q - The query to search
    # + group - Filter users by group
    # + noActiveLicense - Filter users who don't have an active license
    # + testAccounts - Filter users based on test account status.
    # Test accounts are student accounts created for testing purposes by teachers.
    # * `exclude`: Hide test accounts from results.
    # * `only`: Show only test accounts.
    # When omitted, all users are returned
    # + licenseExpirationDate - Filter users by license expiration date or `active` / `notActive`
    # + onlyIds - Return only user ids
    # + 'limit - This is the maximum number of objects that may be returned
    # + return - returns can be any of following types 
    # http:Ok (List of users)
    # http:DefaultStatusCodeResponse (Error)
    resource function get organizations/users("creationDate"|"firstname"|"lastname"|"username"|"lastActivityDate"|"licenseExpirationDate"? sort, "asc"|"desc"? direction, string? next, string? previous, ("user"|"teacher"|"admin"|"accountAdmin")[]? role, string? q, string[]? group, boolean? noActiveLicense, "exclude"|"only"? testAccounts, string[]? licenseExpirationDate, boolean? onlyIds, int 'limit = 25) returns UserDetailsAdmin[]|FlatErrorResponseDefault {
        return [{id: "5a1b2c3d4e5f60718293a4b5", username: "jane_composer", name: "Jane Composer", 'type: "user", picture: (), product: "flatEdu", email: "jane@example.edu", organizationRole: "teacher"}, {id: "5a1b2c3d4e5f60718293a4b6", username: "john_student", name: "John Student", 'type: "user", picture: (), product: "flatEdu", email: "john@example.edu", organizationRole: "user"}];
    }

    # Get a score's metadata
    #
    # + score - Unique identifier of the score document. This can be a Flat Score unique identifier (i.e. `ScoreDetails.id`) or, if the score is also a Google Drive file, the Drive file unique identifier prefixed with `drive-` (e.g. `drive-0B000000000`)
    # + sharingKey - This sharing key must be specified to access to a score or collection with a `privacy` mode set to `privateLink` and the current user is not a collaborator of the document
    # + return - returns can be any of following types 
    # http:Ok (Score details)
    # http:PaymentRequired (Account overquota and this document is out of the granted quota)
    # http:Forbidden (Not granted to access to this score)
    # http:NotFound (Score not found)
    # http:DefaultStatusCodeResponse (Error)
    resource function get scores/[string score](string? sharingKey) returns ScoreDetails|FlatErrorResponsePaymentRequired|FlatErrorResponseForbidden|FlatErrorResponseNotFound|FlatErrorResponseDefault {
        return mockScore(score, "Moonlight Sonata");
    }

    # List the collaborators
    #
    # + score - Unique identifier of the score document. This can be a Flat Score unique identifier (i.e. `ScoreDetails.id`) or, if the score is also a Google Drive file, the Drive file unique identifier prefixed with `drive-` (e.g. `drive-0B000000000`)
    # + sharingKey - This sharing key must be specified to access to a score or collection with a `privacy` mode set to `privateLink` and the current user is not a collaborator of the document
    # + return - returns can be any of following types 
    # http:Ok (List of collaborators)
    # http:PaymentRequired (Account overquota)
    # http:Forbidden (Not granted to access to this score)
    # http:NotFound (Score not found)
    # http:DefaultStatusCodeResponse (Error)
    resource function get scores/[string score]/collaborators(string? sharingKey) returns ResourceCollaborator[]|FlatErrorResponsePaymentRequired|FlatErrorResponseForbidden|FlatErrorResponseNotFound|FlatErrorResponseDefault {
        return [mockCollaborator()];
    }

    # List comments
    #
    # + score - Unique identifier of the score document. This can be a Flat Score unique identifier (i.e. `ScoreDetails.id`) or, if the score is also a Google Drive file, the Drive file unique identifier prefixed with `drive-` (e.g. `drive-0B000000000`)
    # + sharingKey - This sharing key must be specified to access to a score or collection with a `privacy` mode set to `privateLink` and the current user is not a collaborator of the document
    # + 'type - Filter the comments by type
    # + sort - Sort
    # + direction - Sort direction
    # + return - returns can be any of following types 
    # http:Ok (The comments of the score)
    # http:PaymentRequired (Account overquota)
    # http:Forbidden (Not granted to access to this score)
    # http:NotFound (Score not found)
    # http:DefaultStatusCodeResponse (Error)
    resource function get scores/[string score]/comments(string? sharingKey, "document"|"inline"? 'type, "date"? sort, "asc"|"desc"? direction) returns ScoreComment[]|FlatErrorResponsePaymentRequired|FlatErrorResponseForbidden|FlatErrorResponseNotFound|FlatErrorResponseDefault {
        return [mockComment(score, "Lovely phrasing in measure 4")];
    }

    # Get task details
    #
    # + task - Unique identifier for the task
    # + return - returns can be any of following types 
    # http:Ok (Task details)
    # http:DefaultStatusCodeResponse (Error)
    resource function get tasks/[string task]() returns Task|FlatErrorResponseDefault {
        return {id: task, state: "done", 'type: "export", format: "mp3", creationDate: "2026-01-15T10:30:00.000Z"};
    }

    # Get a public user profile
    #
    # + user - This route parameter is the unique identifier of the user. You can specify an email instead of a unique identifier. If you are executing this request authenticated, you can use `me` as a value instead of the current User unique identifier to work on the current authenticated user
    # + return - returns can be any of following types 
    # http:Ok (The user public details)
    # http:DefaultStatusCodeResponse (Error)
    resource function get users/[string user]() returns UserPublic|FlatErrorResponseDefault {
        return mockUser(user);
    }

    # List user's scores
    #
    # + user - Unique identifier of a Flat user. If you authenticated, you can use `me` to refer to the current user
    # + paginate - When set to `true`, the API will return a paginated result.
    # When set to `false` or unset, the API will return all the scores.
    # If this parameter is unset or false, then limit/sort/direction/next/previous will be ignored
    # + sort - Sort
    # + direction - Sort direction
    # + 'limit - This is the maximum number of objects that may be returned
    # + next - An opaque string cursor to fetch the next page of data.
    # The paginated API URLs are returned in the `Link` header when requesting the API. These URLs will contain a `next` and `previous` cursor based on the available data
    # + previous - An opaque string cursor to fetch the previous page of data.
    # The paginated API URLs are returned in the `Link` header when requesting the API. These URLs will contain a `next` and `previous` cursor based on the available data
    # + return - returns can be any of following types 
    # http:Ok (The user scores)
    # http:DefaultStatusCodeResponse (Error)
    resource function get users/[string user]/scores("creationDate"|"modificationDate"|"title"? sort, "asc"|"desc"? direction, string? next, string? previous, boolean paginate = false, int 'limit = 25) returns ScoreDetails[]|FlatErrorResponseDefault {
        return [mockScore("a1b2c3d4e5f60718293a4b01", "Moonlight Sonata"), mockScore("a1b2c3d4e5f60718293a4b02", "Clair de Lune")];
    }

    # Create a new class
    #
    # + return - returns can be any of following types 
    # http:Ok (The new class details)
    # http:PaymentRequired (Account overquota)
    # http:DefaultStatusCodeResponse (Error)
    resource function post classes(@http:Payload ClassCreation payload) returns ClassDetailsOk|FlatErrorResponsePaymentRequired|FlatErrorResponseDefault {
        return <ClassDetailsOk>{body: mockClass("6c1d2e3f4a5b60718293a4c3", payload.name)};
    }

    # Create a new collection
    #
    # + return - returns can be any of following types 
    # http:Ok (Collection created)
    # http:BadRequest (Bad collection creation request)
    # http:DefaultStatusCodeResponse (Error)
    resource function post collections(@http:Payload CollectionCreation payload) returns CollectionOk|FlatErrorResponseBadRequest|FlatErrorResponseDefault {
        return <CollectionOk>{body: mockCollection("8e1f2a3b4c5d60718293a4e3", payload.title ?: "Untitled collection")};
    }

    # Create a new group
    #
    # + return - returns can be any of following types 
    # http:Ok (The new group)
    # http:BadRequest (Bad Request - Invalid type or missing required parameters)
    # http:Forbidden (Forbidden - Insufficient permissions)
    # http:Conflict (Conflict - Group name already exists)
    # http:DefaultStatusCodeResponse (Error)
    resource function post groups(@http:Payload GroupCreation payload) returns GroupDetailsOk|FlatErrorResponseBadRequest|FlatErrorResponseForbidden|FlatErrorResponseConflict|FlatErrorResponseDefault {
        return <GroupDetailsOk>{body: mockGroup("9f1a2b3c4d5e60718293a4f3", payload.name ?: "New group")};
    }

    # Create a new score
    #
    # + return - returns can be any of following types 
    # http:Ok (Score created)
    # http:Accepted (Score will be imported using an asynchronous task (the API client has set `supportsTasks` to true))
    # http:BadRequest (Bad score creation request)
    # http:PaymentRequired (Account overquota or feature not included in plan)
    # http:DefaultStatusCodeResponse (Error)
    resource function post scores(@http:Payload ScoreCreation payload) returns ScoreDetailsOk|TaskAccepted|FlatErrorResponseBadRequest|FlatErrorResponsePaymentRequired|FlatErrorResponseDefault {
        return <ScoreDetailsOk>{body: mockScore("a1b2c3d4e5f60718293a4b03", "New score"), headers: {x\-flat\-score\-revision: "rev-1", x\-flat\-score\-revision\-date: "2026-01-15T10:30:00.000Z"}};
    }

    # Post a new comment
    #
    # + score - Unique identifier of the score document. This can be a Flat Score unique identifier (i.e. `ScoreDetails.id`) or, if the score is also a Google Drive file, the Drive file unique identifier prefixed with `drive-` (e.g. `drive-0B000000000`)
    # + sharingKey - This sharing key must be specified to access to a score or collection with a `privacy` mode set to `privateLink` and the current user is not a collaborator of the document
    # + return - returns can be any of following types 
    # http:Ok (The new comment)
    # http:PaymentRequired (Account overquota)
    # http:Forbidden (Not granted to access to this score, to post a comment, or your API call triggered our spam filter.)
    # http:NotFound (Score not found)
    # http:DefaultStatusCodeResponse (Error)
    resource function post scores/[string score]/comments(string? sharingKey, @http:Payload ScoreCommentCreation payload) returns ScoreCommentOk|FlatErrorResponsePaymentRequired|FlatErrorResponseForbidden|FlatErrorResponseNotFound|FlatErrorResponseDefault {
        return <ScoreCommentOk>{body: mockComment(score, payload.comment)};
    }

    # Update the class
    #
    # + 'class - Unique identifier of the class
    # + payload - Details of the Class 
    # + return - returns can be any of following types 
    # http:Ok (The new class details)
    # http:DefaultStatusCodeResponse (Error)
    resource function put classes/[string 'class](@http:Payload ClassUpdate payload) returns ClassDetails|FlatErrorResponseDefault {
        return mockClass('class, payload.name ?: "Music Theory 101");
    }

    # Edit a score's metadata
    #
    # + score - Unique identifier of the score document. This can be a Flat Score unique identifier (i.e. `ScoreDetails.id`) or, if the score is also a Google Drive file, the Drive file unique identifier prefixed with `drive-` (e.g. `drive-0B000000000`)
    # + return - returns can be any of following types 
    # http:Ok (Score details)
    # http:PaymentRequired (Account overquota)
    # http:Forbidden (Not granted to access to this score)
    # http:NotFound (Score not found)
    # http:DefaultStatusCodeResponse (Error)
    resource function put scores/[string score](@http:Payload ScoreModification payload) returns ScoreDetails|FlatErrorResponsePaymentRequired|FlatErrorResponseForbidden|FlatErrorResponseNotFound|FlatErrorResponseDefault {
        return mockScore(score, payload.title ?: "Moonlight Sonata");
    }
}

isolated function mockUser(string id = "5a1b2c3d4e5f60718293a4b5") returns UserDetails => {
    id,
    username: "jane_composer",
    name: "Jane Composer",
    firstname: "Jane",
    lastname: "Composer",
    printableName: "Jane Composer",
    'type: "user",
    picture: "https://flat-cdn.com/pictures/jane.png",
    product: "flat",
    htmlUrl: "https://flat.io/@jane_composer",
    bio: "Composer and arranger",
    followersCount: 12
};

isolated function mockCollaborator() returns ResourceCollaborator => {
    id: "b2c3d4e5f60718293a4b5c01",
    aclRead: true,
    aclWrite: true,
    aclAdmin: true,
    isCollaborator: true,
    collaboratorType: "owner",
    user: mockUser()
};

isolated function mockScore(string id, string title) returns ScoreDetails => {
    id,
    title,
    htmlUrl: "https://flat.io/score/" + id,
    editHtmlUrl: "https://flat.io/score/" + id + "/edit",
    privacy: "private",
    user: mockUser(),
    instruments: ["piano"],
    instrumentsNames: ["Piano"],
    collaborators: [mockCollaborator()],
    samples: [],
    numberMeasures: 64,
    creationDate: "2026-01-15T10:30:00.000Z",
    modificationDate: "2026-01-16T08:00:00.000Z"
};

isolated function mockClass(string id, string name) returns ClassDetails => {
    id,
    name,
    state: "active",
    section: "A",
    enrollmentCode: "XK4P9Q",
    creationDate: "2026-01-10T09:00:00.000Z"
};

isolated function mockAssignment(string id, string title) returns ClassAssignment => {
    id,
    title,
    attachments: [],
    'type: "none",
    capabilities: {canPublishInClass: true, canArchive: true, canUnarchive: false, canEdit: true},
    creationDate: "2026-01-12T09:00:00.000Z",
    submissions: [],
    state: "active"
};

isolated function mockCollection(string id, string title) returns Collection => {
    id,
    title,
    htmlUrl: "https://flat.io/collections/" + id,
    privacy: "private",
    'type: "regular",
    creationDate: "2026-01-11T09:00:00.000Z",
    capabilities: {canDeleteScores: true, canAddScores: true, canEdit: true, canShare: true, canDelete: true},
    contents: {scoresCount: 3}
};

isolated function mockGroup(string id, string name) returns GroupDetails => {
    id,
    name,
    usersCount: 2,
    readOnly: false,
    'type: "classStudentsSubGroup",
    creationDate: "2026-01-13T09:00:00.000Z",
    tags: []
};

isolated function mockComment(string score, string comment) returns ScoreComment => {
    id: "c3d4e5f60718293a4b5c6d01",
    date: "2026-01-17T12:00:00.000Z",
    'type: "document",
    score,
    comment,
    rawComment: comment,
    user: "5a1b2c3d4e5f60718293a4b5"
};

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type ClassDetailsOk record {|
    *http:Ok;
    ClassDetails body;
|};

public type CollectionOk record {|
    *http:Ok;
    Collection body;
|};

public type FlatErrorResponseBadRequest record {|
    *http:BadRequest;
    FlatErrorResponse body;
|};

public type FlatErrorResponseConflict record {|
    *http:Conflict;
    FlatErrorResponse body;
|};

public type FlatErrorResponseDefault record {|
    *http:DefaultStatusCodeResponse;
    FlatErrorResponse body;
|};

public type FlatErrorResponseForbidden record {|
    *http:Forbidden;
    FlatErrorResponse body;
|};

public type FlatErrorResponseNotFound record {|
    *http:NotFound;
    FlatErrorResponse body;
|};

public type FlatErrorResponsePaymentRequired record {|
    *http:PaymentRequired;
    FlatErrorResponse body;
|};

public type GroupDetailsOk record {|
    *http:Ok;
    GroupDetails body;
|};

public type ScoreCommentOk record {|
    *http:Ok;
    ScoreComment body;
|};

public type ScoreDetailsOk record {|
    *http:Ok;
    ScoreDetails body;
    record {|string x\-flat\-score\-revision\-date?; string x\-flat\-score\-revision?;|} headers;
|};

public type TaskAccepted record {|
    *http:Accepted;
    Task body;
|};

# An API Error response
public type FlatErrorResponse record {
    # A corresponding code for this error
    string code;
    # The related parameter that caused the error
    string param?;
    # A unique error identifier generated for the request
    string id?;
    # A printable message for this error
    string message;
    # The untranslated error message returned by an external provider (e.g. Google Classroom),
    # when the error originates from one. Only set on errors forwarded from a third party.
    # 
    # Meant for support and IT: display it alongside `message`, never in place of it. `message`
    # is the localized, user-facing text; this field is raw provider output and is always in
    # English
    string providerMessage?;
};
