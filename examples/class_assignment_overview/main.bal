// Lists the active classes of the authenticated teacher together with the assignments of each class,
// and optionally creates a new class when `createClass` is enabled.

import ballerina/io;
import ballerinax/flatapi;

configurable string flatAccessToken = ?;
configurable boolean createClass = false;
configurable string newClassName = "Music Theory 101";

public function main() returns error? {
    flatapi:Client flat = check new ({auth: {token: flatAccessToken}});

    if createClass {
        flatapi:ClassDetails created = check flat->createClass({name: newClassName});
        io:println("Created class ", created.name, " with id ", created.id);
    }

    flatapi:ClassDetails[] classes = check flat->listClasses(state = "active");
    io:println("Active classes: ", classes.length());

    foreach flatapi:ClassDetails classroom in classes {
        flatapi:ClassAssignment[] assignments = check flat->listAssignments(classroom.id);
        io:println(classroom.name, " has ", assignments.length(), " assignment(s)");
        foreach flatapi:ClassAssignment assignment in assignments {
            io:println("  - ", assignment.title, " [", assignment.state, "]");
        }
    }
}
