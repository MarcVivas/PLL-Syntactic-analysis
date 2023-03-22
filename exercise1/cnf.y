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
        | header clauses
        | error '\n' {yyerrok;}
        ;

header: P CNF INT INT '\n'
        {
          if($3 <= 0 || $4 <= 0){
            yyerror("The number of variables and clauses must be > 0");
            yyerrok;
          }
          else{
            totalClauses = $4;
            totalVariables = $3;
          }
        }
  ;

      ;

clauses: {/* empty */}
       | clauses clause '\n'
       ;

clause: list_literals END_OF_CLAUSE {
                                      clausesCounter++;
                                      if(clausesCounter > totalClauses){
                                        yyerror("Exceeded the total number of clauses");
                                        yyerrok;
                                      }
                                      else{
                                        printClause();
                                      }
                                    }
       ;

list_literals:
        | list_literals literal
        ;

literal: INT              {
                           if($1 < -totalVariables || $1 > totalVariables){
                              std::ostringstream oss;
                              oss << "The variables must be in range of (Excluding 0) [" << -totalVariables << ", " << totalVariables << "]";
                              literals.clear();
                              yyerror(oss.str().c_str());
                              yyerrok;
                            } else{
                              literals.push_back($1);
                            }
                          }
       ;

%%

/* Called by yyparse on error. */

void yyerror (char const *s){
  std::cerr << "Error at line " << nlin << ": " << s << '\n';
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
/*
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern int line_number;
extern int yylex(void);
void yyerror (char const *);
%}

%union{
  int value;
	}

%token <value> INT
%token P C ZERO LIT CNF

%start start
%type <value> start file cnf clauses clause
%%

start:
    file { printf("File parsed successfully\n"); }
    | error { fprintf(stderr, "Error: syntax error on line %d\n", line_number); exit(EXIT_FAILURE); }

file:
    cnf clauses ZERO {  }

cnf:
    CNF LIT LIT {}

clauses:
    clauses clause { sprintf($$, "%s%s", $1, $2); }
    | clause { $$ = $1; }

clause:
    LIT { sprintf($$, ""); }
    | '-' LIT { sprintf($$, ""); }

%%

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s file.cnf\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        perror(argv[1]);
        return EXIT_FAILURE;
    }

    yyin = fp;

    yyparse();

    fclose(fp);

    return EXIT_SUCCESS;
}
*/
