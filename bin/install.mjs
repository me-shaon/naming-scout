#!/usr/bin/env node
// Installs the Naming Scout skill into an agent's skills directory.
// No dependencies. Node 18 or newer.

import { cpSync, existsSync, mkdirSync, rmSync, readdirSync, statSync } from 'node:fs';
import { homedir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFileSync } from 'node:child_process';

const HERE = dirname(fileURLToPath(import.meta.url));
const SOURCE = resolve(HERE, '..', 'naming-scout');
const NAME = 'naming-scout';

const c = process.stdout.isTTY
  ? { d: '\x1b[2m', b: '\x1b[1m', g: '\x1b[32m', y: '\x1b[33m', r: '\x1b[31m', x: '\x1b[0m' }
  : { d: '', b: '', g: '', y: '', r: '', x: '' };

const argv = process.argv.slice(2);
const has = (...f) => f.some((x) => argv.includes(x));
const valueOf = (flag) => {
  const i = argv.indexOf(flag);
  return i !== -1 && argv[i + 1] && !argv[i + 1].startsWith('-') ? argv[i + 1] : null;
};

if (has('-h', '--help')) {
  console.log(`
${c.b}Naming Scout${c.x}  installs a naming and clearance skill for coding agents

  ${c.b}npx naming-scout${c.x}              install into ./.claude/skills
  ${c.b}npx naming-scout --global${c.x}     install into ~/.claude/skills
  ${c.b}npx naming-scout --dir PATH${c.x}   install into a directory you choose

Options
  -g, --global     install for your user instead of this project
      --dir PATH   target skills directory
  -f, --force      overwrite an existing installation
  -h, --help       show this

Also installable straight from the repository:
  ${c.d}npx skills add me-shaon/naming-scout${c.x}
`);
  process.exit(0);
}

if (!existsSync(SOURCE) || !existsSync(join(SOURCE, 'SKILL.md'))) {
  console.error(`${c.r}error${c.x} skill files are missing from this package (looked in ${SOURCE})`);
  process.exit(1);
}

const custom = valueOf('--dir');
const skillsDir = custom
  ? resolve(custom)
  : has('-g', '--global')
    ? join(homedir(), '.claude', 'skills')
    : join(process.cwd(), '.claude', 'skills');

const target = join(skillsDir, NAME);
const force = has('-f', '--force');

if (existsSync(target) && !force) {
  console.error(`${c.y}already installed${c.x} ${target}`);
  console.error(`Run again with --force to overwrite it.`);
  process.exit(1);
}

try {
  mkdirSync(skillsDir, { recursive: true });
  if (existsSync(target)) rmSync(target, { recursive: true, force: true });
  cpSync(SOURCE, target, { recursive: true });
} catch (err) {
  console.error(`${c.r}error${c.x} could not write to ${target}`);
  console.error(`  ${err.message}`);
  process.exit(1);
}

// The domain and namespace checks are shell scripts, so they need the executable bit.
// npm does not always preserve it through a tarball.
for (const f of readdirSync(join(target, 'scripts'))) {
  const p = join(target, 'scripts', f);
  if (statSync(p).isFile()) {
    try { execFileSync('chmod', ['+x', p]); } catch { /* non-fatal on Windows */ }
  }
}

const missing = ['curl', 'jq'].filter((tool) => {
  try { execFileSync('command', ['-v', tool], { shell: true, stdio: 'ignore' }); return false; }
  catch { return true; }
});

console.log(`
${c.g}installed${c.x} ${c.b}${NAME}${c.x} to ${target}
`);

if (missing.length) {
  console.log(`${c.y}missing${c.x} ${missing.join(' and ')}. The live checks need ${missing.length > 1 ? 'them' : 'it'}.`);
  console.log(`  macOS:  brew install ${missing.join(' ')}`);
  console.log(`  Debian: sudo apt install ${missing.join(' ')}\n`);
}

console.log(`Start a new session and describe what you are building:

  ${c.d}I'm building a budgeting app for freelancers. The problem is irregular${c.x}
  ${c.d}income. Normal budgeting apps are useless for it. Need a name.${c.x}

It interviews you, works through metaphor territories, checks only what your
project needs, and opens a report in your browser.
`);

if (!has('-g', '--global') && !custom) {
  console.log(`${c.d}Installed for this project only. Use --global for every project.${c.x}\n`);
}
