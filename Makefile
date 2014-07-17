#!/usr/bin/make -f
CFLAGS += -g -D__STDC_CONSTANT_MACROS -Wall -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    CFLAGS += -D LINUX -std=c++0x
endif
ifeq ($(UNAME_S),Darwin)
    CFLAGS += -D OSX -std=c++11 -stdlib=libc++
endif

# test: json11.cc json11.h test.cc
# 	g++ -O -std=c++11 -stdlib=libc++ json11.cc test.cc -o test -fno-rtti -fno-exceptions

all: packageFile json11

prefix=$(DESTDIR)/usr/local
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

test: test.cc json11
	g++ $(CFLAGS) -L. test.cc libjson11.$(libextension) -o test


ifeq ($(UNAME_S),Linux)
json11: json11.cc json11.h
	g++ -fPIC -c $(CFLAGS) json11.cc -fno-rtti -fno-exceptions
	g++ -fPIC -shared $(CFLAGS) -o libjson11.$(libextension) json11.o -fno-rtti -fno-exceptions
endif	

ifeq ($(UNAME_S),Darwin)
libextension=dylib
json11: json11.cc json11.h
	g++ -fPIC -c $(CFLAGS) json11.cc -fno-rtti -fno-exceptions
	g++ -fPIC -dynamiclib $(CFLAGS) -o libjson11.$(libextension) json11.o -fno-rtti -fno-exceptions
endif	

clean:
	rm -f test libjson11.$(libextension) libjson11.dylib.0.0.1 libjson11.so.0.0.1
 
install: json11.pc libjson11.$(libextension)
	mkdir -p $(libdir)
	mkdir -p $(includedir)
	mkdir -p $(pkgdir)
	install -m 0755 libjson11.$(libextension) $(libdir)
	cp json11.h $(includedir)/json11.h
	cp json11.pc $(pkgdir)/json11.pc

.PHONY: install

uninstall:
	rm $(libdir)/libjson11.$(libextension)
	rm $(includedir)/json11.h

