FROM node:18

WORKDIR /app

COPY package.json ./

# Install all dependencies, including redis
RUN npm install

COPY . .

EXPOSE 5000

CMD ["npm", "start"]

