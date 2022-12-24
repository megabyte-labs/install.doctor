## Testing

You can test all of the operating systems we support by running the following command in the root of the project:

```shell
molecule test
```

The command `molecule test` will spin up VirtualBox VMs for all the OSes we support and run the role(s). _Do this before committing code._ If you are committing code for only one OS and can not create the fix or feature for the other operating systems then please, at the very minimum, [file an issue]({{ repository.gitlab }}{{ repository.location.issues }}) so someone else can pick it up.

### Idempotence

It is important to note that `molecule test` tests for idempotence. To pass the idempotence test means that if you run the role twice in a row then Ansible should not report any changes the second time around.

### Debugging

If you would like to shell into a container for debugging, you can do that by running:

```shell
task common:shell
```

### Molecule Documentation

For more information about Ansible Molecule, check out [the docs](https://molecule.readthedocs.io/en/latest/).

### Testing Desktop Environments

Some of our roles include applications like [Android Studio](https://github.com/ProfessorManhattan/ansible-androidstudio). You can not fully test Android Studio from a Docker command line. In cases like this, you should use our desktop scenarios to provision a desktop GUI-enabled VM to test things like:

- Making sure the Android Studio shortcut is in the applications menu
- Opening Android Studio to make sure it is behaving as expected
- Seeing if there is anything we can automate (e.g. if there is a "Terms of Usage" you have to click OK at then we should automate that process if possible)

You can specify which scenario you want to test by passing the `-s` flag with the name of the scenario you want to run. For instance, if you wanted to test on Ubuntu Desktop, you would run the following command:

```shell
molecule test -s ubuntu-desktop
```

This would run the Molecule test on Ubuntu Desktop.

By default, the `molecule test` command will destroy the VM after the test is complete. To run the Ubuntu Desktop test and then open the desktop GUI you would have to:

1. Run `molecule converge -s ubuntu-desktop`
2. Open the VM through the VirtualBox UI (the username and password are both _vagrant_)

You can obtain a list of all possible scenarios by looking in the `molecule/` folder. The `molecule/default/` folder is run when you do not pass a scenario. All the other scenarios can be run by manually specifying the scenario (e.g. `molecule test -s ubuntu-desktop` will run the test using the scenario in `molecule/ubuntu-desktop/`).

### Molecule Scenario Descriptions

The chart below provides a list of the scenarios we include in all of our Ansible projects along with a brief description of what they are included for.

{{ molecule_descriptions }}

### Continuous Integration (CI)

You might have noticed that there are no CI tests in the chart above for macOS and Windows. Due to the limitations of Docker, we use other methods to test macOS and Windows automatically with CI. After a project has passed various linting tests on GitLab CI, the following methods are used to test the Ansible play:

- Linux platforms are tested using Molecule and Docker on GitLab CI in parallel. ([Link to GitLab CI configuration]({{ repository.group.ci }}/-/blob/master/test/molecule.gitlab-ci.yml))
- Windows is tested using GitLab CI without Molecule. ([Link to GitLab CI configuration]({{ repository.group.ci }}/-/blob/master/test/windows-ansible-test.gitlab-ci.yml))
- macOS is tested using GitHub Actions after the code is automatically synchronized between GitLab and GitHub. ([Link to the macOS GitHub Action configuration]({{ repository.github }}/-/blob/master/.github/workflows/macOS.yml))
