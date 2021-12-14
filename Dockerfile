FROM jsdecena/php8-fpm:0.13

ENV DEBIAN_FRONTEND=noninteractive

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash

RUN apt update && apt -y install wget lsb-release apt-transport-https ca-certificates && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# For Laravel Dusk, install chrome plugin
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

RUN apt install -y \
    ./google-chrome-stable_current_amd64.deb \
    wkhtmltopdf \
    pdftk \
    network-manager \
    libnss3-tools \
    jq \
    xsel \
    supervisor \
    sqlite3 \
    gnome-tweak-tool \
    openjdk-11-jdk \
    openjdk-11-jre \
    libmagickwand-dev \
    libsqlite3-dev \
    libsqlite3-0  \
    nodejs \
    mariadb-client \
    python2.7 && \
    ln -s /usr/bin/python2.7 /usr/local/bin/python && \
    ln -s /usr/bin/nodejs /usr/local/bin/node

# Install image magic
RUN pecl install imagick

RUN docker-php-ext-configure gd --with-jpeg && \
    docker-php-ext-install -j$(nproc) intl simplexml soap pdo pdo_mysql pdo_pgsql zip mbstring exif pcntl gd bcmath sockets opcache

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy supervisor config inside the container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Enable opcache
COPY php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Set custom config
COPY php/local.ini /usr/local/etc/php/conf.d/local.ini

EXPOSE 9000

CMD ["/usr/bin/supervisord"]
