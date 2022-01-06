# Continuouns Integration

When we making any commit in this repository we want to autamically take the literate programming documents in 'docs' and extract the code from them (tangle) and update the website where they are exposed (weaving).

To achive that automatation we are going to use GitHub actions.

## Basic structure of a GitHubAction

I took  this material from [mkdocs-material](https://squidfunk.github.io/mkdocs-material/publishing-your-site/#github-pages)

Using [GitHub Actions] you can automate the deployment of your project
documentation. At the root of your repository, create a new GitHub Actions
workflow, e.g. `.github/workflows/ci.yml`, and copy and paste the following
contents:

```yaml title="file://.github/workflows/ci.yml"
name: ci # (1)!
on:
  push:
    branches: # (2)!
      - master
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
        with:
          python-version: 3.x
      <<tangle_code_files>>
      <<weave_mkdocs_site>>

```

1.  You can change the name to your liking. 

2.  At some point, GitHub renamed `master` to `main`. If your default branch
        is named `master`, you can safely remove `main`, vice versa.

3.  This is the place to install further [MkDocs plugins] or Markdown extensions with `pip` to be used during the build:

``` sh
  pip install \
    mkdocs-material \
    mkdocs-awesome-pages-plugin \
    ...
```

## Tangle

We first need to generate all the code files from the literate markdown files. In order to do that we will entangled.

```yaml title="#tangle_code_files"
- run: pip install entangled-filters
- run: wget https://github.com/entangled/entangled/releases/download/v1.2.4/entangled-1.2.4-x86_64-GNU-Linux.tar.xz && tar --extract --file entangled-1.2.4-x86_64-GNU-Linux.tar.xz && sudo cp -r ./entangled-1.2.4/* /usr/local/
- run: entangled tangle -a
```

## Weaving
Is the process of taking the literate markdown files and generating a beautiful website for humans to consume
 
```yaml title="#weave_mkdocs_site"
- run: pip install mkdocs-material # (3)!
- run: mkdocs gh-deploy --force
```
