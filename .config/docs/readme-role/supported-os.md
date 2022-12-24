## Supported Operating Systems

The chart below shows the operating systems that we have tested this role on. It is automatically generated using the Ansible Molecule tests located in the `molecule/` folder. There is CI logic in place to automatically handle the testing of Windows, macOS, Ubuntu, Fedora, CentOS, Debian, and Archlinux. If your operating system is not listed but is a variant of one of the systems we test (i.e. a Debian-flavored system or a RedHat-flavored system) then it is possible that the role will still work.

{{ compatibility_matrix }}

**_What does idempotent mean?_** Idempotent means that if you run this role twice in row then there will be no changes to the system the second time around.

We spent a lot of time perfecting our CI configurations and build tools. If you are interested in learning more about how we perfected our process then you might find our [Ansible common files](https://gitlab.com/megabyte-labs/common/ansible) and [Ansible documentation](https://gitlab.com/megabyte-labs/documentation/ansible) repositories interesting. See the [CONTRIBUTING.md](docs/CONTRIBUTING.md) guide for more details.
