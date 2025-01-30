/*
 * @file main.ts
 * @description NestJS server entry point
 */

import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
    const app = await NestFactory.create(AppModule);
    app.enableCors();
    await app.listen(3000);
    console.log('🚀 NestJS server running on http://localhost:3000');
}
bootstrap();
