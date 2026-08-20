# 构建阶段：使用 Node 镜像编译项目
FROM node:18-alpine AS builder

WORKDIR /app

# 复制依赖文件并安装
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# 复制源码并构建
COPY . .
RUN yarn build

# 运行阶段：使用 Nginx 托管构建产物
FROM nginx:alpine

# 复制构建产物到 Nginx 默认目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 可选：复制自定义 Nginx 配置（如有需要）
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
