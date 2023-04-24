import src.ply.lex as lex
import src.ply.yacc as yacc

tokens=(
    "VARIABLE", 
    "CONSTANT",
    "PREDICATE",
    "FUNCTION",
    "IMPLICATION", 
    "DOUBLE_IMPLICATION", 
    "CONJUNCTION", 
    "DISJUNCTION", 
    "NOT", 
    "LPARENT", 
    "RPARENT", 
    "COMMENT",
    "FORALL",
    "EXISTS")

literals=(',')

# Ignored characters
t_ignore = ' \t'

# Token matching rules are written as regexs
t_VARIABLE = r'[x-z][0-9]'
t_CONSTANT = r'[a-c][0-9]'
t_PREDICATE = r'[P-T][0-9]'
t_FUNCTION = r'[f-g][0-9]'
t_IMPLICATION = r'\->'
t_DOUBLE_IMPLICATION = r'\<->'
t_CONJUNCTION = r'\&'
t_DISJUNCTION = r'\|'
t_NOT = r'\!'
t_LPARENT = r'\('
t_RPARENT = r'\)'
t_COMMENT = r"\/\/.*"
t_EXISTS = r"exists"
t_FORALL = r"forall"

# from lowest to highest precedence
precedence=(
    ('left', 'IMPLICATION', 'DOUBLE_IMPLICATION'),
    ('left', 'DISJUNCTION'),
    ('left', 'CONJUNCTION'),
    ('right', 'FORALL', 'EXISTS'),
    ('right', 'NOT')
)

# Define a rule to handle newlines
def t_newline(t):
    r"\n+"
    t.lexer.lineno += 1

# Error handler for illegal characters
def t_error(t):
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()
lexer.lineno = 1

def p_COMMENT(p):
    "expression : COMMENT"
    pass

def p_term(p): 
    '''
    term : VARIABLE
        | CONSTANT
        '''
    pass

def p_term_multiple(p):
    '''
    term : term ',' term
    '''
    pass

def p_term_function(p):
    'term : FUNCTION LPARENT term RPARENT'
    pass

def p_term_parent(p):
    '''
    term : LPARENT term RPARENT 
        | term LPARENT term RPARENT'''
    pass
    
def p_expression_parent(p):
    '''
    expression : LPARENT expression RPARENT 
        | expression LPARENT expression RPARENT
    '''
    pass

def p_expression_predicate(p):
    """
    expression : expression PREDICATE term 
        | PREDICATE term
    """
    pass
    
def p_term_not(p):
    'term : NOT term'
    pass

def p_expression_not(p):
    'expression : NOT expression'
    pass

def p_expression_implication(p):
    '''
    expression : term IMPLICATION term 
        | expression IMPLICATION expression
    '''
    pass

def p_expression_double_implication(p):
    '''
    expression : term DOUBLE_IMPLICATION term
        | expression DOUBLE_IMPLICATION expression
    '''
    pass
    
def p_expression_quantified(p):
    """
    expression : quantifier VARIABLE expression
    """
    pass

def p_quantifier(p):
    """
    quantifier : EXISTS
               | FORALL
    """
    pass

def p_expression(p):
    """
    expression : term CONJUNCTION term
        | expression CONJUNCTION expression
        | term DISJUNCTION term
        | expression DISJUNCTION expression
    """
    pass

#PANIC MODE ERROR HANDLING
def p_error(p):
    if p:
        print(lexer.lineno,"IS INCORRECT")
    # Read ahead looking for a a new line'
    while True:
        tok = parser.token()             # Get the next token
        if not tok or tok.type == '\n': 
            break
    parser.restart()


# Build the parser
parser = yacc.yacc()

with open('test2.txt') as f:
    contents = f.readlines()
    for content in contents:
        try:
            s = content
        except EOFError:
            break
        if not s:
            continue
        result = parser.parse(s)