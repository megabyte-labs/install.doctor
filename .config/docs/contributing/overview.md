## Overview

This repository uses a customized starting template that is inspired by the [TypeScript Starter](https://github.com/bitjson/typescript-starter) project on GitHub. It includes many different build tools and files meant to improve team efficiency. All of the code and assets are stored in the `src/` folder. All of our NPM packages should follow the same format and use the same design patterns so it is important to check out a few of [our NPM repositories]({{ repository.group.npm }}) before diving into the code. Our [Buildr]({{ repository.project.buildr }}) project is a great example of what we are looking for.

After you clone this repository, you can get started by running `npm i` (with [Node.js >9]({{ repository.project.node }}) installed). This will install the dependencies as well as perform a few maintenance tasks such as synchronizing the common development-related dotfiles and re-generating the documentation.

### List Build Tool Commands

After you run `npm i`, you can view the available pre-defined build tool commands by running `npm run info`. A chart will be displayed in your terminal that looks something like this:

```
❯ npm run info

> {{ pkg.name }}@1.0.4 info
> npm-scripts-info

build:
  Clean and rebuild the project
commit:
  Automatically fix errors and guides you through the commit process
cov:
  Rebuild, run tests, then create and open the coverage report
doc:json:
  Generate API documentation in typedoc JSON format
doc:
  Generate HTML API documentation and open it in a browser
fix:
  Try to automatically fix any linting problems
info:
  Display information about the package scripts
prepare-release:
  One-step: clean, build, test, publish docs, and prep a release
reset:
  Delete all untracked files and reset the repo to the last commit
test:
  Lint and unit test the project
version:
  Bump package.json version, update CHANGELOG.md, tag release
watch:
  Watch and rebuild the project on save, then rerun relevant tests
```

You should then realize that you can build the project by running `npm run build` or test the project by running `npm run test`.

### Dotfiles

As you may have noticed, this project contains many files in the root directory. Many of these files are dotfiles. These files are intended to help our team of developers create code that is consistent and also compliant with industry best practices. Most of the dotfiles (and dot-folders) are synchronized across all of [our NPM packages]({{ repository.group.npm }}). This means that any changes you make to the dotfiles will eventually be over-written. If you need to make a change to any of the dotfiles, you will have to open a pull request against our [common NPM files repository]({{ repository.group.common }}/npm). Bear in mind that any changes you make to the common NPM files will be propagated to all of our NPM repositories.
