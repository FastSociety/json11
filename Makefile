#!/usr/bin/make -f
CFLAGS += -D__STDC_CONSTANT_MACROS -Wall -std=c++11 -stdlib=libc++

# test: json11.cpp json11.hpp test.cpp
# 	g++ -O -std=c++11 -stdlib=libc++ json11.cpp test.cpp -o test -fno-rtti -fno-exceptions

all: json11

test: test.cpp
	g++ $(CFLAGS) -L. test.cpp json11.so -o test


json11: json11.cpp json11.hpp
	g++ -c $(CFLAGS) json11.cpp -fno-rtti -fno-exceptions
	g++ -shared $(CFLAGS) -o json11.so.1.0 json11.o -fno-rtti -fno-exceptions
	ln -sf json11.so.1.0 json11.so

prefix=/usr/local/lib

clean:
	rm -f test json11.so*

install: json11.so
	mkdir -p $(prefix)
	install -m 0755 json11.so $(prefix)

.PHONY: install

uninstall:
	rm $(prefix)/json11.so
