# ============================
# 1. Build
# ============================
FROM elixir:1.19.4-otp-28-alpine AS build

RUN apk add --no-cache build-base git

ENV MIX_ENV=prod
WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod
RUN mix deps.compile

COPY . .
RUN mix release


# ============================
# 2. Runtime  (same base!)
# ============================
FROM elixir:1.19.4-otp-28-alpine AS runtime

RUN apk add --no-cache openssl ncurses-libs libstdc++

WORKDIR /app
ENV HOME=/app
ENV MIX_ENV=prod

COPY --from=build /app/priv priv
COPY --from=build /app/_build/prod/rel/* ./release

EXPOSE 4000

CMD ["./release/bin/hello_phoenix", "start"]