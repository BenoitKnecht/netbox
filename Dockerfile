FROM python:3.7-alpine3.9

COPY . /opt/netbox

# graphviz          → runtime graphviz
# postgresql-dev    → build psycopg2-binary
# zlib-dev          → build Pillow
# jpeg-dev          → build Pillow

# Runtime dependencies
RUN apk --no-cache add \
      ca-certificates \
      graphviz \
      libjpeg-turbo \
      libffi \
      postgresql-libs \
      xmlsec \
      zlib

RUN apk --no-cache add --virtual .build-deps \
      build-base \
      libjpeg-turbo-dev \
      libffi-dev \
      postgresql-dev \
      zlib-dev && \
    pip install gunicorn && \
    pip install -r /opt/netbox/requirements.txt && \
    rm -rf /root/.cache && \
    apk --no-cache del .build-deps

RUN addgroup -g31213 unicorn && \
    adduser  -u31213 -h/opt/netbox/netbox -s/sbin/nologin -Gunicorn -DH unicorn

USER unicorn:unicorn

WORKDIR /opt/netbox/netbox

EXPOSE 8000

ENTRYPOINT ["gunicorn", "--bind=0.0.0.0:8000"]
CMD        ["netbox.wsgi"]
