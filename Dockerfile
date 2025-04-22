# Etapa de build (imagem maior)
FROM ruby:3.2.2 AS build

# Instala dependências necessárias
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    git \
    libvips-dev \
    postgresql-client \
    build-essential \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Define diretório de trabalho
WORKDIR /rails

# Copia arquivos de Gemfile e instala as gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Copia o restante da aplicação
COPY . .

# Etapa final (imagem menor e segura)
FROM ruby:3.2.2-slim AS base

# Instala somente pacotes necessários para produção
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libvips \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copia gems e aplicação da etapa anterior
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Cria usuário não-root
RUN useradd -m -s /bin/bash rails && \
    mkdir -p /rails/tmp /rails/log /rails/storage /rails/db && \
    chown -R rails:rails /rails

# Define diretório de trabalho e troca para o usuário
WORKDIR /rails
USER rails

# Define entrypoint e expõe a porta padrão
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000

# Comando padrão do container
CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails s -b 0.0.0.0"]
