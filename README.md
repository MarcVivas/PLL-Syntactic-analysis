# PLL-Syntactic-analysis
20/03/2023
University of Lleida

## Authors
1. Pau Taló
2. Alexandre Pelegrina
3. Marc Vivas

## Table of Contents
1. [Authors](#authors)
2. [About this project](#introduction)
3. [Required libraries/packages](#required-libraries/packages)
4. [Exercise 1](#exercise-1)
5. [Exercise 2](#exercise-2)
6. [Exercise 3](#exercise-3)
7. [Exercise 4](#exercise-4)
8. [Exercise 5](#exercise-5)

## Introduction
The aim of this project is to utilize an automatic syntactic analyzer generation tool for language identification purposes. The instructions to complete the project are available in Catalan and can be found in the `Statement.pdf` document.

## Required libraries/packages
You will need to install the next libraries (Ubuntu) if you want to run the programs:

Flex:
```bash
sudo apt-get install -y flex
```
Make:
```bash
sudo apt-get install -y make
```

Bison:
```bash
sudo apt install bison
```
## Exercise 1
### Considerations
1. For a CNF DIMACS file to be considered correct, it must contain a header `p cnf (num > 0) (num > 0)` followed by at least one newline `\n`. The header must be followed by clauses, each of which must end with a `0`. Each clause can be written with any number of newlines between each literal.
2. You will be able to better understand the characteristics of the implementation by looking at the test files.

### Tests
1. There are `9` tests available that have been used to check the correctness of the exercise.
2. Each test file contains a comment indicating whether the file is in the correct format or not.
3. If the test file is not in the correct format, there is also a comment indicating in which lines the program should throw an error.
4. To facilitate testing, a Python script named `test.py` was created. Running the script with the next command will automatically execute all the test cases and check their results.
```bash
python3 test.py
```
>> Note: It is not necessary to compile the Flex and Bison programs to run the script.


## Exercise 2
### Considerations
1. You will be able to better understand the characteristics of the implementation by looking at the test files.

### Tests
1. The calculator implementation fulfills all the requirements specified in the statement.
2. Comments can be written with `//`. Example: `// This is a comment`.
3. The implementation was tested with `8` different test cases to ensure its correctness.
4. To facilitate testing, a Python script named `test.py` was created. Running the script with the next command will automatically execute all the test cases and check their results.
```bash
python3 test.py
```
>> Note: It is not necessary to compile the Flex and Bison programs to run the script. 

