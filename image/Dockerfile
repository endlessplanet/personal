FROM docker:17.09.0-ce
COPY root /opt/docker/
RUN ["sh", "/opt/docker/run.sh"]
USER user
WORKDIR /home/user
ENTRYPOINT ["bash", "/opt/docker/entrypoint.sh"]
CMD []
HEALTCHECK --interval=10s --timeout=1s --start-period=60s --retries=12 CMD sh /opt/docker/healthcheck.sh