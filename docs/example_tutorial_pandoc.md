<img src="./images/logo.sample.png" alt="Logo of the project" align="right">

# A basic pandoc tutorial &middot; [![Build Status](https://img.shields.io/travis/npm/npm/latest.svg?style=flat-square)](https://travis-ci.org/npm/npm) [![npm](https://img.shields.io/npm/v/npm.svg?style=flat-square)](https://www.npmjs.com/package/npm) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/your/your-project/blob/master/LICENSE)
> The swiss-army knife to convert files.

You can convert between this formats:

↔︎ Markdown (including CommonMark and GitHub-flavored Markdown)
↔︎ reStructuredText
→ AsciiDoc
↔︎ Emacs Org-Mode
↔︎ Emacs Muse
↔︎ Textile
← txt2tags


## Installing / Getting started

Installing Pandoc on Debian Ubuntu is very easy.

```sh title="#install_pandoc"
sudo apt install -y pandoc
```

## Converting from markdown to html

As a basic example let's convert this markdown file to html5

```markdown title="file://tutorials/pandoc/hello_world.md"
# Hello World

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean augue neque,
mattis nec mollis id, dictum at purus. Nullam ac justo tempor,
hendrerit nisl sit amet, rutrum ex.

> Aenean iaculis consectetur nisl vel egestas.

```


In pandoc you would write

```bash title="#convert_from_md_to_html5"
pandoc --from=markdown --to=html5 -s ./tutorials/pandoc/hello_world.md -o ./tutorials/pandoc/hello_world.html
```

And then you would have hello_world.html file with the markdown converte to the correct one.

```html title="file://tutorials/pandoc/tests/hello_world.html"
<h1 id="hello-world">Hello World</h1>
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean augue neque, mattis nec mollis id, dictum at purus. Nullam ac justo tempor, hendrerit nisl sit amet, rutrum ex.</p>
<blockquote>
<p>Aenean iaculis consectetur nisl vel egestas.</p>
</blockquote>
```

And with that we conclude the tutorial

---

## Automating the tutorial.

Now what we want is to create script / program that we can automatically execute with the steps we told the user to follow.
A script that looks like this:

```sh title="file://tutorials/pandoc/tests/scripted.test.sh"
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo su

<<install_pandoc>>

<<convert_from_md_to_html5>>

<<verify_output_equal_expected_value>>
```

## How can we very the ouput equals the expected value?

```sh title="#verify_output_equal_expected_value"

if ! cmp ./tutorials/pandoc/hello_world.html ./tutorials/pandoc/tests/hello_world.html 2>&1
then
 echo "The generated hello_world.html is not identical to the expected...."
 exit 1;
fi

```

---

# Monitoring

To avoid documentation rot we need to make sure our tutorial works and continues to work day in and day out.

Finally we need to keep writing this tests at least once a day, to make sure it continues to work.

In order to do that we will use a GitHub Action. GitHub Actions are processes that get executed on GitHub's Servers
when ever there is a push to your source code repository.

```yaml title="file://.github/workflows/monitor_tutorial_tests.yml"
name: Schedule test execution
on:
  schedule:
    - cron: "0 0 * * *"

jobs:
  pull_data:
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
        with:
          persist-credentials: false
          fetch-depth: 0

      - name: Set up Python 3.8
        uses: actions/setup-python@v2
        with:
          python-version: "3.8"

      # Let's execute the testing script
      - name: Execute test scripts for all the tutorials
        run: find ./tutorials/ -name "*.test.sh" | xargs bash
```
