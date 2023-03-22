%{
	#include "cnf.tab.h"
	int nlin=1;
  // printf("%s \n", yytext);
%}

%option nounput
%option noinput
%option noyywrap


%%



[ \t]+                           ; /* Ignore tabs and spaces */


^c.*\n                       				nlin++; /* Ignore comments */



p                                return P;   /* 'p' keyword */



"cnf"                            return CNF;  /* 'cnf' keyword*/


-?[1-9][0-9]?+                       {  /* Integers*/

                                  yylval.value=atoi(yytext);
                               	 	return INT;
                               }


0																 return END_OF_CLAUSE;



\n                                {
                                    /* Count new lines */
                                    nlin++;
																		return '\n';
                                  }



.                     		 	    {return(yytext[0]);}  /*  Errors will be processed by the syntactic analyzer */
