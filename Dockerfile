
FROM openresty/openresty
MAINTAINER openresty-test

RUN apt update && apt install -y \
	wget \
	vim \
	git \
	curl \
	redis \
	net-tools \
	supervisor \
	htop \
	screen \
	&& apt clean

RUN mkdir -p /var/log/nginx/

COPY conf/openresty/ /etc/openresty
COPY conf/nginx/ /etc/nginx
COPY www/ /data/www

RUN nohup openresty & redis-server &

EXPOSE 80
VOLUME ["/etc/openresty", "/etc/nginx", "/data/www"]

ENTRYPOINT [ "sh", "-c", "openresty & redis-server" ]
CMD ["/bin/bash"]

