import { createServer } from './backend/index';
import { trelloConsole } from './backend/console';
import { defineConfig, createLogger } from 'vite';
import svgr from 'vite-plugin-svgr';
import react from '@vitejs/plugin-react';
import tsconfigPaths from 'vite-tsconfig-paths'
import constants from './constants'

const { APP, SERVER } = constants

const logger = createLogger();
logger.info = () => {};

export default defineConfig({
  customLogger: logger,
  define: {
    'process.env': {}
  },
  plugins: [
    react(),
    svgr({ exportAsDefault: true }),
    createServer(),
    trelloConsole(APP),
    tsconfigPaths({ extensions: ['.ts', '.tsx', '.d.ts'] })
  ],
  clearScreen: false,
  server: {
    port: APP,
    proxy: {
      '^/api/.*': {
        changeOrigin: true,
        rewrite: path => path.replace(/^\/api/, ''),
        target: `http://localhost:${SERVER}`
      },
    }
  }
});
