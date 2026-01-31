# --- STAGE 1: Build ---
FROM node:22-alpine AS builder

WORKDIR /app

# 1. Install dependencies first (for better caching)
COPY package*.json ./
RUN npm install

# 2. Copy your source code (the 'src' folder and everything else)
COPY . .

# 3. Create the production build
RUN npm run build

# --- STAGE 2: Serve ---
FROM node:22-alpine

WORKDIR /app

# Install the server tool
RUN npm install -g serve

# 4. Copy the compiled files from the builder stage
# VITE USERS: use /app/dist
# CRA USERS: use /app/build
COPY --from=builder /app/build ./build

EXPOSE 3000

# Start serving the 'dist' folder
CMD ["serve", "-s", "build", "-l", "3000"]
