
FROM redash/redash:9.0.0-beta.b42121

USER root

COPY . /app
RUN chown -R redash /app
USER redash