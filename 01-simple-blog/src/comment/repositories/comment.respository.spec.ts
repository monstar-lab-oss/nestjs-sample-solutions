import { CommentRepository } from './comment.repository';

describe('CommentRepositorys', () => {
  it('should be defined', () => {
    expect(new CommentRepository()).toBeDefined();
  });
});
