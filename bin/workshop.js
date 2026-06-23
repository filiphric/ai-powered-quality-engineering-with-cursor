#!/usr/bin/env node
const { execFileSync } = require('child_process');
const path = require('path');

const scriptsDir = path.join(__dirname, '..', 'scripts');
const args = process.argv.slice(2);
const command = args[0];
const isWindows = process.platform === 'win32';

const bashCommands = {
  start:  { script: 'setup.sh',  args: ['start'] },
  reset:  { script: 'setup.sh',  args: ['reset'] },
  check:  { script: 'setup.sh',  args: ['check'] },
  verify: { script: 'setup.sh',  args: ['verify'] },
  setup:  { script: 'setup.sh',  args: [] },
};

function usage() {
  console.log(`
  Usage: workshop <command>

  Commands:
    setup           Run the workshop setup
    start           Start the application
    reset           Reset the application (clear database)
    check           Check ports (3000 & 3001)
    verify          Verify setup

  Examples:
    workshop setup
    workshop start
`);
  process.exit(0);
}

if (!command) usage();

if (!bashCommands[command]) usage();

if (isWindows) {
  console.error(`  The '${command}' command is not supported on Windows via this CLI.`);
  console.error('  Please use setup.ps1 directly.\n');
  process.exit(1);
}

const { script, args: scriptArgs } = bashCommands[command];
const scriptPath = path.join(scriptsDir, script);

try {
  execFileSync('bash', [scriptPath, ...scriptArgs], { stdio: 'inherit' });
} catch (err) {
  process.exit(err.status || 1);
}
