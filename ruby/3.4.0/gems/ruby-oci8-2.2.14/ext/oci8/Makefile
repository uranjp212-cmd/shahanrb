
SHELL = /bin/sh

# V=0 quiet, V=1 verbose.  other values don't work.
V = 0
V0 = $(V:0=)
Q1 = $(V:1=)
Q = $(Q1:0=@)
ECHO1 = $(V:1=@ :)
ECHO = $(ECHO1:0=@ echo)
NULLCMD = :

#### Start of system configuration section. ####

srcdir = .
topdir = /C/Ruby34-x64/include/ruby-3.4.0
hdrdir = $(topdir)
arch_hdrdir = /C/Ruby34-x64/include/ruby-3.4.0/x64-mingw-ucrt
PATH_SEPARATOR = :
VPATH = $(srcdir):$(arch_hdrdir)/ruby:$(hdrdir)/ruby
prefix = $(DESTDIR)/C/Ruby34-x64
rubysitearchprefix = $(rubylibprefix)/$(sitearch)
rubyarchprefix = $(rubylibprefix)/$(arch)
rubylibprefix = $(libdir)/$(RUBY_BASE_NAME)
exec_prefix = $(prefix)
vendorarchhdrdir = $(vendorhdrdir)/$(sitearch)
sitearchhdrdir = $(sitehdrdir)/$(sitearch)
rubyarchhdrdir = $(rubyhdrdir)/$(arch)
vendorhdrdir = $(rubyhdrdir)/vendor_ruby
sitehdrdir = $(rubyhdrdir)/site_ruby
rubyhdrdir = $(includedir)/$(RUBY_VERSION_NAME)
vendorarchdir = $(vendorlibdir)/$(sitearch)
vendorlibdir = $(vendordir)/$(ruby_version)
vendordir = $(rubylibprefix)/vendor_ruby
sitearchdir = $(sitelibdir)/$(sitearch)
sitelibdir = $(sitedir)/$(ruby_version)
sitedir = $(rubylibprefix)/site_ruby
rubyarchdir = $(rubylibdir)/$(arch)
rubylibdir = $(rubylibprefix)/$(ruby_version)
sitearchincludedir = $(includedir)/$(sitearch)
archincludedir = $(includedir)/$(arch)
sitearchlibdir = $(libdir)/$(sitearch)
archlibdir = $(libdir)/$(arch)
ridir = $(datarootdir)/$(RI_BASE_NAME)
modular_gc_dir = $(DESTDIR)
mandir = $(datarootdir)/man
localedir = $(datarootdir)/locale
libdir = $(exec_prefix)/lib
psdir = $(docdir)
pdfdir = $(docdir)
dvidir = $(docdir)
htmldir = $(docdir)
infodir = $(datarootdir)/info
docdir = $(datarootdir)/doc/$(PACKAGE)
oldincludedir = $(DESTDIR)/usr/include
includedir = $(prefix)/include
runstatedir = $(localstatedir)/run
localstatedir = $(prefix)/var
sharedstatedir = $(prefix)/com
sysconfdir = $(DESTDIR)
datadir = $(datarootdir)
datarootdir = $(prefix)/share
libexecdir = $(exec_prefix)/libexec
sbindir = $(exec_prefix)/sbin
bindir = $(exec_prefix)/bin
archdir = $(rubyarchdir)


CC_WRAPPER = 
CC = gcc
CXX = g++ -std=gnu++11
LIBRUBY = lib$(RUBY_SO_NAME).dll.a
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -l$(RUBY_SO_NAME)-static $(MAINLIBS)
empty =
OUTFLAG = -o $(empty)
COUTFLAG = -o $(empty)
CSRCFLAG = $(empty)

