# --- Stage 1: Install dependencies and build ---
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy dependency files first for better caching
COPY package*.json ./
# If using pnpm or yarn, copy lock files accordingly:
# COPY pnpm-lock.yaml ./
# COPY yarn.lock ./

# Install dependencies
RUN npm ci

# Copy all source files
COPY . .

# Build the Next.js app
RUN npm run build

# --- Stage 2: Create a lightweight production image ---
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Create a non-root user
RUN addgroup -S nodejs && adduser -S nextjs -G nodejs

# Copy only necessary files for runtime
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

# Use non-root user for security
USER nextjs

# Expose port (default 3000)
EXPOSE 3000

# Start Next.js
CMD ["npm", "run", "start"]

