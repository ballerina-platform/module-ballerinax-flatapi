# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Remote methods for the parts of the Flat API that 1.5.2 did not cover, with the records they use:
  - Education resources: `listEduResources`, `listEduLibraries`, `getEduResource`, `createEduResource`, `updateEduResource`, `deleteEduResource`, `copyEduResource`, `copyEduResourceToDemoClass`, `moveEduResource`, `useEduResourceInClass`, `updateEduResourceAssignment` and `createEduResourceLtiLink`.
  - Groups: `listGroups`, `createGroup`, `renameGroup`, `deleteGroup`, `addGroupUser` and `removeGroupUser`.
  - Optical music recognition (OMR) jobs: `getOmrCapabilities`, `listOmrJobs`, `createOmrJob`, `getOmrJob`, `addOmrJobFile`, `getOmrJobFile`, `startOmrJob`, `submitOmrJobStep`, `cancelOmrJob`, `deleteOmrJob` and `getOmrJobExport`.
  - Export tasks: `createExportTask` and `getTask`.
  - Class assignments: `getAssignment`, `updateClassAssignment`, `deleteAssignment` and `createTestStudentAccount`.
  - Organizations: `listLtiConfigurations`, `createLtiConfiguration`, `updateLtiConfiguration`, `deleteLtiConfiguration`, `createOrganizationUserAccessToken`, `createOrganizationUserSigninLink` and `listBillingCreditsHistory`.
- A `*Queries` record for each operation with query parameters, such as `ListCollectionsQueries` and `GetScoreRevisionDataQueries`.
- An optional `headers` parameter on every remote method, for sending extra request headers. The OMR methods take a typed headers record, such as `CreateOmrJobHeaders`.
- New `ConnectionConfig` fields, taken from `http:ClientConfiguration`: `followRedirects`, `cookieConfig`, `socketConfig` and `laxDataBinding`.

### Changed

- **Breaking:** the remote methods are renamed:

    | 1.5.2 | 2.0.0 |
    |---|---|
    | `countOrgaUsers` | `countOrganizationUsers` |
    | `gerUserLikes` | `getUserLikes` |
    | `createAssignment` | `createClassAssignment` |
    | `postScoreComment` | `addScoreComment` |
    | `postSubmissionComment` | `addSubmissionComment` |

