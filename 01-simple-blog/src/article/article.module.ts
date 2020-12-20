import { Module } from '@nestjs/common';
import { ArticleController } from './controllers/article/article.controller';
import { ArticleService } from './services/article.service';

@Module({
  controllers: [ArticleController],
  providers: [ArticleService],
})
export class ArticleModule {}
