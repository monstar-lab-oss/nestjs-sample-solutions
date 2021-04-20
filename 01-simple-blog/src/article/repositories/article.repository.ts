import { NotFoundException } from '@nestjs/common';
import { EntityRepository, Repository } from 'typeorm';

import { Artcile } from '../entities/article.entity';

@EntityRepository(Artcile)
export class ArticleRepository extends Repository<Artcile> {
  async getById(id: number): Promise<Artcile> {
    const user = await this.findOne(id);
    if (!user) {
      throw new NotFoundException();
    }

    return user;
  }
}
