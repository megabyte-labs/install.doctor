## Testing

For each feature in an NPM package, some basic unit tests should be added. Although it may seem trivial for a new project, the unit tests can be helpful for spotting regressions when the project grows or when it is refactored years down the line. You can check out some examples of unit tests by checking out the `*.spec.ts` files listed on [this TypeScript Starter page](https://github.com/bitjson/typescript-starter/tree/master/src/lib).

### Using `npm link`

If you are creating a CLI, it is possible to install the module for testing before you publish the module to npm. After running `npm i && npm run build`, you can then run `npm link` in the root of the project. You can then access the app from its' shortcut defined in `package.json` under the `"bin"` value.

Take the following as an example:

**package.json**

```
{
    "name": "@megabytelabs/myapp",
    "bin": {
        "myclicommand": "bin/cli"
    },
}
```

Running `npm link` with the `package.json` configuration listed above will install the app so that it is accessible by running `myclicommand`.
