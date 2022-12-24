## Updating Meta Files and Documentation

Since we have hundreds of Ansible roles to maintain, the majority of the files inside each role are shared across all our Ansible projects. We synchronize these common files across all our repositories with various build tools. When you clone a new repository, the first command you should run is `bash .start.sh`. This will install missing software requirements, run the full update sequence, and ensure everything is up-to-date. To synchronize the project at a later point in time, you can run `task common:update` which runs most of the logic executed by running `bash .start.sh`.

### The `"blueprint" package.json` Field and `@appnest/readme`

In the root of all of our Ansible repositories, we include a file named `package.json`. In the key named `"blueprint"`, there are variables that are used in our build tools. Most of the variables stored in `"blueprint"` are used for generating documentation. All of our documentation is generated using variables and document partials that we feed into a project called `[@appnest/readme]({{ misc.appnest }})` (which is in charge of generating the final README/CONTRIBUTING guides). When `@appnest/readme` is run, it includes the variables stored in `"blueprint"` in the context that it uses to inject variables in the documentation. You can view the documentation partials by checking out the `./.common` folder which is a submodule that is shared across all of our Ansible projects.

For every role that is included in our eco-system, we require certain fields to be filled out in the `"blueprint"` section of the `package.json` file. Lucky for you, most of the fields in the file are auto-generated. The fields that need to be filled out as well as descriptions of what they should contain are listed in the chart below:

{{ blueprint_requirements }}

### `meta/main.yml` Description

The most important piece of text in each of our Ansible projects is the [Ansible Galaxy]({{ profile_link.galaxy }}) description located in `meta/main.yml`. This text is used in search results on Ansible Galaxy and GitHub. It is also spun to generate multiple variants so it has to be worded in a way that makes sense with our different variants. Take the following as an example:

**The `meta/main.yml` description example:**

- Installs Android Studio and sets up Android SDKs on nearly any OS

**Gets spun and used by our automated documentation framework in the following formats:**

- Installs Android Studio and sets up Android SDKs on nearly any OS
- An Ansible role that _installs Android Studio and sets up Android SDKs on nearly any OS_
- This repository is the home of an Ansible role that _installs Ansible Studio and sets up Android SDKs on nearly any OS_.

It is important that all three variants of the `meta/main.yml` description make sense and be proper English. The `meta/main.yml` description should succinctly describe what the role does and possibly even describe what the product does if it is not well-known like Android Studio. An example of a description that includes an overview of the product would be something like, "Installs HTTPie (a user-friendly, command-line HTTP client) on nearly any platform," for the [HTTPie role](https://github.com/ProfessorManhattan/ansible-httpie) or "Installs Packer (an automation tool for building machine images) on nearly any platform" for the [Packer role](https://github.com/ProfessorManhattan/ansible-packer).

### `logo.png`

We include a `logo.png` file in all of our Ansible projects. This image is automatically integrated with GitLab so that a thumbnail appears next to the project. It is also shown in the README to give the user a better idea of what the role does. All roles should include the `logo.png` file. When adding a `logo.png` file please _strictly_ adhere to the steps below:

1. Use Google image search to find a logo that best represents the product. Ensure the image is a `.png` file and that it has a transparent background, if possible. Ideally, the image should be the official logo for software that the Ansible role/project installs. The image should be at least 200x200 pixels.
2. After downloading the image, ensure you have the sharp-cli installed by running `npm install -g sharp-cli`.
3. Resize the image to 200x200 pixels by running `sharp -i file_location.png -o logo.png resize 200 200`.
4. Compress the resized image by dragging and dropping the resized image into the [TinyPNG web application]({{ misc.tinypng }}).
5. Download the compressed image and add it to the root of the Ansible project. Make sure it is named `logo.png`.

Alternatively, you can use our pre-commit hook to automatically take care of steps 2-5 when the `logo.png` file is staged with git.
