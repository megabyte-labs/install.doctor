## ESLint

In the root of this project, you will see a file titled `.eslintrc`. This file controls how [ESLint](https://eslint.org/) works. As mentioned in the [Overview](#overview), our `.eslintrc` file is shared across all of [our NPM packages]({{ repository.group.npm }}). If you make changes to the `.eslintrc` file then they will be overwritten. Instead, if you absolutely need to change the `.eslintrc` file's definitions, then you should open up a pull request against the repository that houses all of the [common NPM package files]({{ repository.group.common }}/npm).

### Disabling ESLint Features

Instead of changing the `.eslintrc` file, we prefer that you instruct ESLint to disable checks for a specific rule on a specific line. For example, if you want to disable the `no-console` rule for one line of code, then you could accomplish this by modifying the code to follow the format below:

```
/* eslint-disable no-console */
console.log('foo');
/* eslint-enable no-console */
```

The above method is preferred over disabling all ESLint features. For example, we prefer that you never disable all checks on a line like this:

```
/* eslint-disable */
console.log('bar');
/* eslint-enable */
```

It is important that you include the second `/* eslint-enable */` line so that ESLint does not remain disabled for the rest of the file. Do not do this but, for your information, you can disable ESLint for an entire file by placing `/* eslint-disable */` at the top of the file.

**You should fix the lint error instead of using `/* eslint-disable */` whenever possible.**

For more details, see the [official ESLint docs](https://eslint.org/docs/2.13.1/user-guide/configuring#disabling-rules-with-inline-comments).
