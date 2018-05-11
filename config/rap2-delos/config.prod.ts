import { IConfigOptions } from "../types";

let config: IConfigOptions =  {
  version: '2.3',
  serve: {
    port: 8080,
  },
  keys: [
    'gf',
    'code.sayhub.cn',
    'lanmingle@qq.com',
    'easy-end'
  ],
  session: {
    key: 'rap2:sess',
  },
  db: {
    dialect: 'mysql',
    host: 'localhost',
    port: 3306,
    username: 'root',
    password: '123456',
    database: 'rap2',
    pool: {
      max: 80,
      min: 0,
      idle: 20000,
      acquire: 20000,
    },
    logging: false
  },
  redis: {
    host: 'localhost',
    port: 6379
  }
}

export default config
