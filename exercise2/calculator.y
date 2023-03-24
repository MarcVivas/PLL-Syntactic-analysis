%{

#include <iostream>
#include<stdio.h>
#include<ctype.h>
#include <string>
#include <unordered_map>
    

int registers [26];
bool registers_in_use[26] {false};

extern FILE *yyin;
extern int nlin;
extern int yylex(void);
void yyerror (char const *);



%}
	

%start calculator

%union{
	int value;
	int reg;
}

%token <reg> REG
%token <value> INT
%token LEFT_SHIFT RIGHT_SHIFT LOGIC_AND LOGIC_OR LOGIC_EQUAL NOT_EQUAL LESS_OR_EQUAL_THAN GREATER_OR_EQUAL_THAN

%right '?' ':'
%left LOGIC_OR
%left LOGIC_AND
%left '|'
%left '^'
%left '&'
%left LOGIC_EQUAL NOT_EQUAL
%left '<' '>' GREATER_OR_EQUAL_THAN LESS_OR_EQUAL_THAN
%left LEFT_SHIFT RIGHT_SHIFT
%left '+' '-'
%left '*' '/' '%'
%left UNARY_MINUS '!' UNARY_PLUS '~'

%type <value> expr statement list_of_statements

%%

calculator	: {;}
       		| list_of_statements
       		{
              // Display the final value of the defined registers
              for(int i = 0; i < 26; i++){
                if(registers_in_use[i]){std::cout << (char)(i + 'a') << " = " << registers[i] << std::endl;}
              }
            }
       		;

list_of_statements: statement
              | list_of_statements statement
              ;

statement  :    ';' 			{;}
                |    expr ';'            {std::cout << $1 << '\n';}
                |    REG '=' expr ';'    {registers[$1] = $3; registers_in_use[$1] = true;}
                |    error ';'           {
                			    yyerror("Invalid expression");
                                            yyerrok;
                                         }

         		  ;
expr  :        '(' expr ')'             {$$ = $2;}
      |        expr '+' expr            {$$ = $1 + $3;}
      |        expr '-' expr            {$$ = $1 - $3;} 
      |        expr '*' expr            {$$ = $1 * $3;}
      |        expr '/' expr            {
      					 if ($3)
                                          $$ = $1 / $3;
                                         else
                                         {
                                           yyerror("Zero division");
                                           YYERROR;}
                                         }
      |       expr '%' expr           { $$ = $1 % $3;}
      |       expr LEFT_SHIFT expr    { $$ = $1 << $3;} // bitwise left shift
      |       expr RIGHT_SHIFT expr   { $$ = $1 >> $3;} // bitwise right shift
      |       expr '&' expr           { $$ = $1 & $3;}  // bitwise AND
      |       expr '|' expr           { $$ = $1 | $3;}  // bitwise OR
      |       expr '^' expr           { $$ = $1 ^ $3; } // bitwise XOR
      |       '~' expr                { $$ = ~ $2; }    // bitwise NOT
      |       '+' expr %prec UNARY_PLUS { $$ = + $2;}
      |       '-' expr %prec UNARY_MINUS   {$$ = - $2;}
      |       REG                     {$$ = registers[$1];}
      |       INT                     {$$ = $1;}
      | expr LOGIC_AND expr { $$ = $1 && $3; }
      | expr LOGIC_OR expr { $$ = $1 || $3; }
      | '!' expr { $$ = !$2; }
      | expr LOGIC_EQUAL expr { $$ = $1 == $3; }
      | expr NOT_EQUAL expr { $$ = $1 != $3; }
      | expr '<' expr { $$ = $1 < $3; }
      | expr LESS_OR_EQUAL_THAN expr { $$ = $1 <= $3; }
      | expr '>' expr { $$ = $1 > $3; }
      | expr GREATER_OR_EQUAL_THAN expr { $$ = $1 >= $3; }
      | expr '?' expr ':' expr { $$ = ($1) ? $3 : $5; }
      ;

%%

/* Called by yyparse on error. */

void yyerror (char const *s){
  std::cerr << "Error at line " << nlin << ": " << s << '\n';
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
