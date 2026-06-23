import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 5000,
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: 0,
  reporter: process.env.CI ? 'github' : 'list',
  workers: process.env.CI ? 1 : 1,
  use: {
    baseURL: 'http://localhost:3000',
    testIdAttribute: 'data-test-id',
  },
  webServer: {
    command: 'npm start',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
  projects: [
    { 
      name: 'setup', 
      testMatch: /.*\.setup\.ts/
    },
    {
      name: 'challenge',
      use: { ...devices['Desktop Chrome'] },
      testMatch: /.*\.spec\.ts/,
      dependencies: ['setup'],
    }
  ]
});