RUBY_EXTCONF_H = extconf.h
cflags   = $(hardenflags)  $(optflags) $(debugflags) $(warnflags)
cxxflags = 
optflags = -O3 -fno-omit-frame-pointer -fno-fast-math
debugflags = -ggdb3
warnflags = -Wall -Wextra -Wdeprecated-declarations -Wdiv-by-zero -Wduplicated-cond -Wimplicit-function-declaration -Wimplicit-int -Wpointer-arith -Wwrite-strings -Wold-style-definition -Wimplicit-fallthrough=0 -Wmissing-noreturn -Wno-cast-function-type -Wno-constant-logical-operand -Wno-long-long -Wno-missing-field-initializers -Wno-overlength-strings -Wno-packed-bitfield-compat -Wno-parentheses-equality -Wno-self-assign -Wno-tautological-compare -Wno-unused-parameter -Wno-unused-value -Wsuggest-attribute=format -Wsuggest-attribute=noreturn -Wunused-variable -Wno-shorten-64-to-32 -Wno-dll-attribute-on-redeclaration -Wmisleading-indentation -Wundef
cppflags = 
CCDLFLAGS = 
CFLAGS   = $(CCDLFLAGS) -O3 -fstack-protector-strong "-IC:/Ora64/product/12.2.0/client_1/OCI/INCLUDE" -D_int64="long long" -Wall $(ARCH_FLAG)
INCFLAGS = -I. -I$(arch_hdrdir) -I$(hdrdir)/ruby/backward -I$(hdrdir) -I$(srcdir)
DEFS     = -D_FILE_OFFSET_BITS=64
CPPFLAGS = -DRUBY_EXTCONF_H=\"$(RUBY_EXTCONF_H)\" -D_WIN32_WINNT=0x0600 -D__MINGW_USE_VC2005_COMPAT $(DEFS) $(cppflags)
CXXFLAGS = $(CCDLFLAGS) -Wno-dll-attribute-on-redeclaration $(ARCH_FLAG)
ldflags  = -L. -pipe -s -fstack-protector-strong -lpthread -Wl,--no-as-needed
dldflags = -pipe -s -fstack-protector-strong -lpthread -Wl,--enable-auto-image-base,--enable-auto-import $(DEFFILE)
ARCH_FLAG = 
DLDFLAGS = $(ldflags) $(dldflags) $(ARCH_FLAG)
LDSHARED = $(CC) -shared
LDSHAREDXX = $(CXX) -shared
POSTLINK = :
AR = gcc-ar
LD = ld
EXEEXT = .exe

RUBY_INSTALL_NAME = $(RUBY_BASE_NAME)
RUBY_SO_NAME = x64-ucrt-ruby340
RUBYW_INSTALL_NAME = $(RUBYW_BASE_NAME)
RUBY_VERSION_NAME = $(RUBY_BASE_NAME)-$(ruby_version)
RUBYW_BASE_NAME = rubyw
RUBY_BASE_NAME = ruby

arch = x64-mingw-ucrt
sitearch = x64-ucrt
ruby_version = 3.4.0
ruby = $(bindir)/$(RUBY_BASE_NAME)
RUBY = $(ruby)
BUILTRUBY = $(bindir)/$(RUBY_BASE_NAME).exe
ruby_headers = $(hdrdir)/ruby.h $(hdrdir)/ruby/backward.h $(hdrdir)/ruby/ruby.h $(hdrdir)/ruby/defines.h $(hdrdir)/ruby/missing.h $(hdrdir)/ruby/intern.h $(hdrdir)/ruby/st.h $(hdrdir)/ruby/subst.h $(arch_hdrdir)/ruby/config.h $(RUBY_EXTCONF_H)

RM = rm -f
RM_RF = rm -fr
RMDIRS = rmdir --ignore-fail-on-non-empty -p
MAKEDIRS = /usr/bin/mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp
TOUCH = exit >

#### End of system configuration section. ####

preload = 
libpath = . $(libdir)
LIBPATH = -L. -L$(libdir)
DEFFILE = $(TARGET)-$(arch).def

CLEANFILES = mkmf.log $(DEFFILE)
DISTCLEANFILES = 
DISTCLEANDIRS = 

