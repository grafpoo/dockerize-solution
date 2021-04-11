FROM postgres:13.2
ENV POSTGRES_DB footie
ENV POSTGRES_USER footer
ENV POSTGRES_PASSWORD changeme
EXPOSE 5432

# allow remote connections to PG
#RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf
#RUN echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf
