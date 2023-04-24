from src.ply.lex import lex
import src.ply.lex as lex
import src.ply.yacc as yacc

tokens=("VARIABLE", "IMPLICATION", "DOUBLE_IMPLICATION", "CONJUNCTION", "DISJUNCTION", "NEGATION", "LPARENT", "RPARENT", "COMMENT")

# Ignored characters
t_ignore = ' \t'

# Token matching rules are written as regexs
t_VARIABLE = r'[A-Z]'
t_IMPLICATION = r'\->'
t_DOUBLE_IMPLICATION = r'\<->'
t_CONJUNCTION = r'\&'
t_DISJUNCTION = r'\|'
t_NEGATION = r'\!'
t_LPARENT = r'\('
t_RPARENT = r'\)'
t_COMMENT = r"\/\/.*"

# from lowest to highest precedence
precedence=(
    ('left', 'IMPLICATION', 'DOUBLE_IMPLICATION'),
    ('left', 'DISJUNCTION'),
    ('left', 'CONJUNCTION'),
    ('right', 'NEGATION')
)

# Define a rule to handle newlines
def t_newline(t):
    r"\n+"
    t.lexer.lineno += 1

# Error handler for illegal characters
def t_error(t):
    print(f'Illegal character {t.value[0]!r} in line {t.lexer.lineno!r}')
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()
lexer.lineno = 1

def p_COMMENT(p):
    "expression : COMMENT"
    pass

def p_expression(p):
    """
    expression : expression CONJUNCTION expression
        | expression DISJUNCTION expression
    """
    p[0] = f"{p[1]}{p[2]}{p[3]}"

def p_expression_parent(p):
    """
    expression : LPARENT expression RPARENT
    """
    p[0] = f"{p[1]}{p[2]}{p[3]}"

def p_expression_variable(p):
    'expression : VARIABLE'
    p[0] = f"{p[1]}"

def p_expression_negation(p):
    'expression : NEGATION expression'
    p[0] = f"{p[1]}{p[2]}"

def p_expression_implication(p):
    '''
    expression : expression IMPLICATION expression
    '''
    p[0] = f'!({p[1]})|{p[3]}'

def p_expression_double_implication(p):
    '''
    expression : expression DOUBLE_IMPLICATION expression
    '''
    p[0] = f"(!({p[1]})|({p[3]}))&(!({p[3]})|({p[1]}))"

#PANIC MODE ERROR HANDLING
def p_error(p):
    if p:
        print("Syntax error at line", lexer.lineno)
    # Read ahead looking for a a new line'
    while True:
        tok = parser.token()             # Get the next token
        if not tok or tok.type == '\n': 
            break
    parser.restart()

# Build the parser
parser = yacc.yacc()

with open('test.txt') as f:
    contents = f.readlines()
    for content in contents:
        try:
            s = content
        except EOFError:
            break
        if not s:
            continue
        result = parser.parse(s)
        if result != None:
            print(s +" TRANSFORMED TO: "+result)
       