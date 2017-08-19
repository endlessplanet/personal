FROM panubo/sshd
COPY root /opt/docker/
RUN ["sh", "/opt/docker/run.sh"]
ENTRYPOINT ["sh", "/opt/docker/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]