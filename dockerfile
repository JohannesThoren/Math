FROM ubuntu:latest AS cloner
RUN apt-get update && apt-get upgrade -y && apt-get install git -y
WORKDIR /repos
RUN git clone https://github.com/romptroll/graph.git graph/
RUN git clone https://github.com/JohannesThoren/math-api-backend.git backend/

FROM rust:latest AS graph-builder
WORKDIR /usr/src/app
COPY --from=cloner /repos/graph/ .
RUN cargo install --path .

FROM node:latest
WORKDIR /app
COPY --from=cloner /repos/backend .
COPY --from=graph-builder /usr/local/cargo/bin/graph binaries/
RUN npm install
EXPOSE 3000
CMD ["npm","run","serve"]