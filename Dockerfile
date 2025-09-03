# syntax=docker/dockerfile:1

# keeping PG_MAJOR for backward compatibility
ARG PG_MAJOR=17
ARG PG_VERSION=${PG_MAJOR}
ARG DEBIAN_CODENAME=bookworm
FROM postgres:$PG_VERSION-$DEBIAN_CODENAME
ARG PG_MAJOR=17
ARG PG_VERSION=${PG_MAJOR}

ADD https://github.com/pgvector/pgvector.git#v0.8.0 /tmp/pgvector

RUN EXTRACTED_PG_MAJOR=$(echo $PG_VERSION | cut -d. -f1) \
		apt-get update && \
		apt-mark hold locales && \
		apt-get install -y --no-install-recommends build-essential postgresql-server-dev-$EXTRACTED_PG_MAJOR && \
		cd /tmp/pgvector && \
		make clean && \
		make OPTFLAGS="" && \
		make install && \
		mkdir /usr/share/doc/pgvector && \
		cp LICENSE README.md /usr/share/doc/pgvector && \
		rm -r /tmp/pgvector && \
		apt-get remove -y build-essential postgresql-server-dev-$EXTRACTED_PG_MAJOR && \
		apt-get autoremove -y && \
		apt-mark unhold locales && \
		rm -rf /var/lib/apt/lists/*
