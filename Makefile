#!/usr/bin/make -f
CFLAGS += -D__STDC_CONSTANT_MACROS -Wall -std=c++11 -stdlib=libc++

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    CCFLAGS += -D LINUX
endif
ifeq ($(UNAME_S),Darwin)
    CCFLAGS += -D OSX
endif

# test: json11.cc json11.h test.cc
# 	g++ -O -std=c++11 -stdlib=libc++ json11.cc test.cc -o test -fno-rtti -fno-exceptions

all: packageFile json11

test: test.cc json11
	g++ $(CFLAGS) -L. test.cc json11.dylib -o test


prefix=/usr/local
libdir=${prefix}/lib
pkgdir=${libdir}/pkgconfig
includedir=${prefix}/include
libextension=so
ifeq ($(UNAME_S),Darwin)
	libextension=dylib
endif

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

ifeq ($(UNAME_S),Linux)
json11: json11.cc json11.h
	g++ -c $(CFLAGS) json11.cc -fno-rtti -fno-exceptions
	g++ -fPIC -shared $(CFLAGS) -o json11.so.0.0.1 json11.o -fno-rtti -fno-exceptions
	ln -sf json11.so.0.0.1 json11.so
endif	

ifeq ($(UNAME_S),Darwin)
libextension=dylib
json11: json11.cc json11.h
	g++ -c $(CFLAGS) json11.cc -fno-rtti -fno-exceptions
	g++ -fPIC -dynamiclib $(CFLAGS) -o json11.so.0.0.1 json11.o -fno-rtti -fno-exceptions
	ln -sf json11.so.0.0.1 json11.dylib
endif	

clean:
	rm -f test json11.so*

install: json11.pc json11.$(libextension)
	mkdir -p $(libdir)
	mkdir -p $(includedir)
	install -m 0755 json11.$(libextension) $(libdir)
	cp json11.h $(includedir)/json11.h
	cp json11.pc $(pkgdir)/json11.pc

.PHONY: install

uninstall:
	rm $(libdir)/json11.$(libextension)
	rm $(includedir)/json11.h

