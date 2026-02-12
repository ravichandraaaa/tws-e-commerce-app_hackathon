# Stage 1: Build Stage
FROM node:18-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy project files
COPY . .

# Build Next.js standalone output
RUN npm run build


# Stage 2: Production Stage
FROM node:18-alpine AS runner

WORKDIR /app

# Copy standalone server and dependencies
COPY --from=builder /app/.next/standalone ./

# Copy static files
COPY --from=builder /app/.next/static ./.next/static

# Copy public folder
COPY --from=builder /app/public ./public

# ✅ IMPORTANT: copy package.json (recommended)
COPY --from=builder /app/package.json ./package.json

# Environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose port
EXPOSE 3000

# Start standalone server
CMD ["node", "server.js"]
