%{

#include<iostream>
#include <vector>
#include <sstream>
#include<ctype.h>
#include <stdlib.h>
#include <string.h>

extern int nlin;
extern int yylex(void);
extern FILE *yyin;
void yyerror (char const *);
char actual;


#define C 'Z'-'A'+1
#define T 'z'-'a'+1

bool taula_c[C][C]={{false}};
bool taula_t[C][T]={{false}};
bool def[C]={false};

%}


%start ll_file

%union{
  char* builder;
  char* word;
}

%token <builder> B
%token <word> TW BW



%%

ll_file: {/* empty */}
        | clauses clause
        | clause
        ;

clauses: clauses clause
	| clause
       ;

clause: builder pieces eoc	;

eoc: ';'	;

builder: B		{def[$1[0]-'A']=true;actual=$1[0];};

pieces: piece '|' pieces
        | piece
        ;

piece: TW     	{taula_t[actual-'A'][$1[0]-'a']=true;}
	| BW	{taula_c[actual-'A'][$1[0]-'A']=true;}
;

%%

/* Called by yyparse on error. */

void yyerror (char const *s){
  std::cerr << "Error at line " << nlin << ": " << s << '\n';
}

void primers(char builder){
	for(int i=0; i<26; i++){
		if (taula_c[builder-'A'][i]){
			primers(i+'A');
			for(int j=0; j<26; j++){
				if (taula_t[i][j]){
					taula_t[builder-'A'][j]=true;
				}
			taula_c[builder-'A'][i]=false;	
			}
		   }
	   }	
}

int main(int argc, char **argv){
  if (argc>2)
    std::cerr << "Error, usage: " << argv[0] << " [file]\n";
  else{
      if (argc==2)
          yyin = fopen( argv[1], "r" );
        if (yyparse()==0){
          for(int i=0; i<26; i++){
          	if(def[i]){
          		primers(i+'A');
          		printf("%c= ", i+'A');
          		for(int j=0; j<26; j++){
          			if (taula_t[i][j]){
          				printf("%c ", j+'a');
          			}
          		}
          		
          		printf("\n");
          	}
          } 
          return(0);
          }
        else {
          fprintf(stderr,"Acabament fitxer inesperat Línea %d \n", nlin);
          return(1);
        }
    }
}
