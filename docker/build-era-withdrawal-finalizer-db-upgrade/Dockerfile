# syntax=docker/dockerfile:1
#
# Build context must be the repo root (migrations live in ./storage/migrations):
#   docker buildx build -f docker/build-era-withdrawal-finalizer-db-upgrade/Dockerfile .
# See build.sh, which does this for you.

# ---------------------------------------------------------------------------
# Builder: compile sqlx-cli (just the `sqlx` binary we need).
# ---------------------------------------------------------------------------
FROM --platform=$TARGETPLATFORM rust:1-bookworm AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends pkg-config libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# When this image is built for linux/amd64 on an ARM host (via buildx + QEMU),
# the compile runs under x86_64 emulation. Recent Rust (>=1.90) defaults to the
# bundled `rust-lld` linker, which segfaults (SIGSEGV) under QEMU. Force the
# classic GNU linker (ld.bfd), which links fine under emulation.
ENV RUSTFLAGS="-C linker-features=-lld"

RUN cargo install sqlx-cli \
    --version 0.8.1 \
    --no-default-features \
    --features postgres,native-tls \
    --locked

# ---------------------------------------------------------------------------
# Runtime: minimal Ubuntu with just the sqlx binary, its TLS deps, and the
# migrations. Runs `sqlx database create` + `sqlx migrate run` on start.
# ---------------------------------------------------------------------------
FROM --platform=$TARGETPLATFORM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates libssl3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/cargo/bin/sqlx /usr/local/bin/sqlx

WORKDIR /app

COPY storage/migrations /app/migrations/

COPY docker/build-era-withdrawal-finalizer-db-upgrade/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
