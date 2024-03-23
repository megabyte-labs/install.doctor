#!/usr/bin/env zx

let definitions, softwarePackages

async function getSoftwareDefinitions() {
    try {
        return YAML.parse(fs.readFileSync(`${os.homedir()}/.local/share/chezmoi/software.yml`, 'utf8'))
    } catch (e) {
        throw Error('Failed to load software definitions', e)
    }
}

async function writeSoftwareDefinitions() {
    try {
        fs.writeFileSync(fs.readFileSync(`${os.homedir()}/.local/share/chezmoi/software.yml`, YAML.stringify(definitions)))
    } catch (e) {
        throw Error('Failed to write new software definitions file', e)
    }
}

async function populateMissing() {
    definitions = await getSoftwareDefinitions()
    softwarePackages = definitions.softwarePackages
    for (const pkg in softwarePackages) {
        if (softwarePackages[pkg]._github) {
            console.log(pkg)
            if (!softwarePackages[pkg]._desc) {
                const sgptResponse = await $`sgpt "Describe ${softwarePackages[pkg]._github}. Do not say that you can find more information on its GitHub page."`
                console.log('--- START - SGPT Response for Description Acquired ---')
                console.log(sgptResponse.stdout)
                console.log('--- END - SGPT Response for Description Acquired ---')
                softwarePackages[pkg]._desc = sgptResponse.stdout
            }

            if (!softwarePackages[pkg]._name) {
                const sgptResponse = await $`sgpt "What is the project name of ${softwarePackages[pkg]._github}? Only print the project name without any additional text."`
                console.log('--- START - SGPT Response for Name Acquired ---')
                console.log(sgptResponse.stdout)
                console.log('--- END - SGPT Response for Name Acquired ---')
                softwarePackages[pkg]._name = sgptResponse.stdout
            }
        } else if (softwarePackages[pkg]._github === false) {
            console.log('No GitHub repository for ' + pkg)
        } else {
            console.log('MISSING GITHUB REPOSITORY INFORMATION FOR ' + pkg)
        }
    }
    definitions.softwarePackages = softwarePackages
}

async function main() {
    await populateMissing()

}

console.log('Running script..')
main()