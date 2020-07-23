EMSCRIPTEN_BUILD_OPTIONS=HOST_CC=clang TARGET_CC=emcc AR=emar TARGET_EXE=.js
LINUX_BUILD_OPTIONS=HOST_CC=$(CC) TARGET_CC=$(CC)

SIMPLIFIED_MAKEFILE=quickjs.mk

export

all:

install-cmake:
	mkdir -p "$(DESTDIR)/lib/cmake/quickjs"
	install -m644 cmake/quickjs-config.cmake "$(DESTDIR)/lib/cmake/quickjs/quickjs-config.cmake"

emscripten:
	$(MAKE) -f $(SIMPLIFIED_MAKEFILE) $(EMSCRIPTEN_BUILD_OPTIONS)

emscripten-install: emscripten install-cmake
	$(MAKE) -f $(SIMPLIFIED_MAKEFILE) $(EMSCRIPTEN_BUILD_OPTIONS) install

linux:
	$(MAKE) -f $(SIMPLIFIED_MAKEFILE) $(LINUX_BUILD_OPTIONS)

linux-install: linux install-cmake
	$(MAKE) -f $(SIMPLIFIED_MAKEFILE) $(LINUX_BUILD_OPTIONS) install

clean:
	$(MAKE) -f $(SIMPLIFIED_MAKEFILE) $(EMSCRIPTEN_BUILD_OPTIONS) clean
	$(MAKE) -f $(SIMPLIFIED_MAKEFILE) $(LINUX_BUILD_OPTIONS) clean
	rm -f qjs.wasm
