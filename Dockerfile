FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
COPY libs/bip32/package.json ./libs/bip32/
COPY libs/bip39/package.json ./libs/bip39/
COPY libs/bip47/package.json ./libs/bip47/
COPY libs/bip85/package.json ./libs/bip85/
COPY libs/bip86/package.json ./libs/bip86/
COPY libs/bitcoinjs-lib/package.json ./libs/bitcoinjs-lib/
COPY libs/bs58check/package.json ./libs/bs58check/
COPY libs/buffer/package.json ./libs/buffer/
RUN npm ci --only=production
COPY . .
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001 -G nodejs
RUN chown -R nextjs:nodejs /app
USER nextjs
EXPOSE 3000
ENV NODE_ENV=production
CMD ["node", "src/server.js"]
