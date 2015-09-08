FROM ruby:2.2.2
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y -q \
        build-essential \
        ca-certificates \
        curl            \
        git             \
        libpq-dev       \
        zlib1g-dev      \
        openssh-server  \
        python          \
        nodejs          \
        nginx           \
        sudo            \
        vim             \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd
# -p `mkpasswd -m sha-512 app`
RUN useradd -m -u 1000 -s /bin/bash -c '' -p '$6$W6YwMy6lhzN1az$pHKg1l7Nu2oxXZ3wgcnkjlQVwXcnlH93lz1YO10jEIXPkuSK6eQzhLWa40Zt3K8ZRqYiiFhyJk/mTGpQfvwbA0' app \
    && adduser app sudo \
    && echo '%sudo ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && cp /root/.bashrc /home/app
ADD dummy_id_rsa.pub /home/app/.ssh/authorized_keys
ADD profile /home/app/.profile
RUN chown -R app: /home/app \
    && chmod 750 /home/app
ADD gear-admin /etc/nginx/conf.d/gear-admin.conf
ADD admin-app /home/app/admin-app
ADD widget-app /home/app/widget-app
ADD straight-server /home/app/straight-server
EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
