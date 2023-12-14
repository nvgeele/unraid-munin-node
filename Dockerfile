FROM ubuntu:jammy

ENV TZ="Europe/Brussels" \
    ALLOWED_HOSTS="127.0.0.1/32" \
    HOSTNAME="unRAID"

RUN apt-get update && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y munin-node lm-sensors tzdata && \
    apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
	sed -ri 's/^log_file.*/# \0/; \
			s/^pid_file.*/# \0/; \
			s/^background 1$/background 0/; \
			s/^setsid 1$/setsid 0/; \
			' /etc/munin/munin-node.conf && \
	/bin/echo -e "cidr_allow ${ALLOWED_HOSTS}" >> /etc/munin/munin-node.conf && \
	ln -s /usr/share/munin/plugins/sensors_   /etc/munin/plugins/sensors_temp && \
	ln -s /usr/share/munin/plugins/sensors_   /etc/munin/plugins/sensors_fan && \
	ln -s /usr/share/munin/plugins/sensors_   /etc/munin/plugins/sensors_volt && \
	mkdir /var/run/munin  && \
	chown munin:munin /var/run/munin

ADD start.sh /
RUN chmod +x /start.sh

EXPOSE 4949

CMD ["/start.sh"]