FROM rasa/rasa:3.6.21

COPY app /app
COPY server.sh /app/server.sh

USER root
RUN chmod +x /app/server.sh && \
    chmod -R 755 /app && \
    chown -R 1001:0 /app
USER 1001

WORKDIR /app

EXPOSE 8080
ENTRYPOINT ["/app/server.sh"]