extout = 
extout_prefix = 
target_prefix = 
LOCAL_LIBS = 
LIBS = $(LIBRUBYARG_SHARED) "C:/Ora64/product/12.2.0/client_1/oci/lib/MSVC/OCI.LIB" -lshell32 -lws2_32 -liphlpapi -limagehlp -lshlwapi -lbcrypt  
ORIG_SRCS = apiwrap.c attr.c bind.c connection_pool.c encoding.c env.c error.c hook_funcs.c lob.c metadata.c object.c oci8.c oci8lib.c ocidatetime.c ocihandle.c ocinumber.c oradate.c oranumber_util.c plthook_elf.c plthook_osx.c plthook_win32.c stmt.c thread_util.c util.c win32.c
SRCS = $(ORIG_SRCS) oci8lib.c env.c error.c oci8.c ocihandle.c connection_pool.c stmt.c bind.c metadata.c attr.c lob.c oradate.c ocinumber.c ocidatetime.c object.c apiwrap.c encoding.c oranumber_util.c thread_util.c util.c win32.c plthook_win32.c hook_funcs.c
OBJS = oci8lib.o env.o error.o oci8.o ocihandle.o connection_pool.o stmt.o bind.o metadata.o attr.o lob.o oradate.o ocinumber.o ocidatetime.o object.o apiwrap.o encoding.o oranumber_util.o thread_util.o util.o win32.o plthook_win32.o hook_funcs.o
HDRS = $(srcdir)/apiwrap.h $(srcdir)/extconf.h $(srcdir)/oci8.h $(srcdir)/oranumber_util.h $(srcdir)/plthook.h $(srcdir)/thread_util.h
LOCAL_HDRS = 
TARGET = oci8lib_340
TARGET_NAME = oci8lib_340
TARGET_ENTRY = Init_$(TARGET_NAME)
DLLIB = $(TARGET).so
EXTSTATIC = 
STATIC_LIB = 

TIMESTAMP_DIR = .
BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR    = $(sitelibdir)$(target_prefix)
RUBYARCHDIR   = $(sitearchdir)$(target_prefix)
HDRDIR        = $(sitehdrdir)$(target_prefix)
ARCHHDRDIR    = $(sitearchhdrdir)$(target_prefix)
TARGET_SO_DIR =
TARGET_SO     = $(TARGET_SO_DIR)$(DLLIB)
CLEANLIBS     = $(TARGET_SO) false
CLEANOBJS     = $(OBJS) *.bak
TARGET_SO_DIR_TIMESTAMP = $(TIMESTAMP_DIR)/.sitearchdir.time

all:    $(DLLIB)
static: $(STATIC_LIB)
.PHONY: all install static install-so install-rb
.PHONY: clean clean-so clean-static clean-rb

clean-static::
clean-rb-default::
clean-rb::
clean-so::
clean: clean-so clean-static clean-rb-default clean-rb
		-$(Q)$(RM_RF) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES) .*.time

distclean-rb-default::
distclean-rb::
distclean-so::
distclean-static::
distclean: clean distclean-so distclean-static distclean-rb-default distclean-rb
		-$(Q)$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		-$(Q)$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)
		-$(Q)$(RMDIRS) $(DISTCLEANDIRS) 2> NUL || true

realclean: distclean
install: install-so install-rb

install-so: $(DLLIB) $(TARGET_SO_DIR_TIMESTAMP)
	$(INSTALL_PROG) $(DLLIB) $(RUBYARCHDIR)
clean-static::
	-$(Q)$(RM) $(STATIC_LIB)
install-rb: pre-install-rb do-install-rb install-rb-default
install-rb-default: pre-install-rb-default do-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
do-install-rb:
do-install-rb-default:
pre-install-rb-default:
	@$(NULLCMD)
$(TARGET_SO_DIR_TIMESTAMP):
	$(Q) $(MAKEDIRS) $(@D) $(RUBYARCHDIR)
	$(Q) $(TOUCH) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .mm .cxx .cpp .o .S

