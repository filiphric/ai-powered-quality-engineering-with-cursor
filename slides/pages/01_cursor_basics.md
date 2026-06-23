---
layout: cover
---

Chapter #1:
# Cursor basics

---
layout: default
---
# What you’ll learn

- What is Cursor?
- How to use chat, tab completion and inline edits functionality
- Tips on how to use Cursor for test automation

---
layout: default
---
# What is Cursor?

- AI-powered code editor
- Originally forked from VS Code
- Context aware
- Customizable
- MCP support

<!--
- compared to chatgpt or gemini - it brings AI to where you need it, right into your IDE
- it was originally forked from VS Code, which makes migration super-easy, it feels familiar, while providing a great user experience (no longer the case for v3)
- it is context aware 
  - if you are editing a file, it undeerstands the logic of that file
  - you can work with multiple files at once or evene the whole codebase
  - it can understand references, imports, etc.
  - you can bring your own context, links, documentations and so on
- which brings me to customizability
  - Cursor is highly cusomizable
  - you can choose your favourite model, 
  - set rules for Cursor’s behavior
  - add your own tooling
- MCP support - you can use MCPs in Cursor, which allows you to do a lot of cool stuff that we will cover in this workshop
-->

---
layout: center
---

# Demo

<!--
## Part #1 - Show UI
- looks exactly the same as VS Code
- Cursor: Start Onboarding
- imports themes, plugins and everything on first opening
- installs CLI interface, allows you to set up privacy options

>⚠️ Note: make sure to enable Testing tab and toggle continuous run mode

## Part #2 - Show tab functionality
### Autocomplete suggestions
- Cursor understands the context of the file you are editing and suggests code completions based on the code you are writing.
![autocomplete suggestions](/autocomplete_suggestions.png)

- LLMs are basically a statistical models that are good at predicting what comes next. Very simply put, LLMs are good at predicting what the next word is based on previous context. So once there’s already some content created, Cursor will generally do a good job at pattern recognition.
> 💡 Tip: Go to your Cursor Keyboard shortucts and set up a shortcut to toggle the tab completion.

> ⚠️ Note: Finish the test before continuing, ideally make it fail

### Refactoring & rewriting

- Cursor can be very effective when rewriting code. For example, if your locator is incorrect in your test and it’s present in multiple places, Tab functionality can pick it up very well and make the editing process much easier.


Final code:
```ts
test('create a new list', async ({ page }) => {
  await page.goto('/board/1');

  await page.getByTestId('add-list-input').fill('Test list');
  await page.getByTestId('add-list-input').press('Enter');

  await expect(page.getByTestId('list')).toBeVisible();
});
```

## Part #3 - Show chat
- The chat is at the core of the Cursor experience. This is where you talk to AI and explain your goals.

- You can think of it as ChatGPT but integrated into your IDE. The big advantage of that is that in contrast to ChatGPT, Cursor can understand the context of the code you are writing.

- we can add context to the chat, like the file we want to reference

> Prompt: add a third test to add a card

- notice that the A.I. follows a certain pattern it can see in the file. but if we run the test, it will fail, because it doesn’t really have any context of our application
- we can either simply tell the A.I to click on the "Add another card" button, or we can reference the components
- this is where the real power is, because we as testers don’t need to fully understand the nuts and bolts of our application, but with the help of A.I. we can write our tests in a way that reflect the actual code

> Prompt: the assumptions of the test are not entirely complete. please take a look at the @CardCreateInput.vue and @ListItem.vue components to make sure you capture the sequence of actions properly

```ts
test('create a new card', async ({ page }) => {
  await page.goto('/board/1');

  // First click the "Add another card" button to show the input
  await page.getByTestId('new-card').click();
  
  // Then fill the card input field and submit
  await page.getByTestId('new-card-input').fill('Test card');
  await page.getByTestId('new-card-input').press('Enter');

  // Verify the card is visible
  await expect(page.getByTestId('card')).toBeVisible();
});
```

## Part #3 - Show inline edits

- By default, Cursor will try its best to look into the parts of the context of the codebase that matter and include them in the context. Inline edits are a great way to point the AI into a focused direction.

Inline edits work really well if you want to:

1. refactor your code
2. get a better understanding of the code that you are looking at.
3. edit only a specific part of the code.

> Prompt: Refactor these three tests into a single test and use test steps.

> 💡 Tip: You can use arrow up to go back to the previous message. 

-->