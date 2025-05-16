#!/bin/bash

# 设置权限
chown -R ${PUID}:${PGID} /opt/alist/
chown -R ${PUID}:${PGID} /opt/aria2/

# 设置umask
umask ${UMASK}

# 判断是否要运行Aria2
if [ "${RUN_ARIA2}" = "true" ]; then
    echo "Starting Aria2..."
    su-exec ${PUID}:${PGID} aria2c \
        --enable-rpc \
        --rpc-allow-origin-all \
        --conf-path=/opt/aria2/.aria2/aria2.conf \
        --dir=/opt/aria2/downloads \
        --daemon
fi

# 启动Alist
echo "Starting Alist..."
exec su-exec ${PUID}:${PGID} /opt/alist/alist server --no-prefix