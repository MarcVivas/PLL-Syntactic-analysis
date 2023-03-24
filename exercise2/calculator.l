%{
    #include <string>
    #include <iostream>
	#include "calculator.tab.h"

	int nlin = 1;
%}

%option nounput
%option noinput
%option noyywrap


%%

\n                              nlin++;         // Count new lines

"//".*                          ; /* Ignore comments */

[ \t]+                          ; /* Ignore spaces and tabs */
 
[a-z]                          {
                                    yylval.reg = yytext[0] - 'a'; 		// Registers
                                	return(REG);
                                }


[0-9]+                          {    // Number found!
	                                 yylval.value = atoi(yytext);
                               	 	 return(INT);
                                }

"||"                            return LOGIC_OR;
">>"                            return RIGHT_SHIFT;
"<<"                            return LEFT_SHIFT;

"&&"                            return LOGIC_AND;
"!="                            return NOT_EQUAL;
"!"                             return yytext[0];
">="                            return GREATER_OR_EQUAL_THAN;
">"                             return yytext[0];
"<="                            return LESS_OR_EQUAL_THAN;
"<"                             return yytext[0];
"=="                            return LOGIC_EQUAL;
"="                             return yytext[0];
"?"                             return yytext[0];

";"                             return ';';         // End of expression


.                     		    return(yytext[0]);	 /*  Errors will be processed by the syntactic analyzer */


