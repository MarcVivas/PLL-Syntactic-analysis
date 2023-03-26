%{
	#include "automata.tab.h"

    // Global variable to keep track of the current line number
    int line_count = 1;
%}

%option nounput
%option noinput
%option noyywrap

%x ERROR_STATE

%%

\n                        { line_count++; }  // Count the number of lines

"//".*        ;  // Ignore comments

[ \t,]+        ;  // Ignore spaces tabs and commas

"ALPHABET"              return ALPHABET;
"STATES"                return STATES;
"TRANSITIONS"           return TRANSITIONS;
\<"="                   return END_OF_DEFINITION;
"="\>                   return START_OF_DEFINITION;

[a-z0-9]                   {
                            yylval.sym = yytext[0];
                            return ALPHABET_SYMBOL;
                        }

"-"\>[a-z][0-9]+        {
                            yylval.automata_state.letter = yytext[2];
                            yylval.automata_state.state_id = atoi(&yytext[3]);
                            yylval.automata_state.state_type = 1;
                            return INITIAL_STATE;
                        }

[a-z][0-9]+"-"\>        {
                            yylval.automata_state.letter = yytext[0];
                            yylval.automata_state.state_id = atoi(yytext + 1);
                            yylval.automata_state.state_type = 3;
                            return FINAL_STATE;
                        }

[a-z][0-9]+             {
                            yylval.automata_state.letter = yytext[0];
                            yylval.automata_state.state_id = atoi(&yytext[1]);
                            yylval.automata_state.state_type = 2;
                            return INTERMEDIATE_STATE;
                        }

"["                     return '[';
"]"                     return ']';
"..."                   return POINTS;
";"                     return ';';

[a-z]+                  {
                            // Error: Alphabet symbol has length greater than 1
                            // Encountered an error, enter the ERROR_STATE
                            yymore();
                            BEGIN(ERROR_STATE);
                        }

.                       {
                            // Rule for handling errors
                            // Encountered an error, enter the ERROR_STATE
                            yymore();
                            BEGIN(ERROR_STATE);
                        }

<ERROR_STATE>["<="\n";"]       ; {
                                // Print the invalid expression and quit the error state
                                int len = yyleng - 1;
                                int count = line_count;
                                if(yytext[len] == '\n') {
                                    line_count++;
                                }
                                yytext[len]='\0';
                                BEGIN(0);
                                printf("Error at line %d caused by '%c': invalid expression '%s'\n", count, yytext[0], yytext);
                            }

<ERROR_STATE>.          { yymore(); }
