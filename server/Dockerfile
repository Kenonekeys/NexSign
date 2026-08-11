FROM swift:5.7
WORKDIR /app

# Install system deps for vapor
RUN apt-get update && apt-get install -y libssl-dev libsqlite3-dev

COPY . /app
WORKDIR /app
RUN swift build -c release

EXPOSE 8080
CMD [".build/release/Run"]
