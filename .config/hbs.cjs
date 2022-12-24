const fs = require('fs')
const { execSync } = require('child_process')

function getTaskIncludeKey(path) {
  return path
    .replace('.config/taskfiles/', '')
    .replace('local/', '')
    .replace('/Taskfile-', ':')
    .replace('/Taskfile.yml', '')
    .replace('Taskfile-', '')
    .replace('.yml', '')
}

module.exports.register = function (Handlebars) {
  /**
   * Import [handlebars-helpers](https://github.com/helpers/handlebars-helpers)
   */
  require('handlebars-helpers')({
    handlebars: Handlebars
  })

  /**
   * Used to generate the includes: section of the main Taskfile.yml
   * in the root of every repository
   */
  Handlebars.registerHelper('bodegaIncludes', (pattern, options) => {
    const readdir = Handlebars.helpers.readdir
    const files = readdir('.config/taskfiles/')
    const tasks = Handlebars.helpers.each([...files, './local'], {
      fn: (file) => {
        if (fs.lstatSync(file).isDirectory()) {
          return readdir(file).filter((taskfile) => taskfile.match(/.*Taskfile.*.yml/gu))
        } else {
          return []
        }
      }
    })

    return tasks
      .replaceAll('.config/taskfiles/', ',.config/taskfiles/')
      .replaceAll('local/', ',local/')
      .split(',')
      .map((path) => ({
        key: getTaskIncludeKey(path),
        taskPath: './' + path,
        optional: path.includes('local/Taskfile-')
      }))
      .filter((x) => !!x.key)
      .sort((a, b) => a.key.localeCompare(b.key))
  })

  /**
   * Used for returning input from synchronous commands (i.e. bash commands)
   */
  Handlebars.registerHelper('execSync', function (input, options) {
    const output = execSync(input)

    return output
  })

  /**
   * Used for generating Homebrew resource stanzas for Python packages.
   * For more information, see: https://github.com/tdsmith/homebrew-pypi-poet
   */
  Handlebars.registerHelper('poet', function (input, options) {
    const formulae = execSync('poetry run poet -f ' + input)

    return formulae
  })
}
