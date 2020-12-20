import { ArticleRepository } from './article.repository';

describe('ArticleRepository', () => {
  it('should be defined', () => {
    expect(new ArticleRepository()).toBeDefined();
  });
});
