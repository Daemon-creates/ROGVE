FROM tgstation/byond:513.1490 as base

FROM base as build_base

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    ca-certificates

FROM build_base as rust_g

WORKDIR /rust_g

RUN apt-get install -y --no-install-recommends \
    libssl-dev \
    pkg-config \
    curl \
    gcc-multilib \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-host i686-unknown-linux-gnu \
    && git init \
    && git remote add origin https://github.com/tgstation/rust-g

COPY dependencies.sh .

RUN /bin/bash -c "source dependencies.sh \
    && git fetch --depth 1 origin \$RUST_G_VERSION" \
    && git checkout FETCH_HEAD \
    && ~/.cargo/bin/cargo build --release

FROM build_base as bsql

WORKDIR /bsql

RUN apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    cmake \
    make \
    g++-7 \
    libmariadb-client-lgpl-dev \
    && git init \
    && git remote add origin https://github.com/tgstation/BSQL 

COPY dependencies.sh .

RUN /bin/bash -c "source dependencies.sh \
    && git fetch --depth 1 origin \$BSQL_VERSION" \
    && git checkout FETCH_HEAD

WORKDIR /bsql/artifacts

ENV CC=gcc-7 CXX=g++-7

RUN ln -s /usr/include/mariadb /usr/include/mysql \
    && ln -s /usr/lib/i386-linux-gnu /root/MariaDB \
    && cmake .. \
    && make

FROM base as dm_base

WORKDIR /tgstation

FROM dm_base as build

COPY . .

RUN DreamMaker -max_errors 0 roguetown.dme && tools/deploy.sh /deploy

FROM dm_base

EXPOSE 1337

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
    libmariadb2 \
    mariadb-client \
    libssl1.0.0 \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.byond/bin

COPY --from=rust_g /rust_g/target/release/librust_g.so /root/.byond/bin/rust_g
COPY --from=bsql /bsql/artifacts/src/BSQL/libBSQL.so ./
COPY --from=build /deploy ./

# bsql fexists memes
RUN ln -s /tgstation/libBSQL.so /root/.byond/bin/libBSQL.so

# Goldman runtime sync scripts
COPY fetch_goldman_files.sh /fetch_goldman_files.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /fetch_goldman_files.sh /docker-entrypoint.sh

VOLUME [ "/tgstation/config", "/tgstation/data" ]

# Optional: mount a .env file (copy .env.example to .env and fill it in) to
# /tgstation/.env so docker-entrypoint.sh can load GOLDMAN_API_URL /
# GOLDMAN_API_KEY from it instead of (or in addition to) container env vars,
# e.g. `docker run -v $(pwd)/.env:/tgstation/.env:ro ...`.

# docker-entrypoint.sh already builds the full DreamDaemon command (binary,
# port, and flags); CMD is only for any *additional* args, so it must not
# duplicate that command or DreamDaemon will receive it twice.
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD []
