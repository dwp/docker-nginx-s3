# Builds a Docker image using nginx with config from S3

FROM nginx:1.19.1-alpine

# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN apk update
RUN apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

RUN pip install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org awscli

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 0755 /sbin/entrypoint.sh

ENTRYPOINT ["sh", "-c", "/sbin/entrypoint.sh && /docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]