set -e

CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf ListExamples.java
rm -rf ListExamples.class
git clone $1 student-submission
echo 'Finished cloning'

STUDENT_CODE=student-submission/ListExamples.java

if [[ -f $STUDENT_CODE ]]
then
    echo 'Correct java file found.'
else 
    echo 'Java file "ListExamples.java" not found'
    exit 1
fi

cp $STUDENT_CODE ./

set +e
javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java 2> java_compile.txt

COMP_ERRORS=$(wc -l < "java_compile.txt")

# echo $COMP_ERRORS

if [[ $COMP_ERRORS -gt 0 ]]
then
    echo "Java file could not compile"
    exit 1
fi 

# echo hi

java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > junit.txt
sed '2q;d' junit.txt > line_2.txt
LINE_2=line_2.txt

grep -o E $LINE_2 > failures.txt

grep -o '.' $LINE_2 > total_chars.txt

FAILED_TESTS=$(wc -l < "failures.txt")

TOTAL_CHARS=$(wc -l < "total_chars.txt")

let "RAN_TESTS = $TOTAL_CHARS-$FAILED_TESTS"
let "PASSED_TESTS = $RAN_TESTS - $FAILED_TESTS"
# echo $TOTAL_CHARS
# echo $FAILED_TESTS
# echo $RAN_TESTS

echo "You passed" $PASSED_TESTS "/" $RAN_TESTS




