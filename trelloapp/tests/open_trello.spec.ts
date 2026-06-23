import { test, expect } from '@playwright/test';

test('create new board', async ({ page, baseURL }) => {
  await page.goto(baseURL || '/');
  
  await page.getByTestId('first-board').fill('Test Board');
  await page.getByTestId('first-board').press('Enter');

  await expect(page).toHaveURL('/board/1');

});