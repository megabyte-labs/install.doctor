## Code Style

We try to follow the same code style across all our Ansible repositories. If something is done one way somewhere, then it should be done the same way elsewhere. It is up to you to [browse through our roles]({{ repository.group.ansible_roles }}) to get a feel for how everything should be styled. You should clone [the main playbooks repository]({{ project.playbooks }}) (a.k.a. [Install Doctor]({{ link.installdoctor }})), initialize all the submodules either via `bash .start.sh` or `git submodule update --init --recursive`, and search through the code base to see how we are _styling_ different task types. Below are some examples:

### Arrays

When there is only one parameter, then you should inline it.

**❌ BAD**

```yaml
when:
  - install_minikube
```

**✅ GOOD**

```yaml
when: install_minikube
```

**✅ ALSO GOOD**

```yaml
when:
  - install_minikube
  - install_hyperv_plugin
```

### Alphabetical Order

Anywhere an array/list is used, the list should be ordered alphabetically (if possible).

**❌ BAD**

```yaml
autokey_dependencies:
  - pkg-config
  - make
  - git
```

**✅ GOOD**

```yaml
autokey_dependencies:
  - git
  - make
  - pkg-config
```

### Dependency Variables

In many cases, a role will require that specific software package dependencies are met before running. These dependencies are usually an array of packages that need to be installed.

Say the application being installed is Android Studio. The dependency array should be assigned to a variable titled `androidstudio_dependencies` (where "androidstudio" is retrieved from the `.galaxy_info.role_name` field in the `meta/main.yml` file) and placed in `vars/main.yml`.

**✅ GOOD example of defining the variable in the `vars/main.yml` file**

```yaml
---
androidstudio_dependencies:
  - ffmpeg
  - coolpackage
  - anotherpackage
```

**❌ BAD example of integrating the variable into a task file:**

```yaml
- name: "Ensure {{ {{ app_name }} }}'s dependencies are installed"
  community.general.pacman:
    name: '{{ {{ android_studio_deps }} }}'
    state: present
```

**✅ GOOD example of integrating the variable into a task file:**

```yaml
- name: "Ensure {{ {{ app_name }} }}'s dependencies are installed"
  community.general.pacman:
    name: '{{ {{ androidstudio_dependencies }} }}'
    state: present
```

If there are dependencies that are specific to a certain OS, then the dependency variable should be titled `{{ {{ .galaxy_info.role_name }} }}_dependencies_{{ {{ os_family }} }}`. For Android Studio, a Fedora-specific dependency list should be named `androidstudio_dependencies_fedora`. In practice, this would look like:

```yaml
- name: "Ensure {{ {{ app_name }} }}'s dependencies are installed (Fedora)"
  dnf:
    name: '{{ {{ androidstudio_dependencies_fedora }} }}'
    state: present
  when: ansible_distribution == 'Fedora'
```

### DRY

DRY stands for "Don't Repeat Yourself." Whenever there is code that is duplicated across multiple task files, you should separate it into a different file and then include it like in the following example:

**✅ GOOD**

```yaml
- name: Run generic Linux tasks
  include_tasks: install-Linux.yml
```
