## Installation

This NPM package includes all the packages it makes use of as `dependencies`. This means that you do not have to include all the [plugins it uses]({{repository.gitlab}}/-/blob/master/package.json) in your `package.json`. However, it also means that you should make sure that you do not include this package in your `package.json` `dependencies`. Instead, you should include the package in your `devDependencies`. This is accomplished by installing the package with the following command:

```shell
npm install --save-dev @{{profile.npmjs_organization}}/{{repository.prefix.github}}{{slug}}
```
