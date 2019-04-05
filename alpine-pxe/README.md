### 使用方法

#### 启动容器

> docker run 方式

    docker run -d --name pxe \
      -e IP=192.168.0.71 \
      -v /data:/var/lib/tftpboot/image \
      --restart=always \
      --net=host \
      bookgh/pxe:alpine

> docker-compose 方式

创建 docker-compose.yml

    cat > docker-compose.yml <<EOF
    version: '3'
    services:
      pxe:
        network_mode: host
        # image: pxe:1.0
        image: bookgh/pxe:alpine
        container_name: pxe
        hostname: pxe.pxe.local
        restart: always
        environment:
          IP: 192.168.0.71
        volumes:
          - /data:/var/lib/tftpboot/image    
    EOF

启动容器

    docker-compose up -d

#### 添加镜像

> 挂载镜像

    mount CentOS-7-x86_64-Minimal-1810.iso /mnt

> 复制镜像中的文件到 http 目录

    cp -a /mnt /data/centos7.6

> 添加引导菜单

    docker exec -it pxe add-image centos7.6                       # 使用本地源手动安装
    
    docker exec -it pxe add-image centos7.6 centos7.6-ks.cfg      # 在 /data 下创建无人值守文件 centos7.6-ks.cfg 自动安装
