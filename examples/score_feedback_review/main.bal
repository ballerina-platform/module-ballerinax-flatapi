// Reviews the most recently updated scores of the authenticated user, including private ones: prints the
// collaborators and feedback comments of each, and optionally posts a comment on the first score when
// `postComment` is enabled.

import ballerina/io;
import ballerinax/flatapi;

configurable string flatAccessToken = ?;
configurable boolean postComment = false;
configurable string commentText = "Great work on this arrangement";

public function main() returns error? {
    flatapi:Client flat = check new ({auth: {token: flatAccessToken}});

    // The `allScores` collection lists public and private scores, unlike `getUserScores`.
    flatapi:ScoreDetails[] scores = check flat->listCollectionScores("allScores", 'limit = 5);
    if scores.length() == 0 {
        return error("The account has no scores to review");
    }

    foreach flatapi:ScoreDetails score in scores {
        io:println("Score: ", score.title);

        flatapi:ResourceCollaborator[] collaborators = check flat->getScoreCollaborators(score.id);
        foreach flatapi:ResourceCollaborator collaborator in collaborators {
            string name = collaborator.user?.username ?: collaborator.userEmail ?: collaborator.id ?: "unknown";
            io:println("  Collaborator: ", name, " (write access: ", collaborator.aclWrite, ")");
        }

        flatapi:ScoreComment[] comments = check flat->getScoreComments(score.id);
        foreach flatapi:ScoreComment comment in comments {
            io:println("  Comment: ", comment.comment);
        }
    }

    if postComment {
        flatapi:ScoreComment added = check flat->addScoreComment(scores[0].id, {comment: commentText});
        io:println("Posted comment ", added.id, " on ", scores[0].title);
    }
}
