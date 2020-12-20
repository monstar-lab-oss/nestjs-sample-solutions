import {
  Entity,
  ManyToOne,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

import { User } from './../../user/entities/user.entity';
import { Artcile } from './../../article/entities/article.entity';

@Entity()
export class Comment {
  @PrimaryGeneratedColumn()
  id: number;

  content: string;

  @ManyToOne(() => User)
  author: User;

  @ManyToOne(() => Artcile)
  article: Artcile;

  @CreateDateColumn({
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP(6)',
  })
  createdAt: Date;

  @UpdateDateColumn({
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP(6)',
    onUpdate: 'CURRENT_TIMESTAMP(6)',
  })
  updatesAt: Date;
}
