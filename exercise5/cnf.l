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


^\/\/.*\n                       		 nlin++; /* Ignore comments */



[A-Z][ \t]*:                                {  yylval.builder=yytext;
                               	  return B;
                               }   /* 'B' keyword */



[a-z][a-zA-Z]*                            {  /* 'TW' keyword */
                                  yylval.word=yytext;
                               	  return TW;
                               }
                               
[A-Z][a-zA-Z]*                            {  /* 'BW' keyword */
                                  yylval.word=yytext;
                               	  return BW;
                               }                             


"\|"					return '|';


"\;"					return ';';



\n                                nlin++;


