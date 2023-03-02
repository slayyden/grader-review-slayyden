# stop if an error is encountered when trying to find student-submission/ListExamples.java
set -e

CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

# remove previous code
rm -rf student-submission
rm -rf ListExamples.java
rm -rf ListExamples.class

git clone $1 student-submission
echo 'Finished cloning'

# path to the student's source code file
STUDENT_CODE=student-submission/ListExamples.java

# checks to see if the code file exists. If it doesn't, exit w/ error
if [[ -f $STUDENT_CODE ]]
then
    echo 'Correct java file found.'
else 
    echo 'Java file "ListExamples.java" not found'
    exit 1
fi

# copy student's source code file to the working directory
cp $STUDENT_CODE ./

# continue running script even if java has compilation erros
set +e

# compile required files (junit stuff, source code, tester file) and redirect
# stderr output to java_compile.txt
javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java 2> java_compile.txt

# stores number of lines of error printed from compilation
COMP_ERRORS=$(wc -l < "java_compile.txt")

# echo $COMP_ERRORS

# throw error if java file doensn't compile (ie. there are more than 0 lines)
# of error messages printed
if [[ $COMP_ERRORS -gt 0 ]]
then
    echo "Java file could not compile"
    exit 1
fi 

# run JUnit tests
java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > junit.txt

# get line 2 of junit test output. looks something like "..E."
# each dot is an chars test and each "E" is an error
sed '2q;d' junit.txt > line_2.txt
LINE_2=line_2.txt

# write each "E" to its own line in failures.txt
grep -o E $LINE_2 > failures.txt
# grep -o "." $LINE_2 > total_chars.txt

FAILED_TESTS=$(wc -l < "failures.txt")

# calculate total number of characters in line2.
# 1 is subtracted because an extra newline character is added or something
TOTAL_CHARS="$(wc -c < "line_2.txt") - 1"

# compute total number of tests ran and passed
let "RAN_TESTS = $TOTAL_CHARS-$FAILED_TESTS"
let "PASSED_TESTS = $RAN_TESTS - $FAILED_TESTS"

# output message
echo "You passed" $PASSED_TESTS "/" $RAN_TESTS




