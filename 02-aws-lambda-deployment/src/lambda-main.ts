import { APIGatewayProxyHandler, Context } from 'aws-lambda'
import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'
import { Server } from 'http'
import { ExpressAdapter } from '@nestjs/platform-express'
import { createServer, proxy } from 'aws-serverless-express'
import { eventContext } from 'aws-serverless-express/middleware'
import * as express from 'express'
import { Logger } from 'nestjs-pino';
import { ValidationPipe } from '@nestjs/common';

import { AppLogger } from './shared/logger/logger.service'
import { RequestIdMiddleware } from './shared/middlewares/request-id/request-id.middleware';

let cachedServer: Server

const bootstrapServer = async (): Promise<Server> => {
  const expressApp = express()
  const adapter = new ExpressAdapter(expressApp)

  const app = await NestFactory.create(AppModule, adapter, {
    logger: false,
  })

  // eventContext from aws-serverless-express library. Needed for Lambda.
  app.use(eventContext())
  
  /** Bootstrap middleware, logger, validators, etc. */
  app.setGlobalPrefix('api/v1');
  app.useLogger(new AppLogger(app.get(Logger)));
  app.useGlobalPipes(new ValidationPipe({ transform: true, whitelist: true }));
  app.use(RequestIdMiddleware);
  app.enableCors();

  await app.init()
  return createServer(expressApp)
}

export const handler: APIGatewayProxyHandler = async (event: any, context: Context) => {
  if (!cachedServer) {
    const server = await bootstrapServer()
    cachedServer = server
    return proxy(server, event, context, 'PROMISE').promise
  } else {
    return proxy(cachedServer, event, context, 'PROMISE').promise
  }
}