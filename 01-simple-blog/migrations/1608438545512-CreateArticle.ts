import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateArticle1608438545512 implements MigrationInterface {
  name = 'CreateArticle1608438545512';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      "CREATE TABLE `artcile` (`id` int NOT NULL AUTO_INCREMENT, `status` enum ('0', '1', '10') NOT NULL DEFAULT '0', `createdAt` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), `updatesAt` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6), `authorId` int NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB",
    );
    await queryRunner.query(
      'ALTER TABLE `artcile` ADD CONSTRAINT `FK_bcdd5521505d95047cdd7198c04` FOREIGN KEY (`authorId`) REFERENCES `users`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION',
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      'ALTER TABLE `artcile` DROP FOREIGN KEY `FK_bcdd5521505d95047cdd7198c04`',
    );
    await queryRunner.query('DROP TABLE `artcile`');
  }
}
