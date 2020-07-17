ARG base

FROM $base

# Install Emscripten

RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git /emsdk \
    && cd /emsdk \
    && rm -fr .git \
    && ./emsdk install 1.39.16 \
    && ./emsdk activate 1.39.16

ENV PATH=/emsdk:/emsdk/upstream/emscripten:/emsdk/node/12.18.1_64bit/bin:$PATH \
    EMSDK=/emsdk \
    EM_CONFIG=/emsdk/.emscripten \
    EM_CACHE=/emsdk/upstream/emscripten/cache \
    EMSDK_NODE=/emsdk/node/12.18.1_64bit/bin/node
