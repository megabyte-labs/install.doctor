## Linting

The process of running linters is mostly automated. Molecule is configured to lint so you will see linting errors when you run `molecule test` (note that not all Molecule scenarios include automatic linting). There is also a pre-commit hook that lints your code and performs other validations before allowing a `git commit` to go through. If you followed the [Setting Up Development Environment](#setting-up-development-environment) section, you should be all set to have your code automatically linted before pushing changes to the repository.

**Please note that before creating a pull request, all lint errors should be resolved.** If you would like to view all the steps we take to ensure great code then check out `.husky/pre-commit` and the other files in the `.husky/` folder.

### Fixing Ansible Lint Errors

You can manually run Ansible Lint by executing the following command in the project's root:

```shell
task lint:ansible
```

Most errors will be self-explanatory and simple to fix. Other errors might require testing and research. Below are some tips on fixing the trickier errors.

#### [208] File permissions unset or incorrect

If you get this error, do research to figure out the minimum permissions necessary for the file. After you change the permission, test the role (since changing permissions can easily break things).

#### [301] Command should not change things if nothing needs doing

This error can be solved by telling Ansible what files the command creates or deletes. When you specify what file a `command:` or `shell:` creates and/or deletes, Ansible will check for the presence or absence of the file to determine if the system is already in the desired state. If it is in the desired state, then Ansible skips the task. Refer to the [documentation for ansible.builtin.command](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html) for further details.

Here is an example of code that will remove the error:

```yaml
- name: Run command if /path/to/database does not exist
  command: /usr/bin/make_database.sh db_user db_name
  args:
    creates: /path/to/database # If the command deletes something, then you can swap out creates with removes
```

#### [305] Use shell only when shell functionality is required

Only use the Ansible `shell:` task when absolutely necessary. If you get this error then test if replacing `shell:` with `command:` resolves the error. If that does not work and you can not figure out how to properly configure the environment for `command:` to work, then you can add `# noqa 305` at the end of the line that includes the `name:` property. The same is true for other linting errors - `# noqa` followed by the reported lint error code will instruct `ansible-lint` to ignore the error.
