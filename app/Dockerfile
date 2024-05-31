FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    ca-certificates

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:$PATH"

RUN rustc --version && cargo --version

WORKDIR app

COPY app .

RUN cargo build --release

EXPOSE 8080

CMD ["./target/release/app"]