# ── Stage 1: Build ─────────────────────────────────────────
FROM node:16-alpine AS builder

WORKDIR /app

# Accept build argument for API URL
ARG REACT_APP_BASEURL
ENV REACT_APP_BASEURL=$REACT_APP_BASEURL

# Install dependencies first (better layer caching)
COPY package*.json ./
RUN npm install

# Copy source and build
COPY . .
RUN npm run build

# ── Stage 2: Production (lightweight nginx) ────────────────
FROM nginx:alpine AS production

# Copy built files from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]