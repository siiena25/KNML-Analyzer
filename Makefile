all: diplom

diplom: clean
	lex lexer.l
	yacc -d parser.y
	cc lex.yy.c y.tab.c -o compiled_parser -lm

clean:
	rm -rf compiled_parser lex.yy.c y.tab.c y.tab.h

