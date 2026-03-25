# Stage 1: Build whisper.cpp server
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG WHISPER_CPP_VERSION=v1.7.4

RUN git clone --depth 1 --branch ${WHISPER_CPP_VERSION} \
    https://github.com/ggerganov/whisper.cpp.git /whisper.cpp

WORKDIR /whisper.cpp

RUN cmake -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DWHISPER_BUILD_TESTS=OFF \
    -DWHISPER_BUILD_EXAMPLES=ON \
    -DBUILD_SHARED_LIBS=OFF \
    && cmake --build build --target whisper-server -j$(nproc)

# Stage 2: Minimal runtime image
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -r -s /bin/false whisper

COPY --from=builder /whisper.cpp/build/bin/whisper-server /usr/local/bin/whisper-server

RUN mkdir -p /models && chown whisper:whisper /models

USER whisper

EXPOSE 8000

ENTRYPOINT ["whisper-server"]
CMD [ \
    "--model", "/models/ggml-small-q5_1.bin", \
    "--host", "0.0.0.0", \
    "--port", "8000", \
    "--threads", "2", \
    "--language", "pt" \
]
