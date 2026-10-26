# Score feedback review

This example reads the most recently updated scores of the authenticated user, including private ones, and prints the collaborators and feedback comments of each. When `postComment` is enabled it also posts a comment on the first score.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A Flat access token with the `collections` and `scores.readonly` scopes, plus `scores.social` to post a comment. See the [setup guide](../../ballerina/README.md#setup-guide).
- Create a `Config.toml` in this directory:
  ```toml
  flatAccessToken = "<your-access-token>"
  postComment = false
  commentText = "Great work on this arrangement"
  ```

## Run the example

```bash
bal run
```
