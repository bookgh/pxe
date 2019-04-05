FROM alpine:3.9

LABEL maintainer "544025211@qq.com"

# Install the necessary packages
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \ 
  apk add --update \
  dnsmasq \
  wget \
  nginx \
  && rm -rf /var/cache/apk/*

# Config Nginx
RUN sed -i 's#return 404;#root /var/lib/tftpboot;#' /etc/nginx/conf.d/default.conf \
  && sed -i '6a\\tautoindex on;' /etc/nginx/conf.d/default.conf \
  && sed -i '7a\\tautoindex_localtime on;' /etc/nginx/conf.d/default.conf \
  && sed -i '8a\\tautoindex_exact_size off;' /etc/nginx/conf.d/default.conf \
  && mkdir /run/nginx

# Config syslinux
ENV SYSLINUX_VERSION 6.03
ENV TEMP_SYSLINUX_PATH /tmp/syslinux-"$SYSLINUX_VERSION"
WORKDIR /tmp
RUN \
  mkdir -p "$TEMP_SYSLINUX_PATH" \
  && wget -SL https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-"$SYSLINUX_VERSION".tar.gz \
  && tar -xzf syslinux-"$SYSLINUX_VERSION".tar.gz \
  && mkdir -p /var/lib/tftpboot \
  && cp "$TEMP_SYSLINUX_PATH"/bios/core/pxelinux.0 /var/lib/tftpboot/ \
  && cp "$TEMP_SYSLINUX_PATH"/bios/com32/libutil/libutil.c32 /var/lib/tftpboot/ \
  && cp "$TEMP_SYSLINUX_PATH"/bios/com32/elflink/ldlinux/ldlinux.c32 /var/lib/tftpboot/ \
  && cp "$TEMP_SYSLINUX_PATH"/bios/com32/menu/menu.c32 /var/lib/tftpboot/ \
  && rm -rf "$TEMP_SYSLINUX_PATH" \
  && rm /tmp/syslinux-"$SYSLINUX_VERSION".tar.gz

# Configure PXE and TFTP
COPY tftpboot/ /var/lib/tftpboot

# Configure DNSMASQ
COPY etc/ /etc

# entrypoint
COPY entrypoint.sh /entrypoint.sh

# add images
COPY add-image /usr/bin/add-image

ENTRYPOINT ["/entrypoint.sh"]
CMD ["dnsmasq", "--no-daemon"]
