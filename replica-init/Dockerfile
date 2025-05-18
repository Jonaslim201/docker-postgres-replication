FROM postgres:16
COPY setup-replica.sh /setup-replica.sh
RUN chmod +x /setup-replica.sh
ENTRYPOINT ["/setup-replica.sh"]
