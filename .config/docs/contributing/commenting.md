## Commenting

We strive to make our roles easy to understand. Commenting is a major part of making our roles easier to grasp. Several types of comments are supported in such a way that they are extracted and injected into our documentation. This project uses [mod-ansible-autodoc]({{ link.mod_ansible_autodoc }}) (a pet project of ours and a fork of [ansible-autodoc](https://pypi.org/project/ansible-autodoc/)) to scan through specially marked up comments and generate documentation out of them. The module also allows the use of markdown in comments so feel free to **bold**, _italicize_, and `code_block` as necessary. Although it is perfectly acceptable to use regular comments, in most cases you should use one of the following types of _special_ comments:

- [Variable comments](#variable-comments)
- [Action comments](#action-comments)
- [TODO comments](#todo-comments)

### Variable Comments

It is usually not necessary to add full-fledged comments to anything in the `vars/` folder but the `defaults/main.yml` file is a different story. The `defaults/main.yml` file must be fully commented since it is where we store all the variables that our users can customize. **`defaults/main.yml` is the only place where comments using the following format should be present.**

Each variable in `defaults/main.yml` should be added and documented using the following format:

<!-- prettier-ignore-start -->
```yaml
 # @var variable_name: default_value
 # The description of the variable which should be no longer than 160 characters per line.
 # You can separate the description into new lines so you do not pass the 160 character
 # limit
 variable_name: default_value
```
<!-- prettier-ignore-end -->

There may be cases where an example is helpful. In these cases, use the following format:

<!-- prettier-ignore-start -->
```yaml
 # @var variable_name: []
 # The description of the variable which should be no longer than 160 characters per line.
 # You can separate the description into new lines so you do not pass the 160 character
 # limit
 variable_name: []
 # @example #
 # variable_name:
 #   - name: jimmy
 #     param: henry
 #   - name: albert
 # @end
```
<!-- prettier-ignore-end -->

Each variable-comment block in `defaults/main.yml` should be separated by a line return. You can see an example of a `defaults/main.yml` file using this special [variable syntax in the Docker role]({{ link.docker_role }}/blob/master/defaults/main.yml).

### Action Comments

Action comments allow us to describe what the role does. Each action comment should include an action group as well as a description of the feature or "action". Most of the action comments should probably be added to the `tasks/main.yml` file although there could be cases where an action comment is added in a specific task file (like `install-Darwin.yml`, for instance). Action comments allow us to group similar tasks into lists under the action comment's group.

#### Example Action Comment Implementation

The following is an example of the implementation of action comments. You can find the [source here]({{ link.docker_role }}/blob/master/tasks/main.yml) as well as an example of why and how you would include an [action comment outside of the `tasks/main.yml` file here]({{ link.docker_role }}/blob/master/tasks/compose-Darwin.yml).

<!-- prettier-ignore-start -->
```yaml
 # @action Ensures Docker is installed
 # Installs Docker on the target machine.
 # @action Ensures Docker is installed
 # Ensures Docker is started on boot.
 - name: Include tasks based on the operating system
   block:
     - include_tasks: 'install-{{ {{ ansible_os_family }} }}.yml'
   when: not docker_snap_install

 # @action Ensures Docker is installed
 # If the target Docker host is a Linux machine and the `docker_snap_install` variable
 # is set to true, then Docker will be installed as a snap package.
 - name: Install Docker via snap
   community.general.snap:
     name: docker
   when:
     - ansible_os_family not in ('Windows', 'Darwin')
     - docker_snap_install

 # @action Installs Docker Compose
 # Installs Docker Compose if the `docker_install_compose` variable is set to true.
 - name: Install Docker Compose (based on OS)
   block:
     - include_tasks: 'compose-{{ {{ ansible_os_family }} }}.yml'
   when: docker_install_compose | bool
```
<!-- prettier-ignore-end -->

#### Example Action Comment Generated Output

The block of code above will generate markdown that would look similar to this:

**Ensures Docker is installed**

- Installs Docker on the target machine.
- Ensures Docker is started on boot.
- If the target Docker host is a Linux machine and the `docker_snap_install` variable is set to true, then Docker will be installed as a snap package.

**Installs Docker Compose**

- Installs Docker Compose if the `docker_install_compose` variable is set to true.

#### Action Comment Guidelines

- The wording of each action should be in active tense, describing a capability of the role. So instead of calling an action "Generate TLS certificates," we would call it, "Generates TLS certificates."
- The bulk of the action comments should be placed in the `tasks/main.yml` file. However, there may be use cases for putting an action comment in another file. For instance, if the business logic is different for Windows hosts, then we might add action comments to the `install-Windows.yml` file explaining the different logic.
- The goal of action comments are to present our users with some easy to understand bullet points about exactly what the role does and also elaborate on some of the higher-level technical details.

### TODO Comments

TODO comments are similar to action comments in the sense that through automation similar comments will be grouped together. You should use them anytime you find a bug, think of an improvement, spot something that needs testing, or realize there is a desirable feature missing. Take the following as an example:

#### Example TODO Comment Implementation

<!-- prettier-ignore-start -->
```yaml
  # @todo Bug: bug description
  # @todo improvement: improvement description
  # @todo Bug: another bug description
```
<!-- prettier-ignore-end -->

#### Example TODO Comment Generated Output

The above code will output something that looks like this:

**Bug**

- bug description
- another bug description

**improvement**

- improvement description

Notice how the title for _improvement_ is not capitalized. It should be capitalized so make sure you pay attention to that detail.

#### TODO Comment Guidelines

- A TODO comment can be placed anywhere as long as no lines pass the limit of 160 characters.
- Try using similar TODO comment groups. Nothing is set in stone yet but try to use the following categories unless you really believe we need a new category:
  - Bug
  - Feature
  - Improvement
  - Test
- Ensure you capitalize the category
