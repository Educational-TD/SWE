# Contributing Guide

- [Getting started](#getting-started)
- [Workflow](#workflow)
- Coding standards !TODO

## Getting started

1) [Add an SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) to your GitHub account

2) Clone the repository

    ```bash
    git clone git@github.com:Educational-TD/SWE.git
    cd ./SWE
    ```

3) Setup your local git config

    If you'd like your commits to be linked to your GitHub account then use the same email associated with your account.

    Replace the `--global` flag with `--local` if you'd like these changes to only apply inside this repository.

    ```bash
    git config add --global user.name "Your Name"
    git config add --global user.email "yourEmail@provider.com"
    ```

## Workflow

The following workflow should be followed when contributing to the project. This helps keep our development process stay consistent between contributors.

### Creating an issue

[Issues](https://github.com/Educational-TD/SWE/issues) are used to describe work that needs to be completed. That work could be a new feature, a bug fix, or creating/updating documentation. Issues will typically be assigned to only one contributor. The issue creator and assignee do not need to be the same person.

1) Create a `New issue`, if one doesn't already exist.

2) In the issue view under `Development` select `Create a branch`

3) Use the default branch name and select `Create branch`

### Working on an issue

When working on an issue, it is best practice that **only** the assignee will be committing changes to the associated branch. Following this rule helps prevent diverging/conflicting commit histories. The exception to this rule is if the assignee has explicitly given another contributor permission to push to their branch.

1) Checkout the new branch

    ```bash
    git fetch
    git checkout 0-newly-created-branch
    ```

2) Make changes and commit them as you normally would

3) If changes are made to the target branch, use `rebase` to update your feature branch

### Getting feedback

In order to merge your changes into `main` you're required to create and receive approval on a [pull request](https://github.com/Educational-TD/SWE/pulls) (PR). This can be done before or after actually finishing development on an issue (if done before the PR should be marked as a `draft`). When responding to reviewers' comments, it is best practice that **only** the reviewer resolves the thread they created.

1) Create the PR, adding a summary of the changes you made

2) Assign at least two contributors to review your work

3) Merge as a `squash merge` after reviewers have approved your work
