[![Entangled badge](https://img.shields.io/badge/entangled-Use%20the%20source!-%2300aeff)](https://entangled.github.io/)

# Entangled and MkDocs
This is a setup of Entangled with MkDocs, using:

- mkdocs-material theme (which is almost a cms)
- mathjax


## Prep

- Install `entangled` (&ge; 1.2) following the instructions at [entangled.github.io](https://entangled.github.io/#section-entangled).

```dockerfile title="#install_entangled"
RUN wget https://github.com/entangled/entangled/releases/download/v1.2.4/entangled-1.2.4-x86_64-GNU-Linux.tar.xz && tar --extract --file entangled-1.2.4-x86_64-GNU-Linux.tar.xz && sudo cp -r ./entangled-1.2.4/* /usr/local/
```

- Install the `entangled-filters` Python module (&ge; 0.7)

```dockerfile title="#install_filters"
RUN sudo pip install entangled-filters
```

- Install `mkdocs`

```dockerfile title="#install_mkdocs"
RUN sudo pip install mkdocs
```

- Install material theme

```dockerfile title="#install_mkdocs_material"
RUN sudo pip install mkdocs-material
```

### This could be setup in a docker file with this structure

```dockerfile title="file://.gitpod.Dockerfile"
FROM gitpod/workspace-full

<<install_entangled>>
<<install_filters>>
<<install_mkdocs>>
<<install_mkdocs_material>>
```



## Starting a project
To run Entangled we need a `entangled.dhall` configuration file. The following command generates a file that you can edit to suit your needs.

```bash
entangled config > entangled.dhall
```

We have our Markdown inside the `docs` folder, so you'll need to set the `watchList` variable to `[ "docs/**/*.md" ]`.

```dhall
let watchList = [ "docs/**/*.md" ]
```

In this project we use a different Markdown syntax than is standard with Entangled.

~~~markdown
```cpp title="file://src/hello.cc"

```

```cpp title="#print-hello"

```
~~~

To match these code blocks, we need to change the `syntax` value in the configuration.

```dhall
let syntax : entangled.Syntax =
    { matchCodeStart       = "^[ ]*```[[:alpha:]]+"
    , matchCodeEnd         = "^[ ]*```"
    , extractLanguage      = "```([[:alpha:]]+)"
    , extractReferenceName = "```[[:alpha:]]+[ ]+.*id=\"([^\"]*)\".*"
    , extractFileName      = "```[[:alpha:]]+[ ]+.*file=\"([^\"]*)\".*"
    }
```

To initiate a MkDocs project, you need a `mkdocs.yml` file. This contains the meta-data of the site,

```yaml title="file://mkdocs.yml"
nav:
        - Home: "index.md"
        - Documentation Rot: "doc_rot.md"
        - An example tutorial: "example_tutorial_pandoc.md"
        - About: "about.md"
        - Experiments: "syntax_experiments.md"
        - Deployment: "deployment.md"
site_name: TODO insert your site name
site_url: https://TODO.github.io/_project_name
repo_url: https://github.com/TODO/mkdocs
site_description: >
        TODO describe your site
site_author: TODO your name
copyright: TODO your organization's name
```

and the configuration

```yaml title="file://mkdocs.yml"
<<theme>>

markdown_extensions:
        <<markdown-extensions>>
        - admonition
        - toc:
            permalink: true

extra_css:
        <<extra-css>>

extra_javascript:
        <<extra-javascript>>
```

## Material theme
Install the material theme with `pip install mkdocs-material`

```yaml title="#theme"
theme:
        name: material
```

## Annotating code blocks
The `entangled-filters` module, while mainly dedicated to Pandoc support, has a few functions to help us pass metadata through `mkdocs`. By default, `mkdocs` will not allow any extra attributes to be added to the code blocks. We need to configure `pymdownx.superfences` extension to get what we need.

```yaml title="#markdown-extensions"
- pymdownx.highlight:
    anchor_linenums: true
- pymdownx.inlinehilite
- pymdownx.snippets
- pymdownx.superfences
```

## Highlighting
To enable syntax highlighting you need to configure `highlight.js`.

```yaml title="#extra-css"

```


## Equations
Here's everything we know about gravity

\\[G_{\mu\nu} + \Lambda g_{\mu\nu} = \frac{8\pi G}{c^4} T_{\mu\nu}\\]

```yaml title="#markdown-extensions"
- pymdownx.arithmatex
```

```yaml title="#extra-javascript"
- "https://polyfill.io/v3/polyfill.min.js?features=es6"
- "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"
```
