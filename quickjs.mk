
OBJDIR=.obj

TARGET_CC=clang
HOST_CC=clang

TARGET_AR=ar
HOST_AR=ar

TARGET_EXE=
HOST_EXE=

TARGET_LIBS=-lm -ldl -lpthread
HOST_LIBS=-lm -ldl -lpthread

ADDITIONAL_HOST_CFLAGS=
ADDITIONAL_HOST_LDFLAGS=
ADDITIONAL_TARGET_CFLAGS=
ADDITIONAL_TARGET_LDFLAGS=

CFLAGS_CLANG=-Wall -MMD -MF $(OBJDIR)/$(@F).d
CFLAGS_CLANG+= -Wextra
CFLAGS_CLANG+= -Wno-sign-compare
CFLAGS_CLANG+= -Wno-missing-field-initializers
CFLAGS_CLANG+= -Wundef -Wuninitialized
CFLAGS_CLANG+= -Wunused -Wno-unused-parameter
CFLAGS_CLANG+= -Wwrite-strings
CFLAGS_CLANG+= -Wchar-subscripts -funsigned-char
CFLAGS_CLANG+= -MMD -MF $(OBJDIR)/$(@F).d

LDFLAGS_CLANG=

CFLAGS_GCC=-Wall -MMD -MF $(OBJDIR)/$(@F).d
CFLAGS_GCC+= -Wno-array-bounds -Wno-format-truncation

LDFLAGS_GCC=

DEFINES:=-D_GNU_SOURCE -DCONFIG_VERSION=\"$(shell cat ./quickjs-src/VERSION)\"

ifneq ($(findstring clang,$(TARGET_CC)),)
  TARGET_CFLAGS=$(CFLAGS_CLANG) $(DEFINES)
  TARGET_LDFLAGS=$(LDFLAGS_CLANG)
else ifneq ($(findstring emcc,$(TARGET_CC)),)
  TARGET_CFLAGS=$(CFLAGS_CLANG) $(DEFINES)
  TARGET_LDFLAGS=$(LDFLAGS_CLANG)
else
  TARGET_CFLAGS=$(CFLAGS_GCC) $(DEFINES)
  TARGET_LDFLAGS=$(LDFLAGS_GCC)
endif

TARGET_CFLAGS+= $(ADDITIONAL_TARGET_CFLAGS)
TARGET_LDFLAGS+= $(ADDITIONAL_TARGET_LDFLAGS)

ifneq ($(findstring clang,$(HOST_CC)),)
  HOST_CFLAGS=$(CFLAGS_CLANG) $(DEFINES)
  HOST_LDFLAGS=$(LDFLAGS_CLANG)
else ifneq ($(findstring emcc,$(HOST_CC)),)
  HOST_CFLAGS=$(CFLAGS_CLANG) $(DEFINES)
  HOST_LDFLAGS=$(LDFLAGS_CLANG)
else
  HOST_CFLAGS=$(CFLAGS_GCC) $(DEFINES)
  HOST_LDFLAGS=$(LDFLAGS_GCC)
endif

HOST_CFLAGS+= $(ADDITIONAL_HOST_CFLAGS)
HOST_LDFLAGS+= $(ADDITIONAL_HOST_LDFLAGS)

TARGET_QJS_LIB_OBJS=$(OBJDIR)/quickjs.o $(OBJDIR)/libregexp.o $(OBJDIR)/libunicode.o $(OBJDIR)/cutils.o $(OBJDIR)/quickjs-libc.o
HOST_QJS_LIB_OBJS=$(patsubst %.o, %.host.o, $(TARGET_QJS_LIB_OBJS))

QJSC=qjsc$(HOST_EXE)
QJS=qjs$(TARGET_EXE)
PROGS=$(QJSC) $(QJS)

all: libquickjs.a $(PROGS)

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/%.o: quickjs-src/%.c | $(OBJDIR)
	$(TARGET_CC) $(TARGET_CFLAGS) -c -o $@ $<

$(OBJDIR)/%.host.o: quickjs-src/%.c | $(OBJDIR)
	$(HOST_CC) $(HOST_CFLAGS) -c -o $@ $<

libquickjs.a: $(TARGET_QJS_LIB_OBJS)
	$(TARGET_AR) rcs $@ $^

$(QJSC): $(OBJDIR)/qjsc.host.o $(HOST_QJS_LIB_OBJS)
	$(HOST_CC) $(HOST_LDFLAGS) -o $@ $^ $(HOST_LIBS)

$(OBJDIR)/repl.o: $(QJSC) quickjs-src/repl.js
	./$(QJSC) -c -o $(OBJDIR)/repl.c -m quickjs-src/repl.js
	$(TARGET_CC) $(TARGET_CFLAGS) -c -o $(OBJDIR)/repl.o $(OBJDIR)/repl.c

$(QJS): $(OBJDIR)/repl.o $(OBJDIR)/qjs.o $(TARGET_QJS_LIB_OBJS)
	$(TARGET_CC) $(TARGET_LDFLAGS) -o $@ $^ $(TARGET_LIBS)

clean:
	rm -f *.a $(PROGS)
	rm -rf $(OBJDIR)/

install: all
	mkdir -p "$(DESTDIR)/bin"
	install -m755 qjsc$(HOST_EXE) "$(DESTDIR)/bin"
	mkdir -p "$(DESTDIR)/lib/quickjs"
	install -m644 libquickjs.a "$(DESTDIR)/lib/quickjs"
	mkdir -p "$(DESTDIR)/include/quickjs"
	install -m644 quickjs-src/quickjs.h quickjs-src/quickjs-libc.h "$(DESTDIR)/include/quickjs"
