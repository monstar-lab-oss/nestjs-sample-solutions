import { Module } from '@nestjs/common';

import { SharedModule } from './shared/shared.module';
import { UserModule } from './user/user.module';
import { AuthModule } from './auth/auth.module';

import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ArticleModule } from './article/article.module';
import { CommentModule } from './comment/comment.module';

@Module({
  imports: [SharedModule, UserModule, AuthModule, ArticleModule, CommentModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
