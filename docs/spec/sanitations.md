_Author_:  @DimuthuMadushan \
_Created_: 2026/10/26 \
_Updated_: 2026/10/26 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Flat. 
The OpenAPI specification is obtained from [https://github.com/wso2/api-specs/blob/main/openapi/flat/flat/2.26.2/openapi.yaml](https://github.com/wso2/api-specs/blob/main/openapi/flat/flat/2.26.2/openapi.yaml).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

The spec as given (OpenAPI 3.1.0, Flat API 2.26.2, 80 paths, 123 operations) is edited in place in `docs/spec/openapi.yaml`; items 1 to 5, 8 and 9 are those edits. The skill's flatten and align steps carry them into `flattened_openapi.yaml` and `aligned_ballerina_openapi.json`, so none of them is re-applied to the aligned spec. No hand edit was made to the aligned spec. The skill generated no auto-generated items for this spec.

1. **OpenAPI version changed from 3.1.0 to 3.0.3.** `bal openapi flatten` drops the `type` of most schema properties and schemas when the document declares OpenAPI 3.1.0, which turns them into untyped fields (584 of 721 properties). The document uses no other 3.1-only construct, so line 1 is now `openapi: 3.0.3`. Made in the original spec.

2. **Type arrays replaced by `nullable`.** All 41 occurrences of `type: [<type>, 'null']` became `type: <type>` plus `nullable: true`, because OpenAPI 3.0 has no type arrays and flatten loses the type of most of them. Rule: for each such array, keep the non-null member as `type` and add `nullable: true`. The 41 places are `AssignmentUpdate` (`nbPlaybackAuthorized`, `toolset`, `coverFile`, `cover`, `maxPoints`), `ClassGroupIdsToApplyToAssignment` (the schema itself, an array), `AssignmentSubmission` (`grade`, `draftGrade`), `AssignmentSubmissionUpdate` (`draftGrade`, `grade`, `exercisesIds`), `ClassAssignmentUpdate` (`allOf[1]` properties `dueDate`, `scheduledDate`, `googleClassroom.topicId`, `microsoftGraph.categories`), `ClassCreation.size`, `ClassUpdate.size`, `ClassDetails.size`, `GoogleClassroomCoursework.topicId`, `LtiConfigurationBase.lastUsedDate`, `LtiConfiguration1p3Dynamic` (`allOf[2]` property `registrationCompletionDate`), `OrganizationInvitation.customCode`, `ScoreLicense` and `ScoreCreationType` (the schemas themselves, strings), `ScoreFork.collection`, `ScoreModification` (`subtitle`, `composer`, `lyricist`, `arranger`, `description`, `licenseText`), `UserBasics.picture`, `UserPublic` (`allOf[1]` property `coverPicture`), `UserDetails` (`allOf[1]` properties `pictureFile`, `coverPictureFile`), `UserCommunityProfileLinks` (`spotifyUrl`, `youtubeUrl`, `soundcloudUrl`, `tiktokUrl`, `instagramUrl`, `websiteUrl`). Made in the original spec.

3. **`info.description` rewritten.** The long Markdown description (links, bullet lists) is replaced by the plain-text sentence "Provides access to the Flat music notation platform. Create, import, browse, update and export music scores, and manage education resources such as organizations, classes, rosters and assignments." It becomes the `Client` class documentation. Made in the original spec.

4. **Missing property and parameter descriptions added (19).** Each addition is one `description` line, and the two bare `$ref` properties are wrapped as `allOf: [{$ref}]` plus `description`. This removes every `undocumented field` warning. Made in the original spec.
   - `OmrPendingStep.data`: "The data of the pending step"
   - `EduResource.resource`: "The assignment or folder described by this resource"
   - `synchronizationPoints` on `ScoreTrack`, `ScoreTrackCreation` and `ScoreTrackUpdate`: "The synchronization points between the track and the score"
   - `ScoreCommentContext`: `startTimePos` "The time position where the commented range starts", `stopTimePos` "The time position where the commented range stops", `startDpq` "The division per quarter note where the commented range starts", `stopDpq` "The division per quarter note where the commented range stops"
   - `AssignmentSubmission`: `attachments` "The attachments of the submission", `playback` "The playback statistics of the submission scores", `comments` "The feedback comments counters of the submission", `microsoftGraph` "The Microsoft Graph submission linked to this submission" (wrapped in `allOf`)
   - `AssignmentSubmissionUpdate`: `attachments` "The attachments to set on the submission", `playback` "The playback statistics of the submission scores"
   - `AssignmentSubmissionHistory.attachment`: "The attachment that changed"
   - `ClassDetails.microsoftGraph`: "The Microsoft Graph course linked to the class"
   - `ScoreRevision.collaborators`: "The user identifiers of the collaborators of the revision"
   - `OmrDetailsStepData.instruments`: "The instruments detected in the scanned pages"
   - `UserDetails.azureDetails`: "The Microsoft Azure account details of the user" (wrapped in `allOf`)
   - `GET /groups`, query parameter `type`: "The type of groups to list"

5. **Binary download responses narrowed to `application/octet-stream` (4 operations).** In the 200 response of each, the media types were replaced by a single `application/octet-stream` with `schema: {type: string, format: binary}`, so the client returns `byte[]`:
   - `GET /scores/{score}/revisions/{revision}/{format}`: the eight media types (`application/json`, `application/vnd.recordare.musicxml+xml`, `application/vnd.recordare.musicxml`, `audio/mp3`, `audio/wav`, `audio/midi`, `image/png`, `application/octet-stream`) collapsed into one entry;
   - `GET /classes/{class}/assignments/{assignment}/submissions/csv`: `text/csv` became `application/octet-stream` (the `default` error response is unchanged);
   - `GET /classes/{class}/assignments/{assignment}/submissions/excel`: `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` became `application/octet-stream` (the `default` error response is unchanged);
   - `GET /omr/jobs/{job}/files/{index}`: `image/jpeg` became `application/octet-stream`.
   Made in the original spec.

6. **Operation renames (decisions kept in `docs/spec/ai-mappings.json`).** `postSubmissionComment` is `addSubmissionComment`, `postScoreComment` is `addScoreComment` (no HTTP-verb names), and `countOrgaUsers` is `countOrganizationUsers`. Every other operation keeps the ID flatten and align gave it.

7. **Schema renames (decisions kept in `docs/spec/ai-mappings.json`).** The generated `GroupsgroupBody` is `RenameGroupRequest`, `GroupUsersBody` is `AddGroupUserRequest` and `InlineResponse200` is `AddGroupUserResponse`. Every other schema keeps its name.

8. **Request body descriptions added (40).** A `description` was added to each request body that had none (an `undocumented parameter 'payload'` warning each; the four empty bodies of item 9 are excluded). Made in the original spec:

| Operation | operationId | requestBody description |
|---|---|---|
| `POST /classes` | `createClass` | Details of the class to create |
| `POST /classes/{class}/assignments` | `createClassAssignment` | Details of the assignment to create |
| `PUT /classes/{class}/assignments/{assignment}` | `updateClassAssignment` | Assignment properties to update |
| `POST /classes/{class}/assignments/{assignment}/copy` | `copyAssignment` | Destination of the assignment copy |
| `PUT /classes/{class}/assignments/{assignment}/submissions` | `createSubmission` | Submission content to create, edit or submit |
| `PUT /classes/{class}/assignments/{assignment}/submissions/{submission}` | `editSubmission` | Submission properties to update |
| `POST /classes/{class}/assignments/{assignment}/submissions/{submission}/comments` | `addSubmissionComment` | The feedback comment to add |
| `PUT /classes/{class}/assignments/{assignment}/submissions/{submission}/comments/{comment}` | `updateSubmissionComment` | The updated feedback comment |
| `POST /collections` | `createCollection` | Details of the collection to create |
| `PUT /collections/{collection}` | `editCollection` | Collection metadata to update |
| `POST /eduResources` | `createEduResource` | Details of the education resource to create |
| `PUT /eduResources/{resource}` | `updateEduResource` | Education resource metadata to update |
| `POST /eduResources/{resource}/move` | `moveEduResource` | Destination folder of the education resource |
| `POST /eduResources/{resource}/copy` | `copyEduResource` | Destination library of the education resource copy |
| `POST /eduResources/{resource}/useInClass` | `useEduResourceInClass` | Class and options for using the education resource |
| `PUT /eduResources/{resource}/assignment` | `updateEduResourceAssignment` | Assignment properties to update on the education resource |
| `POST /groups` | `createGroup` | Details of the group to create |
| `PUT /groups/{group}` | `renameGroup` | The new name of the group |
| `POST /groups/{group}/users` | `addGroupUser` | The student to add to the group |
| `POST /omr/jobs` | `createOmrJob` | Details of the OMR job to create |
| `POST /omr/jobs/{job}/files` | `addOmrJobFile` | The page image file to add to the OMR job |
| `POST /omr/jobs/{job}/steps/{step}` | `submitOmrJobStep` | The data submitted for the interactive OMR step |
| `POST /organizations/users` | `createOrganizationUser` | Details of the user account to create |
| `PUT /organizations/users/{user}` | `updateOrganizationUser` | Account properties to update |
| `POST /organizations/users/{user}/signinLink` | `createOrganizationUserSigninLink` | Options for the sign in link |
| `POST /organizations/users/{user}/accessToken` | `createOrganizationUserAccessToken` | Options for the delegated access token |
| `POST /organizations/invitations` | `createOrganizationInvitation` | Details of the invitation to create |
| `POST /organizations/lti/credentials` | `createLtiCredentials` | Details of the LTI 1.1 credentials to create |
| `POST /organizations/lti/configurations` | `createLtiConfiguration` | Details of the LTI configuration to create |
| `PUT /organizations/lti/configurations/{configuration}` | `updateLtiConfiguration` | LTI configuration properties to update |
| `POST /scores` | `createScore` | Details of the score to create or import |
| `PUT /scores/{score}` | `editScore` | Score metadata to update |
| `POST /scores/{score}/fork` | `forkScore` | Options for forking the score |
| `POST /scores/{score}/collaborators` | `addScoreCollaborator` | The user, group or email to share the score with |
| `POST /scores/{score}/tracks` | `addScoreTrack` | Details of the track to add to the score |
| `PUT /scores/{score}/tracks/{track}` | `updateScoreTrack` | Track properties to update |
| `POST /scores/{score}/comments` | `addScoreComment` | The comment to post on the score |
| `PUT /scores/{score}/comments/{comment}` | `updateScoreComment` | The updated comment |
| `POST /scores/{score}/revisions` | `createScoreRevision` | Details of the revision to create |
| `POST /scores/{score}/revisions/{revision}/{format}/task` | `createExportTask` | Options of the export task |

9. **Empty request bodies removed (4 operations).** The `requestBody` (an `application/x-www-form-urlencoded` body whose schema is just `type: object`, with no properties) was deleted from `PUT /collections/{collection}/scores/{score}`, `DELETE /collections/{collection}/scores/{score}`, `DELETE /scores/{score}/collaborators/{collaborator}` and `DELETE /scores/{score}/comments/{comment}`. It generated a meaningless `record {} payload` parameter on `addScoreToCollection`, `deleteScoreFromCollection`, `removeScoreCollaborator` and `deleteScoreComment`. Made in the original spec.

## Files a rerun needs

- `docs/spec/ai-mappings.json` is committed and is the input for stable operationIds and schema names (items 6 and 7). Keep it in place when regenerating, and do not delete it, or the names are decided again.
- The converted aligned spec `docs/spec/aligned_ballerina_openapi.json` is the YAML output of `bal openapi align` converted to JSON with a YAML loader that does not turn dates into timestamps (the skill's own converter fails on this spec).
- The 25 operations covered by the mock (also kept in `build/mockspec/operations.txt`, which is gitignored): `getAuthenticatedUser,getUser,getScoreCollaborators,createScore,getScore,editScore,deleteScore,getScoreComments,addScoreComment,listCollections,createCollection,getCollection,deleteCollection,listClasses,createClass,getClass,updateClass,listAssignments,getAssignment,listGroups,createGroup,getGroupDetails,listOrganizationUsers,getTask,getUserScores`.
- `ballerina/icon.png` is a solid-colour placeholder 128x128 PNG, not Flat's artwork. Replace it with a real icon if one is available.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json --mode client --license docs/license.txt -o ballerina --client-methods remote
```

Note: The license year is hardcoded to 2026, change if necessary.
