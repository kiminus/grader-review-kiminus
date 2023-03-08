# grader-review-kiminus

run `bash grade.sh <repo-url>` please

this code is written in the windows environment. To run in other OS, replace `;` in the CPATH to `:`

The `ListExamples_crash` and `ListExamples_subtle` are the two custom student submissions. The first one cheated the grader and the second one contains a subtle exception that none of the existing test cases can detect 

### Server

start the server: `java GraderServer <port number>`

grade the submission url: `.../grade?repo=<url>`