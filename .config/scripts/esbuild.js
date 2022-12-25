import * as esbuild from 'esbuild'
import { nodeExternalsPlugin } from 'esbuild-node-externals'

esbuild.build({
  bundle: true,
  entryPoints: ['src/main.ts'],
  external: [
    '@nestjs/microservices',
    '@nestjs/websockets/socket-module',
    'cache-manager',
    'class-transformer',
    'class-validator'
  ],
  minify: true,
  outfile: 'dist/main.minified.js',
  platform: 'node',
  plugins: [nodeExternalsPlugin()]
})
