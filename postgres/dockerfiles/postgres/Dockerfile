FROM docker.io/postgres:9.6

CMD bash -c ' \
	set -x ; \
	export POSTGRES_PASSWORD="$(cat /etc/polykube/postgres-auth/password | head -n 1)"; \
	/docker-entrypoint.sh postgres'

# where does this put it's storage? need to mount a private volume there first
