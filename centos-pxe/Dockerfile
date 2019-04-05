FROM centos:7.6.1810

RUN rpm --import http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7 && \
    rm -f /etc/yum.repos.d/* && \
    curl -so /etc/yum.repos.d/epel-7.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
    curl -so /etc/yum.repos.d/Centos-7.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    sed -i '/aliyuncs.com/d' /etc/yum.repos.d/Centos-7.repo /etc/yum.repos.d/epel-7.repo && \
    yum -y install --setopt=tsflags=nodocs --disableplugin=fastestmirror \
      xinetd tftp-server dhcp httpd && \
    yum clean all && \
    rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/*

RUN rm -f /etc/httpd/conf.d/welcome.conf && \ 
  sed -i '/disable/s/yes/no/'  /etc/xinetd.d/tftp && \
  sed -i 's#/var/www/html#/var/pxe#' /etc/httpd/conf/httpd.conf && \
  sed -i '/AllowOverride/s/None/All/' /etc/httpd/conf/httpd.conf && \
  echo -e '\nServerName  localhost\nServerTokens Prod\nKeepAlive On'  >> /etc/httpd/conf/httpd.conf

ADD tool/menu.c32 /opt/menu.c32
ADD tool/pxelinux.0 /opt/pxelinux.0
ADD conf/init /init
ADD conf/centos.cfg /opt/centos.cfg
ADD conf/add-image /usr/bin/add-image
ADD conf/entrypoint.sh /entrypoint.sh 
ADD conf/dhcpd.conf /etc/dhcp/dhcpd.conf

RUN touch /opt/init && \
  chmod +x /entrypoint.sh /usr/bin/add-image

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "/usr/sbin/httpd", "-DFOREGROUND" ]
