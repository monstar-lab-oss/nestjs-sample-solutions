import { NotFoundException } from '@nestjs/common';
import { EntityRepository, Repository } from 'typeorm';

import { Comment } from '../entities/comment.entity';

@EntityRepository(Comment)
export class CommentRepository extends Repository<Comment> {
  async getById(id: number): Promise<Comment> {
    const user = await this.findOne(id);
    if (!user) {
      throw new NotFoundException();
    }

    return user;
  }
}
