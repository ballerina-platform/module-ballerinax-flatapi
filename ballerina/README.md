## Overview

[Flat](https://flat.io) is a collaborative music notation platform for creating, sharing and teaching music. The Flat connector lets Ballerina integrations work with scores, collections, comments and collaborators, and with the education features of Flat such as organizations, classes, groups and assignments.

The connector supports version 2.26.2 of the Flat REST API.

### Key features

- Create, import, update and delete music scores and manage their collaborators and comments
- Organize scores into collections and browse the scores of a user
- Manage classes, groups, assignments and student submissions for education workflows
- Administer organization users, invitations and LTI configurations
- Convert scanned sheet music into editable scores with optical music recognition jobs

## Setup guide

To use the Flat connector you need an access token for the Flat API.

1. Sign in to [Flat](https://flat.io) and open the [developer settings](https://flat.io/developers/apps).

2. Create a new app, or open an existing one, to obtain a client ID and client secret for OAuth 2.0. To try the connector quickly, generate a personal access token from the same page instead.

3. Request only the scopes your integration needs, for example `scores.readonly` to read scores, `scores.social` to post comments, `edu.classes.readonly` to read classes or `edu.classes` to manage them.

4. Complete the OAuth 2.0 authorization code flow against `https://flat.io/auth/oauth` and `https://api.flat.io/oauth/access_token` to obtain an access token and a refresh token.

5. Store the token in a `Config.toml` file next to your Ballerina program:

   ```toml
   flatAccessToken = "<your-access-token>"
   ```

## Quickstart

To use the Flat connector in your Ballerina application, update the `.bal` file as follows:

1. Import the `ballerinax/flatapi` module.

   ```ballerina
   import ballerinax/flatapi;
   ```

2. Create a `Config.toml` file and add the access token.

   ```toml
   flatAccessToken = "<your-access-token>"
   ```

3. Create a `flatapi:Client` with the access token.

   ```ballerina
   configurable string flatAccessToken = ?;

   final flatapi:Client flat = check new ({auth: {token: flatAccessToken}});
   ```

4. Invoke an operation, for example retrieve the authenticated user.

   ```ballerina
   public function main() returns error? {
       flatapi:UserDetails _ = check flat->getAuthenticatedUser();
   }
   ```

## Examples

The `Flat` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-flatapi/tree/main/examples/), covering the following use cases:

1. [Class assignment overview](https://github.com/ballerina-platform/module-ballerinax-flatapi/tree/main/examples/class_assignment_overview) - List the active classes of a teacher together with their assignments, and optionally create a class.
2. [Score feedback review](https://github.com/ballerina-platform/module-ballerinax-flatapi/tree/main/examples/score_feedback_review) - Print the collaborators and comments on recently updated scores, and optionally post a comment.
