# test: json11.cpp json11.hpp test.cpp
# 	g++ -O -std=c++11 -stdlib=libc++ json11.cpp test.cpp -o test -fno-rtti -fno-exceptions

test: test.cpp
	g++ -Wall -std=c++11 -stdlib=libc++ -L. test.cpp json11.so -o test


json11: json11.cpp json11.hpp
	g++ -c -Wall -std=c++11 -stdlib=libc++ json11.cpp -fno-rtti -fno-exceptions
	g++ -shared -std=c++11 -stdlib=libc++ -o json11.so.1.0 json11.o -fno-rtti -fno-exceptions
	ln -sf json11.so.1.0 json11.so

prefix=/usr/local

install: json11.so
	install -m 0755 json11.so $(prefix)/lib

.PHONY: install
