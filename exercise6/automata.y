%{

#include <iostream>
#include<stdio.h>
#include<ctype.h>
#include <string>
#include <map>
#include <set>
#include <queue>
#include "include/Automata.cpp"
#include "include/AutomataBuilder.cpp"
#include <sstream>

extern FILE *yyin;
extern int line_count;
extern int yylex(void);
void yyerror (char const *);
std::string getState(char letter, int state_id, int state_type);

AutomataBuilder automataBuilder;

%}
	

%start automata_file

%union{
	char sym;


	struct State
	{
        char letter;
        int state_id;
        int state_type;
    } automata_state;
}

%token <sym> ALPHABET_SYMBOL
%token <automata_state> INITIAL_STATE FINAL_STATE INTERMEDIATE_STATE
%token ALPHABET TRANSITIONS STATES END_OF_DEFINITION START_OF_DEFINITION POINTS

%type <sym> symbol
%type <automata_state> state transition_state

%%

automata_file   : {;}
       		    | automata_file automata
       		    ;

automata:     alphabet_definition states_definition transitions_definition {
                                                                                std::cout << automataBuilder.build().minimize() << std::endl;
                                                                                automataBuilder.resetBuilder();
                                                                           }
            ;

alphabet_definition:    ALPHABET START_OF_DEFINITION symbols END_OF_DEFINITION
                        | error END_OF_DEFINITION {yyerrok;}
                        ;

symbols:    symbol
            | symbols symbol
            ;

symbol:     ALPHABET_SYMBOL {automataBuilder.add_alphabet_letter($1);}
            ;

states_definition:  STATES START_OF_DEFINITION states END_OF_DEFINITION
                    | error END_OF_DEFINITION   {yyerrok;}
                    ;

states: state
        | states state
        ;

state:  INITIAL_STATE   {automataBuilder.add_start_state(getState($1.letter, $1.state_id, $1.state_type));}
        | FINAL_STATE   {automataBuilder.add_accepting_state(getState($1.letter, $1.state_id, $1.state_type));}
        | INTERMEDIATE_STATE    {automataBuilder.add_intermediate_state(getState($1.letter, $1.state_id, $1.state_type));}
        ;

transitions_definition: TRANSITIONS START_OF_DEFINITION transitions END_OF_DEFINITION
                      ;

transitions:    transition ';'
                | transitions transition ';'
                | error ';'     {yyerrok;}
                ;

transition: transition_state '[' ALPHABET_SYMBOL ']' POINTS transition_state { automataBuilder.add_transition(getState($1.letter, $1.state_id, $1.state_type), $3, getState($6.letter, $6.state_id, $6.state_type));}

transition_state: INITIAL_STATE   {$$ = $1;}
            |   FINAL_STATE {$$ = $1;}
            |   INTERMEDIATE_STATE  {$$ = $1;}
            ;
%%


/* Called by yyparse on error. */

void yyerror (char const *s){
  std::cerr << "Error at line " << line_count << ": " << s << '\n';
}

std::string getState(char letter, int state_id, int state_type){
    std::ostringstream oss;
    if(state_type == 3){
        // Final state
        oss << letter << state_id << "->";
        return oss.str();
    }
    else if(state_type == 2){
        // Intermediate state
        oss << letter << state_id;
        return oss.str();
    }

    // Initial state
    oss << "->" << letter << state_id;
    return oss.str();


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
          fprintf(stderr,"Acabament fitxer inesperad Línea %d \n", line_count);
          return(1);
        }
  }
}


