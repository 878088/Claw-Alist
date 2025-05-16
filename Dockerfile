# 使用Alpine Linux作为基础镜像
FROM alpine:3.18

# 设置环境变量
ENV UMASK=022 \
    PUID=1000 \
    PGID=1000 \
    RUN_ARIA2=false

# 安装依赖
RUN apk add --no-cache \
    bash \
    su-exec \
    wget \
    tar \
    aria2

# 创建用户和组
RUN addgroup -g 1000 alist && \
    adduser -D -u 1000 -G alist alist

# 创建工作目录
RUN mkdir -p /opt/alist /opt/aria2/.aria2 && \
    chown -R alist:alist /opt/alist /opt/aria2

# 下载并安装Alist
RUN wget -O /tmp/alist.tar.gz \
    https://github.com/ykxVK8yL5L/alist/releases/download/latest/alist-linux-amd64.tar.gz && \
    tar -zxvf /tmp/alist.tar.gz -C /opt/alist && \
    rm -f /tmp/alist.tar.gz && \
    chmod +x /opt/alist/alist

# 添加启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 设置工作目录
WORKDIR /opt/alist

# 设置数据卷
VOLUME /opt/alist/data /opt/aria2/.aria2

# 设置入口点
ENTRYPOINT ["/entrypoint.sh"]