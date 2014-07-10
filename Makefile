#!/usr/bin/make -f
CFLAGS += -D__STDC_CONSTANT_MACROS -Wall -std=c++11 -stdlib=libc++

# test: json11.cpp json11.hpp test.cpp
# 	g++ -O -std=c++11 -stdlib=libc++ json11.cpp test.cpp -o test -fno-rtti -fno-exceptions

all: packageFile json11

test: test.cpp json11
	g++ $(CFLAGS) -L. test.cpp json11.so -o test


prefix=/usr/local
libdir=${prefix}/lib
pkgdir=${libdir}/pkgconfig
includedir=${prefix}/include


packageFile:
	echo 'prefix='$(prefix) 				 > json11.pc
	echo 'libdir='$(libdir)					>> json11.pc
	echo 'includedir='$(includedir)   		>> json11.pc
	echo ''                                 >> json11.pc
	echo 'Name: json11' 					>> json11.pc
	echo 'Description: json11 is a tiny JSON library for C++11, providing JSON parsing and serialization.' >> json11.pc
	echo 'Version: 0.0.1' 					>> json11.pc
	echo 'Libs: -L${libdir} -ljson11'       >> json11.pc
	echo 'Cflags: -I${includedir}'          >> json11.pc


json11: json11.cpp json11.hpp
	g++ -c $(CFLAGS) json11.cpp -fno-rtti -fno-exceptions
	g++ -shared $(CFLAGS) -o json11.so.0.0.1 json11.o -fno-rtti -fno-exceptions
	ln -sf json11.so.0.0.1 json11.so

clean:
	rm -f test json11.so*

install: json11.pc json11.so
	mkdir -p $(prefix)/lib
	mkdir -p $(prefix)/include
	install -m 0755 json11.so $(libdir)
	cp json11.pc $(pkgdir)/json11.pc

.PHONY: install

uninstall:
	rm $(libdir)/json11.so

