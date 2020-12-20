import * as request from 'supertest';
import { Test } from '@nestjs/testing';
import { AppModule } from './../../src/app.module';
import { HttpStatus, INestApplication, ValidationPipe } from '@nestjs/common';

import {
  closeDBAfterTest,
  createDBEntities,
  resetDBBeforeTest,
} from './../test-utils';
import { RegisterInput } from '../../src/auth/dtos/auth-register-input.dto';
import { RegisterOutput } from '../../src/auth/dtos/auth-register-output.dto';
import { LoginInput } from '../../src/auth/dtos/auth-login-input.dto';
import { RefreshTokenInput } from '../../src/auth/dtos/auth-refresh-token-input.dto';
import { AuthTokenOutput } from '../../src/auth/dtos/auth-token-output.dto';
import { ROLE } from '../../src/auth/constants/role.constant';

describe('AuthController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    await resetDBBeforeTest();
    await createDBEntities();

    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleRef.createNestApplication();
    app.useGlobalPipes(new ValidationPipe());
    await app.init();
  });

  describe('register a new user', () => {
    const registerInput: RegisterInput = {
      name: 'e2etester',
      username: 'e2etester',
      password: '12345678',
      roles: [ROLE.USER],
      isAccountDisabled: false,
      email: 'e2etester@random.com',
    };
    const registerOutput: RegisterOutput = {
      id: 1,
      name: 'e2etester',
      username: 'e2etester',
      roles: [ROLE.USER],
      isAccountDisabled: false,
      email: 'e2etester@random.com',
    };

    it('successfully register a new user', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send(registerInput)
        .expect(HttpStatus.CREATED)
        .expect({ data: registerOutput, meta: {} });
    });

    it('register fails without Input DTO', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .expect(HttpStatus.BAD_REQUEST);
    });

    it('register fails when incorrect username format', () => {
      registerInput.username = 12345 as any;
      return request(app.getHttpServer())
        .post('/auth/register')
        .expect(HttpStatus.BAD_REQUEST)
        .send(registerInput)
        .expect((res) => {
          const resp = res.body;
          expect(resp.error.details.message).toContain(
            'username must be a string',
          );
        });
    });
  });

  describe('login the registered user', () => {
    const loginInput: LoginInput = {
      username: 'e2etester',
      password: '12345678',
    };

    it('should successfully login the user', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send(loginInput)
        .expect(HttpStatus.OK)
        .expect((res) => {
          const token = res.body.data;
          expect(token).toHaveProperty('accessToken');
          expect(token).toHaveProperty('refreshToken');
        });
    });

    it('should failed to login with wrong credential', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({ ...loginInput, password: 'wrong-passs' })
        .expect(HttpStatus.UNAUTHORIZED);
    });
  });

  describe('refreshing jwt token', () => {
    const loginInput: LoginInput = {
      username: 'e2etester',
      password: '12345678',
    };

    it('should successfully get new auth token using refresh token', async () => {
      const loginResponse = await request(app.getHttpServer())
        .post('/auth/login')
        .send(loginInput);

      const token: AuthTokenOutput = loginResponse.body.data;
      const refreshTokenInput: RefreshTokenInput = {
        refreshToken: token.refreshToken,
      };

      return request(app.getHttpServer())
        .post('/auth/refresh-token')
        .send(refreshTokenInput)
        .expect(HttpStatus.OK)
        .expect((res) => {
          const token = res.body.data;
          expect(token).toHaveProperty('accessToken');
          expect(token).toHaveProperty('refreshToken');
        });
    });
  });

  afterAll(async () => {
    await app.close();
    await closeDBAfterTest();
  });
});
