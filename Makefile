CC = g++
LEX = flex
YACC = bison
TARGET= cnf
CFLAGS = -Wall

$(TARGET) : $(TARGET).tab.c  lex.yy.c
	$(CC) $(CFLAGS) $(TARGET).tab.c lex.yy.c -o $(TARGET)

$(TARGET).tab.c: $(TARGET).y
	$(YACC) -d -v $(TARGET).y -o $(TARGET).tab.c

lex.yy.c : $(TARGET).l
	flex $(TARGET).l

clean :
	rm -f $(TARGET) $(TARGET).tab.c $(TARGET).tab.h lex.yy.c $(TARGET).output
