parser: mini_l_3.lex mini_l_2.y
	bison -v -d --file-prefix=parser mini_l.yy
	flex mini_l.lex
	g++ -std=c++11 -o parser parser.tab.cc lex.yy.c -lfl

clean:
	rm -f lex.yy.c parser.tab.* parser.output *.o parser location.hh position.hh stack.hh 
