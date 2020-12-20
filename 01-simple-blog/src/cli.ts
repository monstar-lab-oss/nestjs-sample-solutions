import { NestFactory } from '@nestjs/core';
import { Logger } from 'nestjs-pino';
import { ConfigService } from '@nestjs/config';

import { AppModule } from './app.module';

import { AppLogger } from './shared/logger/logger.service';
import { UserService } from './user/services/user.service';
import { ROLE } from './auth/constants/role.constant';
import { CreateUserInput } from './user/dtos/user-create-input.dto';

async function bootstrap() {
  const app = await NestFactory.createApplicationContext(AppModule);

  app.useLogger(new AppLogger(app.get(Logger)));

  const configService = app.get(ConfigService);
  const defaultAdminUserPassword = configService.get<string>(
    'defaultAdminUserPassword',
  );

  const userService = app.get(UserService);

  const defaultAdmin: CreateUserInput = {
    name: 'Default Admin User',
    username: 'default-admin',
    password: defaultAdminUserPassword,
    roles: [ROLE.ADMIN],
    isAccountDisabled: false,
    email: 'default-admin@example.com',
  };

  // Create the default admin user if it doesn't already exist.
  const user = await userService.findByUsername(defaultAdmin.username);
  if (!user) {
    await userService.createUser(defaultAdmin);
  }

  await app.close();
}
bootstrap();
