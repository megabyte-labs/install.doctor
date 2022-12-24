## Example Playbook

With the dependencies installed, all you have to do is add the role to your main playbook. The role handles the `become` behavior so you can simply add the role to your playbook without having to worry about commands that should not be run as root:

```lang-yml
- hosts: all
  roles:
    - {{ galaxy_info.namespace }}.{{ galaxy_info.role_name }}
```

If you are incorporating this role into a pre-existing playbook, then it might be prudent to copy the requirements outlined in `pyproject.toml` and `requirements.yml` to their corresponding files in the root of your playbook so you only have to worry about installing one set of requirements during future use. Note that the dependencies in `pyproject.toml` can be moved to the more traditional `requirements.txt`, if that is what you are currently using to track Python dependencies.

### Real World Example

You can find an example of a playbook that incorporates this role in our main playbook (a.k.a. [Gas Station]({{ repository.project.playbooks }})). The playbook is an excellent example for someone learning how to use Ansible. It also incorporates a lot of well-thought out build tools that more advanced Ansible users can appreciate. And people who could care less about Ansible can also benefit from it because it allows you to more or less turn your computer (and network) into the ultimate development enivornment. The bottom line is that it is an awesome project that developers should know about!
