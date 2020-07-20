EMSCRIPTEN_BUILD_DIR=build_emscripten
EMSCRIPTEN_BUILD_OPTIONS=CONFIG_CLANG=y CROSS_PREFIX=placeholder-cross-prefix- HOST_CC=clang CC=emcc QJSC_CC=emcc AR=emar STRIP=true EXE=.js

LINUX_BUILD_DIR=build_linux
LINUX_BUILD_OPTIONS=

export

all:

$(EMSCRIPTEN_BUILD_DIR): quickjs-src
	rm -fr "$(EMSCRIPTEN_BUILD_DIR)"
	cp -r quickjs-src "$(EMSCRIPTEN_BUILD_DIR)"

emscripten: $(EMSCRIPTEN_BUILD_DIR)
	$(MAKE) -C $(EMSCRIPTEN_BUILD_DIR) $(EMSCRIPTEN_BUILD_OPTIONS)

emscripten-install: emscripten
	$(MAKE) -C $(EMSCRIPTEN_BUILD_DIR) $(EMSCRIPTEN_BUILD_OPTIONS) install
	mkdir -p "$(DESTDIR)/lib/cmake/quickjs"
	install -m644 cmake/quickjs-config.cmake "$(DESTDIR)/lib/cmake/quickjs/quickjs-config.cmake"

$(LINUX_BUILD_DIR): quickjs-src
	rm -fr "$(LINUX_BUILD_DIR)"
	cp -r quickjs-src "$(LINUX_BUILD_DIR)"

linux: $(LINUX_BUILD_DIR)
	$(MAKE) -C $(LINUX_BUILD_DIR) $(LINUX_BUILD_OPTIONS)

linux-install: linux
	$(MAKE) -C $(LINUX_BUILD_DIR) $(LINUX_BUILD_OPTIONS) install
	mkdir -p "$(DESTDIR)/lib/quickjs/cmake"
	install -m644 cmake/quickjs-config.cmake "$(DESTDIR)/lib/quickjs/cmake/quickjs-config.cmake"
