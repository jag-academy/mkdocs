[![Entangled badge](https://img.shields.io/badge/entangled-Use%20the%20source!-%2300aeff)](https://entangled.github.io/)

# Entangled and MkDocs
This is a setup of Entangled with MkDocs, using:

- highlight.js
- mathjax
- mkdocs-material theme

## Prep

- Install `entangled` (&ge; 1.2) following the instructions at [entangled.github.io](https://entangled.github.io/#section-entangled).
- Install the `entangled-filters` Python module (&ge; 0.7) by running `pip install entangled-filters`
- Install `mkdocs` by running `pip install mkdocs`
- Install material theme `pip install mkdocs-material`

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
```cpp file="src/hello.cc"
```

```cpp id="print-hello"
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

```yaml file="mkdocs.yml"
site_name: Entangled and MkDocs
nav:
        - Home: "index.md"
        - About: "about.md"
site_url: https://entangled.github.io/mkdocs
repo_url: https://github.com/entangled/mkdocs
site_description: >
        Setup an MkDocs project that works with Entangled for Literate Programming.
site_author: Johan Hidding
copyright: "<a href=\"https://esciencecenter.nl/\">Netherlands eScience Center</a>"
```

and the configuration

```yaml file="mkdocs.yml"
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

```yaml id="theme"
theme:
        name: "material"
        palette:
                primary: "light blue"
        #        scheme: "slate"
```

## Annotating code blocks
The `entangled-filters` module, while mainly dedicated to Pandoc support, has a few functions to help us pass metadata through `mkdocs`. By default, `mkdocs` will not allow any extra attributes to be added to the code blocks. We need to configure `pymdownx.superfences` extension to get what we need.

```yaml id="markdown-extensions"
- pymdownx.superfences:
    custom_fences:
       - name: "*"
         class: "codehilite"
         format: !!python/name:entangled.pymd.format
         validator: !!python/name:entangled.pymd.validator
```

## Highlighting
To enable syntax highlighting you need to configure `highlight.js`.

```yaml id="extra-javascript"
- "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.0.3/highlight.min.js"
- js/init.js
```

```yaml id="extra-css"
- "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.0.3/styles/gruvbox-light.min.css"
```

```js file="docs/js/init.js"
hljs.initHighlightingOnLoad();
```

## Equations
Here's everything we know about gravity

\\[G_{\mu\nu} + \Lambda g_{\mu\nu} = \frac{8\pi G}{c^4} T_{\mu\nu}\\]

```yaml id="markdown-extensions"
- pymdownx.arithmatex
```

```yaml id="extra-javascript"
- "https://polyfill.io/v3/polyfill.min.js?features=es6"
- "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"
```