.cc.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cc.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.mm.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.mm.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.cxx.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cxx.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.cpp.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cpp.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.c.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.c.S:
	$(ECHO) translating $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.m.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.m.S:
	$(ECHO) translating $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

$(TARGET_SO): $(DEFFILE) $(OBJS) Makefile
	$(ECHO) linking shared-object $(DLLIB)
	-$(Q)$(RM) $(@)
	$(Q) $(LDSHARED) -o $@ $(OBJS) $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)
	$(Q) $(POSTLINK)



$(DEFFILE): 
	$(ECHO) generating $(@)
	$(Q) (echo EXPORTS && echo $(TARGET_ENTRY)) > $@

###
$(OBJS): $(hdrdir)/ruby/win32.h

$(OBJS): $(RUBY_EXTCONF_H)

Makefile: $(srcdir)/extconf.rb $(srcdir)/oraconf.rb
	$(RUBY) $(srcdir)/extconf.rb
oci8lib.o: $(srcdir)/oci8lib.c $(srcdir)/oci8.h apiwrap.h Makefile
env.o: $(srcdir)/env.c $(srcdir)/oci8.h apiwrap.h Makefile
error.o: $(srcdir)/error.c $(srcdir)/oci8.h apiwrap.h Makefile
oci8.o: $(srcdir)/oci8.c $(srcdir)/oci8.h apiwrap.h Makefile
ocihandle.o: $(srcdir)/ocihandle.c $(srcdir)/oci8.h apiwrap.h Makefile
connection_pool.o: $(srcdir)/connection_pool.c $(srcdir)/oci8.h apiwrap.h Makefile
stmt.o: $(srcdir)/stmt.c $(srcdir)/oci8.h apiwrap.h Makefile
bind.o: $(srcdir)/bind.c $(srcdir)/oci8.h apiwrap.h Makefile
metadata.o: $(srcdir)/metadata.c $(srcdir)/oci8.h apiwrap.h Makefile
attr.o: $(srcdir)/attr.c $(srcdir)/oci8.h apiwrap.h Makefile
lob.o: $(srcdir)/lob.c $(srcdir)/oci8.h apiwrap.h Makefile
oradate.o: $(srcdir)/oradate.c $(srcdir)/oci8.h apiwrap.h Makefile
ocinumber.o: $(srcdir)/ocinumber.c $(srcdir)/oci8.h apiwrap.h Makefile
ocidatetime.o: $(srcdir)/ocidatetime.c $(srcdir)/oci8.h apiwrap.h Makefile
object.o: $(srcdir)/object.c $(srcdir)/oci8.h apiwrap.h Makefile
apiwrap.o: $(srcdir)/apiwrap.c $(srcdir)/oci8.h apiwrap.h Makefile
encoding.o: $(srcdir)/encoding.c $(srcdir)/oci8.h apiwrap.h Makefile
oranumber_util.o: $(srcdir)/oranumber_util.c $(srcdir)/oci8.h apiwrap.h Makefile
thread_util.o: $(srcdir)/thread_util.c $(srcdir)/oci8.h apiwrap.h Makefile
util.o: $(srcdir)/util.c $(srcdir)/oci8.h apiwrap.h Makefile
win32.o: $(srcdir)/win32.c $(srcdir)/oci8.h apiwrap.h Makefile
plthook_win32.o: $(srcdir)/plthook_win32.c $(srcdir)/oci8.h apiwrap.h Makefile
hook_funcs.o: $(srcdir)/hook_funcs.c $(srcdir)/oci8.h apiwrap.h Makefile
apiwrap.c apiwrap.h: $(srcdir)/apiwrap.c.tmpl $(srcdir)/apiwrap.h.tmpl $(srcdir)/apiwrap.yml $(srcdir)/apiwrap.rb
	$(RUBY) $(srcdir)/apiwrap.rb