- **Breaking:** query parameters are no longer positional. `sharingKey`, `sort`, `limit` and the other query parameters are passed as named arguments (or as the operation's `*Queries` record) after the path parameters and payload:

    ```ballerina
    // 1.5.2
    flatapi:Collection[] collections = check flat->listCollections("root", (), (), 10);
    flatapi:ScoreDetails score = check flat->getScore(scoreId, sharingKey);
    ```

    ```ballerina
    // 2.0.0
    flatapi:Collection[] collections = check flat->listCollections(parent = "root", 'limit = 10);
    flatapi:ScoreDetails score = check flat->getScore(scoreId, sharingKey = sharingKey);
    ```

- **Breaking:** the `parent` query parameter of `listCollections` defaults to `"user"` (was `"root"`). Pass `parent = "root"` for the previous behaviour.
- **Breaking:** the methods whose response has no content return `error?` (was `http:Response|error`): `addClassUser`, `deleteClassUser`, `deleteCollection`, `deleteScore`, `deleteScoreComment`, `deleteScoreFromCollection`, `deleteScoreTrack`, `deleteSubmissionComment`, `markScoreCommentResolved`, `markScoreCommentUnresolved`, `removeOrganizationInvitation`, `removeOrganizationUser`, `removeScoreCollaborator`, `revokeLtiCredentials` and `untrashScore`.
- **Breaking:** other return type changes:
  - `countOrganizationUsers` returns `int` (was `UserDetailsAdmin[]`).
  - `deleteSubmission` returns the deleted `AssignmentSubmission` (was `http:Response`).
  - `listAssignments` returns `ClassAssignment[]` (was `Assignment[]`).
  - `copyAssignment` returns `AssignmentCopyResponse` (was `Assignment`).
  - `addScoreTrack` returns `ScoreTrackCreationResponse`, which wraps the created `ScoreTrack` (was `ScoreTrack`).
  - `createScore` returns `ScoreDetails|Task` (was `ScoreDetails`).
  - `getScoreRevisionData`, `exportSubmissionsReviewsAsCsv` and `exportSubmissionsReviewsAsExcel` return the file as `byte[]` (was `string`).
- **Breaking:** the `format` parameter of `getScoreRevisionData` is a union of the supported formats (`"json"|"mxl"|"xml"|"abc"|"mp3"|"wav"|"midi"|"flat"|"thumbnail.png"|"synchronizationPoints"`), not `string`.
- **Breaking:** `createClassAssignment` takes a `ClassAssignmentUpdate` payload (was `AssignmentCreation`).
- **Breaking:** `ScoreCreation` is a union of `ScoreCreationBuilderData`, `ScoreCreationFileImport` and `ScoreCreationGoogleDriveImport`, and `AssignmentCopy` a union of `AssignmentCopyToClass` and `AssignmentCopyToResourceLibrary`, in place of single records.
- **Breaking:** the class-specific fields of `Assignment` (`classroom`, `creator`, `creationDate`, `dueDate`, `scheduledDate`, `state`, `submissions`, `canvas`, `lti`, `mfc`, `googleClassroom` and `microsoftGraph`) moved to `ClassAssignment`, which includes `Assignment`.
- **Breaking:** records generated for inline schemas are renamed:

    | 1.5.2 | 2.0.0 |
    |---|---|
    | `AssignmentCanvas` | `ClassAssignment_canvas` |
    | `AssignmentLti` | `ClassAssignment_lti` |
    | `AssignmentMfc` | `ClassAssignment_mfc` |
    | `AssignmentcreationGoogleclassroom` | `ClassAssignmentUpdate_googleClassroom` |
    | `AssignmentcreationMicrosoftgraph` | `ClassAssignmentUpdate_microsoftGraph` |
    | `AssignmentsubmissionhistoryAttachment` | `AssignmentSubmissionHistoryAttachment` |
    | `AssignmentsubmissionupdateComments` | `AssignmentSubmissionComments` |
    | `ClassdetailsCanvas` | `ClassDetailsCanvas` |
    | `ClassdetailsClever` | `ClassDetailsClever` |
    | `ClassdetailsGoogleclassroom` | `ClassDetailsGoogleClassroom` |
    | `ClassdetailsGoogledrive` | `ClassDetailsGoogleDrive` |
    | `ClassdetailsIssues` | `ClassDetailsIssues` |
    | `ClassdetailsIssuesSync` | `ClassDetailsIssuesSync` |
    | `ClassdetailsLti` | `ClassDetailsLti` |
    | `ClassdetailsMfc` | `ClassDetailsMfc` |
    | `ClassdetailsMicrosoftgraph` | `ClassDetailsMicrosoftGraph` |
    | `UserdetailsadminLicense` | `UserDetailsAdmin_license` |
    | `FlatLocales` | `FlatLocalesString` |

- **Breaking:** the enumerated types (`AssignmentType`, `AssignmentSubmissionState`, `ClassRoles`, `ClassState`, `CollectionPrivacy`, `CollectionType`, `GroupType`, `LicenseMode`, `LicenseSources`, `LmsName`, `MediaScoreSharingMode`, `OrganizationRoles`, `ScoreCreationType`, `ScoreLicense`, `ScorePrivacy`, `ScoreTrackState` and `ScoreTrackType`) are unions of their allowed values (were `string`).
- **Breaking:** response fields that the API always returns are no longer optional, for example the `id` of `ClassDetails`, `Collection`, `GroupDetails`, `ScoreComment`, `ScoreTrack` and `AssignmentSubmission`.
- **Breaking:** `ConnectionConfig.http1Settings` is now `http:ClientHttp1Settings` (was the connector's own `ClientHttp1Settings`).
- Many records carry fields that 1.5.2 did not model, such as `ClassDetails.level`, `ScoreDetails.editHtmlUrl` and `ScoreTrack.purpose`.
- `ConnectionConfig.timeout` defaults to 30 seconds (was 60).

### Removed

- **Breaking:** the `AssignmentCreation` record. Use `ClassAssignmentUpdate`.
- **Breaking:** the `FlatErrorResponse` record. No method returned it.
- **Breaking:** the array type aliases, such as `ScoreDetailsArr`, `CollectionArr` and `ClassDetailsArr`. Use the array types (`ScoreDetails[]` and so on).
- **Breaking:** fields no longer in the API: `UserBasics.isPowerUser` and `UserBasics.isFlatTeam`, `UserPublic.instruments`, `MicrosoftGraphSubmission.alternateLink`, and `AssignmentSubmissionUpdate.comments`.
- **Breaking:** the connector's own `ClientHttp1Settings` and `ProxyConfig` records. Use `http:ClientHttp1Settings` and `http:ProxyConfig` instead.
