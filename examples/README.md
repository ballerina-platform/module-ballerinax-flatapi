# Examples

The `ballerinax/flatapi` connector provides practical examples illustrating usage in various scenarios.

1. [Class assignment overview](./class_assignment_overview/class_assignment_overview.md) - List the active classes of a teacher together with their assignments, and optionally create a class.
2. [Score feedback review](./score_feedback_review/score_feedback_review.md) - Print the collaborators and comments on recently updated scores, and optionally post a comment.

## Prerequisites

Each example needs a Flat access token with the scopes the example uses. See the [setup guide](../ballerina/README.md#setup-guide) for how to obtain one, then add it to a `Config.toml` file in the example directory.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
