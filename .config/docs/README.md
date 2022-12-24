<div align="center">
  <center>
    <a href="https://gitlab.com/megabyte-labs/documentation">
      <img width="140" height="140" alt="Documentation logo" src="https://gitlab.com/megabyte-labs/documentation/shared/-/raw/master/logo.png" />
    </a>
  </center>
</div>
<div align="center">
  <center><h1>Common Documentation</h1></center>
  <center><h4 style="color: #18c3d1;">Documentation partials and JSON variables for generating sweet READMEs and templated files for hundreds of repositories</h4></center>
</div>

[![-----------------------------------------------------](https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png)](#table-of-contents)

## Table of Contents

- [➤ Summary](#summary)
- [➤ Repository Types](#repository-types)
- [➤ Requirements](#repository-pipeline-order)
- [➤ Flow Summary](#flow-summary)
- [➤ `common.json`](#common-json)

[![-----------------------------------------------------](https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png)](#summary)

## Summary

In all of our projects, we strive to maintain useful and informative documentation. However, with hundreds of projects and limited man power, it can be tricky. To solve this problem, we re-use documentation partials to generate the documentation in each of our repositories.

There are two repositories responsible for generating the documentation for each project:

1. **[Shared documentation repository](https://gitlab.com/megabyte-labs/documentation/shared):** This repository contains documentation partials that are used throughout all of our repositories.
2. **Project-type documentation repository:** This repository is where we store documentation that is specific to the type of project that downstream repository is. For example, if the downstream project is an Ansible role, then the repositories that will be used to generate the documentation will be the shared documentation repository and the [Ansible documentation repository](https://gitlab.com/megabyte-labs/documentation/ansible).

[![-----------------------------------------------------](https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png)](#repository-types)

## Repository Types

We currently use this method to scaffold our projects of the following types:

1. [Angular](https://gitlab.com/megabyte-labs/documentation/angular)
2. [Ansible](https://gitlab.com/megabyte-labs/documentation/ansible)
3. [Dockerfile](https://gitlab.com/megabyte-labs/documentation/dockerfile)
4. [Go](https://gitlab.com/megabyte-labs/documentation/go)
5. [NPM](https://gitlab.com/megabyte-labs/documentation/npm)
6. [Packer](https://gitlab.com/megabyte-labs/documentation/packer)
7. [Python](https://gitlab.com/megabyte-labs/documentation/python)

[![-----------------------------------------------------](https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png)](#repository-pipeline-order)

## Repository Pipeline Order

Whenever a change is made to the shared documentation repository, the pipeline for the project-specific repositories will trigger (unless it is configured not to do so). Part of that pipeline includes cloning the shared documentation repository into the project-specific repository. When this happens, the `common/` folder in the shared repository is copied over to the project-specific repository.

After the `common/` folder is copied over, the project-specific repository will trigger the pipeline for the project-specific common files repository (e.g. [Ansible common files repository](https://gitlab.com/megabyte-labs/common/ansible)). When this is happens, the project-specific documentation repository is added to the project-specific common files repository in the `docs/` folder.

Finally, after the project-specific common files repository is up-to-date, the files it contains are propagated out to the individual projects that all of these repositories are for. This whole process allows us to update, say, a spelling error in the documentation to every project in our eco-system without an repetition.

[![-----------------------------------------------------](https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png)](#flow-summary)

## Flow Summary

To summarize, the order of the flow is:

1. [Shared documentation repository](https://gitlab.com/megabyte-labs/documentation/shared)
2. Project-specific documentation repository (e.g. [Ansible documentation](https://gitlab.com/megabyte-labs/documentation/ansible))
3. Project-specific common files repository (e.g. [Ansible common files](https://gitlab.com/megabyte-labs/common/ansible))
4. Individual project repository (e.g. [Ansible role for Android Studio](https://gitlab.com/megabyte-labs/ansible-roles/androidstudio))

So, with synchronization turned on, a change to the shared documentation repository would trigger updates for the most repositories since it is the highest upstream repository.

[![-----------------------------------------------------](https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png)](#common-json)

## `common.json`

In both the shared documentation repository and the project-specific documentation repositories there is a file called `common.json` in the root of the projects. These files contain variables that are used to dynamically inject variables into the documentation and other files. The `common.json` files in both repositories are merged when there are updates to create the `variables.json` file that is in each project-specific documentation repository. During this process, the variables in the project-specific `common.json` file takes precedence over the variables in the shared `common.json` file. There are a few other steps that are made to create the final version of the `.variables.json` that each project uses to generate documentation and other files. In order of precedence, the variables are acquired from:

1. The variables in the `"blueprint"` section of the `package.json` file that is located in each downstream project
2. The variables stored in the `common.{{ project_subgroup }}.json` file stored in the common files repository for each project type (e.g. the [Android Studio Ansible project](https://gitlab.com/megabyte-labs/ansible-roles/androidstudio) uses the `common.role.json` file in the [Ansible common files repository](https://gitlab.com/megabyte-labs/common/ansible) since the project subtype is a role)
3. The `common.json` file in the project-type-specific documentation repository (e.g. for the Android Studio Ansible role this would be the [Ansible documentation repository](https://gitlab.com/megabyte-labs/documentation/ansible))
4. The `common.json` file in the [shared documentation repository](https://gitlab.com/megabyte-labs/documentation/shared)
