[![Entangled badge](https://img.shields.io/badge/entangled-Use%20the%20source!-%2300aeff)](https://entangled.github.io/)

# Entangled and MkDocs
This is a setup of Entangled with MkDocs, using:

- highlight.js
- mathjax
- mkdocs-material theme

## Prep

- Install `entangled` following the instructions at [entangled.github.io](https://entangled.github.io/#section-entangled).
- Install the `entangled` Python module by running `pip install entangled-filters`
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

To initiate a MkDocs project, you need a `mkdocs.yml` file. We need to convince MkDocs to accept the code blocks. The `entangled` Python module has functions to aid in this. 

```yaml file="mkdocs.yml"
site_name: Entangled and MkDocs
nav:
        - Home: "index.md"
        - About: "about.md"

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
        highlightjs: true
        palette:
                scheme: "slate"
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
- "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/10.0.3/styles/gruvbox-dark.min.css"
```

```js file="docs/js/init.js"
hljs.initHighlightingOnLoad();
```

## Equations

```yaml id="markdown-extensions"
- pymdownx.arithmatex
```

```yaml id="extra-javascript"
- "https://polyfill.io/v3/polyfill.min.js?features=es6"
- "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"
```

\\[\mathcal{H} = \frac
{nl^2 p_{\theta}^2 + (m + n)k^2 p_{\varphi}^2 - 2nkl p_{\theta} p_{\varphi} \cos(\theta - \varphi)}
{2nk^2l^2 \left(m + n \sin^2(\theta - \varphi)\right)}
- (m + n)gk \cos{\theta} - ngl \cos{\varphi}.
\\]

