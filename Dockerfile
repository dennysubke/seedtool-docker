# Use the official Node.js runtime as the base image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (if available) first
# This allows Docker to cache the npm install step if dependencies haven't changed
COPY package*.json ./

# Copy all lib package.json files to enable proper dependency resolution
COPY libs/bip32/package.json ./libs/bip32/
COPY libs/bip39/package.json ./libs/bip39/
COPY libs/bip47/package.json ./libs/bip47/
COPY libs/bip85/package.json ./libs/bip85/
COPY libs/bip86/package.json ./libs/bip86/
COPY libs/bitcoinjs-lib/package.json ./libs/bitcoinjs-lib/
COPY libs/bs58check/package.json ./libs/bs58check/
COPY libs/buffer/package.json ./libs/buffer/

# Install all dependencies (including dev dependencies as they may be needed for runtime)
RUN npm install

# Copy the rest of the application code
COPY . .

# Create a non-root user to run the application
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001 -G nodejs

# Change ownership of the app directory to the nodejs user
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose the port the app runs on (adjust if your app uses a different port)
EXPOSE 3000

# Define environment variables
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

# Command to run the application
# Using nodemon.json suggests development setup, but for production we'll use node directly
# If you need nodemon in production, change this to: CMD ["npx", "nodemon", "src/server.js"]
CMD ["node", "src/server.js"]
