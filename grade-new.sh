CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'
SFOLDER='student_submission'

rm -rf $SFOLDER # clean the student-submission folder
git clone $1 $SFOLDER #clone into the student-submission folder
echo 'Finished cloning'

# first check if the student has ListExamples.java
if [[ -f $SFOLDER/ListExamples.java ]]
then
    echo 'Found ListExamples.java file'
else
    echo 'No ListExamples.java file found'
    echo "grade: 0"
    exit 1;
fi

# copy the checker and lib into the student's folder
cp TestListExamples.java $SFOLDER
cp -r lib $SFOLDER

cd $SFOLDER

echo $PWD

# compile them, and store error message in the compile.txt file
javac -cp $CPATH *.java 2> compile.txt
cat compile.txt

# check if the compile.txt file is empty, use compile.txt as input
if [[ `wc -w < compile.txt` = 0 ]]
then
    echo 'No compile errors'
else
    echo 'Compile errors'
    echo "grade: 0"
    exit 1;
fi
# run the checker and store the result in the result.txt file, and output in the output.txt file
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples 1>result.txt 0>output.txt

# if th result.txt contains OK, then the test passed
if [[ `grep "OK" result.txt` = 'OK (1 test)' ]]
then
    echo 'Test passed'
    echo "Grade: 100"
    exit 0;
else
    echo 'Test failed'
fi

echo "`grep "Tests run" result.txt`"
# get the Test Count and Failure Count
# grep the last line of the result.txt file, and retain the second part delimited by ':'
# then retain the first part delimited by ','
TEST_COUNT=`grep "Tests run" result.txt | cut -d ':' -f 2 | cut -d ',' -f 1`

# grep the last line of the result.txt file, and retain the second part delimited by ','
# then retain the second part delimited by ':'
FAIL_COUNT=`grep "Failures:" result.txt | cut -d ',' -f 2 | cut -d ':' -f 2`

# calculate the grade
echo "Grade: `expr $((100-$FAIL_COUNT*10))`"
if [[ $FAIL_COUNT = 0 ]]
then
    exit 0;
fi
echo "Failed cases:"
# display each failed case that matched the pattern [1..9]) in the output.txt file
# grep the output.txt file, and retain the lines that matched the pattern [1..9])
# then retain the second part delimited by ')'
CASES=`grep -E "^([0-9])*\)" result.txt`

let index=1
for CASE in $CASES
do
    echo "$INDEX):  `$CASE | cut -d ')' -f 1`"
    index=$(expr $index + 1)
done
exit 0;