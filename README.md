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
8. [Exercise 6](#exercise-6)

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
> Note: It is not necessary to compile the Flex and Bison programs to run the script.


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
> Note: It is not necessary to compile the Flex and Bison programs to run the script. 

## Exercise 3
### Code explanation
First que declare the tokens, the characters we need to ignore (the spaces and tabs), the matching rules for the
tokens written as regexs and the precedences, written from lowest to highest.

We defined a rule to handle the newlines and count them to later print it if there is any error aswell a function to 
handle the possible illegal characters, printing it and the number of line.

For the comment, if the program find a //, skips it. With this, the program will ignore the line and read the next one.

For the expressions, we made a function for every token or a combination of tokens.
For every expression except the implication and double implication, we return the same as we read as expression, but
for the implication and double implication, we return the expression parsed without it.

Finally, we handle the parse erros with a function with panic mode, printing the line we found the error and 
passing to the next line.

### Tests
Running the script with the next command will automatically execute all the test cases and check their results.
```bash
python3 ex3.py
```

## Exercise 4
### Code explanation
For this exercise, we followed the same schema as the exercise 3, including more toknes, a literal for the comma and 
diferent precedences.

The error handlers and the functions for new line and comments are the same.

In this case, the functions for the expressions will not make any type of parse, it will check the rule, and if the rule
is true, it will pass, to the next line until it finish the test document, but if there is some error, the program will
print the line saying it's incorrect.

### Tests
Running the script with the next command will automatically execute all the test cases and check their results.
```bash
python3 ex4.py
```

## Exercise 6
We have done exercise `6.1`.

### Program structure
This section provides a brief overview of the components of the program and their respective responsibilities:

1. `automata.l`: `Flex` program that performs lexical analysis of the proposed language.
2. `automata.y`: `Bison` program that syntactically analyzes the proposed language.
3. `AutomataBuilder.cpp`: Class that generates instances of `Automata`.
4. `Automata.cpp`: Class that represents an automata.

During the parsing process, `AutomataBuilder` builds an automata from the input, and once parsing is complete, `Automata` minimizes the generated automata.

### Tests
To facilitate testing, a Python script named `test.py` was created. Running the script with the next command will automatically execute all the test cases and check their results.
```bash
python3 test.py
```
> Note: It is not necessary to compile the Flex and Bison programs to run the script.

### Created language
The language described below defines a syntax for describing a finite automaton(deterministic and non-deterministic). It includes the definition of an alphabet, a set of states, and the transitions between those states based on the letters in the alphabet. The language allows for the designation of multiple initial states and one or more final states. The purpose of this language is to provide a way to specify a finite automaton and to implement a lexical analyzer that can identify the sequence of tokens in the input based on the defined automaton.

The language has been slightly modified since the last assignment.

#### Alphabet definition

Example:
```
ALPHABET => b, a, c, d, e, f <=
```
> The end of the definition is marked by `<=`.

#### ALPHABET
`ALPHABET` is a reserved word that is always followed by the operator `=>` to indicate the set of symbols of the automata's alphabet. In other programming languages `ALPHABET` can be seen as `String, int, char...`

#### Alphabet's symbols
Alphabet's symbols are used to define the set of valid inputs that an automata can accept. The symbols must be letters in lower case separated by optional commas.


#### States definition
Example:
```
STATES => ->q0, q1, ->q2, t3, t0->, t44, k2->   <= // ->q1 is an intial state && t0-> is a final state && q1 is an intermediate state
```
> The end of the definition is marked by `<=`.

#### STATES
`STATES` is a reserved word that is always followed by the operator `=>` to indicate the set of states of the automata. In other programming languages `STATES` can be seen as `String, int, char...`

#### Set of states
The state names must be one lower case letter followed by a number `Example: q0`. The initial state is indicated by a right arrow `->` followed by the state name. The final state is indicated by the state name followed by a right arrow `->`. The intermediate state is indicated by the state name only. All the states must be separated by optional commas.



#### The operator `=>`
The operator `=>` is used to separate the reserved word from the set of symbols of the alphabet, states or transitions that follow it.

#### The operator `<=`
The operator `<=` is used to mark the end of the definition of the alphabet, states or transitions.



#### Transitions definition
#### TRANSTITIONS
`TRANSITIONS` is a reserved word that is always followed by the operator `=>` to indicate the set of transitions of the automata. In other programming languages `TRANSITIONS` can be seen as `String, int, char...`

#### Set of transitions
The transitions of the automata represent the change of state that the automata goes through when it receives a specific input symbol. The transitions are defined by a state, an input symbol in square brackets `[]`, 3 points `...` and the state that the automata goes to after reading the input symbol. The transitions are separated by `;`.

Example:
```
TRANSITIONS =>
->q0[a]...q1;
->q0[b]...t3;
->q0[b]...t44;
t3[a]...k2->, q1;
<=
```
> The end of the definition is marked by `<=`.

#### Example of a complete automata definition

```javascript
// Alphabet definition
ALPHABET => a, b, c, d, e, f,g,h,i,     j <=

// States definition
STATES => ->q0, q1, ->q2, t3, t0->, t44, k2-> <=   // ->q1 is an intial state && t0-> is a final state

// Transitions definitions
TRANSITIONS =>
->q0[a]...q1;
->q0[b]...t3;
->q0[b]...t44;
t3[a]...k2->, q1;
<=
```

This automata accepts inputs of symbols a, b, c, d, e, f, g, h, i and goes through the following states when reading those symbols:

- From the initial state `q0` to the intermediate state `q1` after reading symbol `a`
- From the initial state `q0` to the intermediate states `t3` and/or `t44` after reading symbol `b`
- From the intermediate state `t3` to the final state `k2` and/or the intermediate state `q1` after reading symbol `a`.

> Note: You can write more than one automaton in the same file
