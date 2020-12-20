import { LoggerService, Injectable, Scope } from '@nestjs/common';
import { Logger } from 'nestjs-pino';

@Injectable({
  scope: Scope.TRANSIENT,
})
export class AppLogger implements LoggerService {
  private context?: string;

  public setContext(context: string): void {
    this.context = context;
  }

  constructor(private logger: Logger) {}

  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  log(message: any, context?: string, ...args: any[]): void {
    return this.logger.log(message, context || this.context, ...args);
  }

  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  error(message: any, trace?: string, context?: string, ...args: any[]): void {
    return this.logger.error(message, trace, context || this.context, ...args);
  }

  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  warn(message: any, context?: string, ...args: any[]): void {
    return this.logger.warn(message, context || this.context, ...args);
  }
  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  debug(message: any, context?: string, ...args: any[]): void {
    return this.logger.debug(message, context || this.context, ...args);
  }

  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  verbose(message: any, context?: string, ...args: any[]): void {
    return this.logger.verbose(message, context || this.context, ...args);
  }
}
