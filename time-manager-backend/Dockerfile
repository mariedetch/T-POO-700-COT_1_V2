FROM elixir:1.15-alpine as builder

# Installer les dépendances nécessaires
RUN apk update && apk add --no-cache build-base git

# Installer Hex et Rebar
RUN mix local.hex --force && mix local.rebar --force

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de configuration et récupérer les dépendances
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copier le reste du code de l'application
COPY . .

# Compiler l'application
RUN MIX_ENV=prod mix compile

# Construire le release
RUN MIX_ENV=prod mix release

# Étape 2 : Créer l'image finale en production
FROM alpine:3.18

# Installer les dépendances pour exécuter l'application
RUN apk add --no-cache \
  libstdc++ \
  openssl \
  ncurses-libs

# Définir le répertoire de travail
WORKDIR /app

# Copier le release depuis le builder
COPY --from=builder /app/_build/prod/rel/time_manager_app ./

# Définir les variables d'environnement
ENV MIX_ENV=prod \
  REPLACE_OS_VARS=true \
  PORT=4000

# Exposer le port de l'application
EXPOSE 4000

CMD ["sh", "bin/time_manager_app", "start"]
