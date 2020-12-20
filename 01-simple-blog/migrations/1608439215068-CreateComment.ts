import {MigrationInterface, QueryRunner} from "typeorm";

export class CreateComment1608439215068 implements MigrationInterface {
    name = 'CreateComment1608439215068'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query("ALTER TABLE `comment` ADD `articleId` int NULL");
        await queryRunner.query("ALTER TABLE `comment` ADD CONSTRAINT `FK_c20404221e5c125a581a0d90c0e` FOREIGN KEY (`articleId`) REFERENCES `artcile`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION");
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query("ALTER TABLE `comment` DROP FOREIGN KEY `FK_c20404221e5c125a581a0d90c0e`");
        await queryRunner.query("ALTER TABLE `comment` DROP COLUMN `articleId`");
    }

}
