FROM sapk/cloud9:alpine
COPY root /opt/docker/
RUN ["sh", "/opt/docker/run.sh"]
USER user
ENTRYPOINT ["sh", "/opt/docker/entrypoint.sh"]
