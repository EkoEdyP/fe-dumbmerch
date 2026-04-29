# ── Stage 1: Build ─────────────────────────────────────────
FROM node:16-alpine AS builder

WORKDIR /app

# Install dependencies first (better layer caching)
COPY package*.json ./
# RUN npm ci --silent

# Copy source and build
COPY . .
RUN npm run build

# ── Stage 2: Production (lightweight nginx) ────────────────
FROM nginx:alpine AS production

# Copy built files from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]