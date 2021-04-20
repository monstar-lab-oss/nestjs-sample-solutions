import {
  IsNotEmpty,
  MaxLength,
  Length,
  IsString,
  IsArray,
  IsEnum,
  IsOptional,
  ArrayUnique,
  IsEmail,
  IsBoolean,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ROLE } from '../constants/role.constant';

export class RegisterInput {
  @ApiProperty()
  @IsNotEmpty()
  @MaxLength(100)
  @IsString()
  name: string;

  @ApiProperty()
  @MaxLength(200)
  @IsString()
  username: string;

  @ApiProperty()
  @IsNotEmpty()
  @Length(6, 100)
  @IsString()
  password: string;

  @ApiPropertyOptional({ example: [ROLE.USER] })
  @IsOptional()
  @IsArray()
  @ArrayUnique()
  @IsEnum(ROLE, { each: true })
  roles: ROLE[] = [ROLE.USER];

  @ApiProperty()
  @IsNotEmpty()
  @IsEmail()
  @MaxLength(100)
  email: string;

  @ApiProperty()
  @IsBoolean()
  isAccountDisabled: boolean;
}
