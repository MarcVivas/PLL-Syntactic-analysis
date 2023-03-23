%{

#include<iostream>
#include <vector>
#include <sstream>
#include<ctype.h>
#include <stdlib.h>

extern int nlin;
extern int yylex(void);
extern FILE *yyin;
void yyerror (char const *);
void printClause();
void handleClauses();

std::vector<int> literals;
int totalClauses, totalVariables;
int clausesCounter = 0;

%}


%start cnf_file

%union{
  int value;
}

%token <value> INT

%token P CNF END_OF_CLAUSE

%type <value> literal


%%

cnf_file: {/* empty */}
        | newlines header clauses
        | header clauses
        ;

header: P CNF INT INT newlines
        {
          if($3 <= 0 || $4 <= 0){
            yyerror("The number of variables and clauses must be > 0");
          }
          else{
            totalClauses = $4;
            totalVariables = $3;
          }
        }
       | error newlines {yyerrok;}

  ;

clauses:
       | clauses clause
       | error END_OF_CLAUSE {yyerrok;}
       ;

clause: list_literals newlines END_OF_CLAUSE newlines	{handleClauses();}
	| list_literals newlines END_OF_CLAUSE	{handleClauses();}
	| list_literals END_OF_CLAUSE newlines	{handleClauses();}
	| list_literals END_OF_CLAUSE	{handleClauses();}
                                    ;

list_literals: literal
        | list_literals newlines literal
        | list_literals literal
        ;

literal: INT     	{
				 if($1 < -totalVariables || $1 > totalVariables){
                                     std::ostringstream oss;
                                     oss << "The variables must be in range of (Excluding 0) [" << -totalVariables << ", " << totalVariables << "]";
                                     literals.clear();
                                     yyerror(oss.str().c_str());
                                 }
                                 else{
                                     literals.push_back($1);
				 }

                          }
;

newlines: '\n'
	| newlines '\n'
	;

%%

/* Called by yyparse on error. */

void yyerror (char const *s){
  std::cerr << "Error at line " << nlin << ": " << s << '\n';
}

void handleClauses(){
 	clausesCounter++;
	if(clausesCounter > totalClauses){
		yyerror("Exceeded the total number of clauses");
	}
	else{
		printClause();
	}
}

void printClause(){
  if(literals.size() == 0){return;}
  std::cout << '(';

  for (size_t i = 0; i < literals.size(); ++i) {
      if (literals[i] < 0) std::cout << "!";
      std::cout << "p" << abs(literals[i]);
      if (i != literals.size() - 1) std::cout << " v ";
  }

  if(clausesCounter == totalClauses){
    // If it's the last clause, do not print the character `^`
    std::cout << ")\n";
  }
  else{
    // If it's not the last clause, print the character `^`
    std::cout << ") ^\n";
  }
  literals.clear();
}


int main(int argc, char **argv){
  if (argc>2)
    std::cerr << "Error, usage: " << argv[0] << " [file]\n";
  else{
      if (argc==2)
          yyin = fopen( argv[1], "r" );
        if (yyparse()==0)
          return(0);
        else {
          fprintf(stderr,"Acabament fitxer inesperad Línea %d \n", nlin);
          return(1);
        }
    }
}