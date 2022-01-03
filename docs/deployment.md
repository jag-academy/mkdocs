# Continuouns Integration

In order to deploy this document there are two things that must happen: tangling and weaving

Tanglin means extract the code blocks from the markdown documents and create new source file from them. Using entangled

weaving in this context means publish the markdown documents to a gh pages site using mkdocs.

# Weaving.
I took  this material from [mkdocs-material](https://squidfunk.github.io/mkdocs-material/publishing-your-site/#github-pages)

## GitHub Pages

If you're already hosting your code on GitHub, [GitHub Pages] is certainly
the most convenient way to publish your project documentation. It's free of
charge and pretty easy to set up.

  [GitHub Pages]: https://pages.github.com/

### with GitHub Actions

Using [GitHub Actions] you can automate the deployment of your project
documentation. At the root of your repository, create a new GitHub Actions
workflow, e.g. `.github/workflows/ci.yml`, and copy and paste the following
contents:

=== "Material for MkDocs"

    ```yaml title="file://.github/workflows/ci.yml"
    name: ci # (1)!
    on:
      push:
        branches: # (2)!
          - master
          - main
    jobs:
      deploy:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v2
          - uses: actions/setup-python@v2
            with:
              python-version: 3.x
          - run: pip install mkdocs-material # (3)!
          - run: mkdocs gh-deploy --force
    ```

    1.  You can change the name to your liking. 

    2.  At some point, GitHub renamed `master` to `main`. If your default branch
        is named `master`, you can safely remove `main`, vice versa.

    3.  This is the place to install further [MkDocs plugins] or Markdown
        extensions with `pip` to be used during the build:

        ``` sh
        pip install \
          mkdocs-material \
          mkdocs-awesome-pages-plugin \
          ...
        ```
