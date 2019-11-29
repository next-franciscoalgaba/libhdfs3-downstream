FROM franalg/arrow:latest

# Set versions
ARG ARROW_VERSION=0.15.0

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib

ADD ./libhdfs3 /libhdfs3

RUN pip --no-cache-dir install pyarrow==${ARROW_VERSION}

RUN cd /usr/src/ \
    && mkdir openssl \
    && git clone https://github.com/openssl/openssl.git \
    && cd openssl \
    && git checkout OpenSSL_0_9_7-stable \
    && ./config --prefix=/usr/local --openssldir=/usr/local/openssl \
    && make -j$(nproc) \
    && make install \
    && make clean \
    && rm -rf /usr/src/openssl \
    && ldconfig

RUN cd /tmp/ \
    && git clone https://github.com/bdrosen96/libgsasl.git \
    && cd /tmp/libgsasl/lib \
    && ./configure --with-gssapi-impl=mit \
    && make -j$(nproc) \
    && make install \
    && rm -rf /tmp/libgsasl \
    && ldconfig

RUN cd /usr/src/ \
    && mkdir openssl \
    && git clone https://github.com/openssl/openssl.git \
    && cd openssl \
    && ./config --prefix=/usr/local --openssldir=/usr/local/openssl \
    && make -j$(nproc) \
    && make install \
    && make clean \
    && rm -rf /usr/src/openssl \
    && ldconfig

RUN cd /libhdfs3 && \
    sed -i 's/libgsasl7-dev//g' debian/build.sh && \
    ./debian/build.sh install_depends && \
    mkdir build && \
    cd  build && \
    ../bootstrap --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    make clean