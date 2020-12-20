import { User } from './../../user/entities/user.entity';
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { STATUS } from '../constants/status.constant';
import { Comment } from './../../comment/entities/comment.entity';

@Entity()
export class Artcile {
  @PrimaryGeneratedColumn()
  id: number;

  title: string;

  content: string;

  @ManyToOne(() => User)
  @JoinColumn()
  author: User;

  @OneToMany(() => Comment, (comment) => comment.article)
  comments: Comment[];

  @Column({
    type: 'enum',
    enum: STATUS,
    default: STATUS.DRAFT,
  })
  status: STATUS;

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
