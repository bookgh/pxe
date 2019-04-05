### 使用方法

#### 启动容器

> docker run 方式

    docker run -d --name pxe \
      -e IP=192.168.0.71 \
      -e DHCP_RANGE='192.168.0.100 192.168.0.200' \
      -v /pxe/image:/var/pxe \
      -v /pxe/tftpboot:/var/lib/tftpboot \
      --restart=always \
      --net=host \
      bookgh/pxe:centos

> docker-compose 方式

创建 docker-compose.yml

    cat > docker-compose.yml <<EOF
    version: '3'
    services:
      pxe:
        network_mode: host
        image: bookgh/pxe:centos
        container_name: pxe
        hostname: pxe.pxe.local
        restart: always
        environment:
          IP: 192.168.0.71
          DHCP_RANGE: '192.168.0.100 192.168.0.200'
        volumes:
          - /pxe/image:/var/pxe
          - /pxe/tftpboot:/var/lib/tftpboot
    EOF

启动容器

    docker-compose up -d

#### 添加镜像

> 挂载镜像

    mount CentOS-7-x86_64-Minimal-1810.iso /mnt

> 复制镜像中的文件到 http 目录

    cp -a /mnt /pxe/image/centos7.6

> 复制启动文件到 ftp 目录

    docker exec -it pxe add-image centos7.6                       # 如果不指定无人值守文件则使用最小化安装模板
    
    docker exec -it pxe add-image centos7.6 centos7.6-ks.cfg      # 在 /pxe/image/ 目录下创建 centos7.6-ks.cfg 无人值守文件
