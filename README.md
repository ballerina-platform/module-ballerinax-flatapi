# Ballerina FlatAPI connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-flatapi/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-flatapi/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-flatapi.svg)](https://github.com/ballerina-platform/module-ballerinax-flatapi/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module%2Fflatapi.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fflatapi)

## Overview

[Flat](https://flat.io) is a collaborative music notation platform for creating, sharing and teaching music. The Flat connector lets Ballerina integrations work with scores, collections, comments and collaborators, and with the education features of Flat such as organizations, classes, groups and assignments.

The connector supports version 2.26.2 of the Flat REST API.

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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`flatapi` package](https://central.ballerina.io/ballerinax/flatapi/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
