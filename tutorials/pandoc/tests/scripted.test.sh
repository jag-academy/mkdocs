# ~\~ language=Shell filename=tutorials/pandoc/tests/scripted.test.sh
# ~\~ begin <<docs/example_tutorial_pandoc.md|tutorials/pandoc/tests/scripted.test.sh>>[0]
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sudo su

# ~\~ begin <<docs/example_tutorial_pandoc.md|install_pandoc>>[0]
sudo apt install -y pandoc
# ~\~ end

# ~\~ begin <<docs/example_tutorial_pandoc.md|convert_from_md_to_html5>>[0]
pandoc --from=markdown --to=html5 -s ./tutorials/pandoc/hello_world.md -o ./tutorials/pandoc/hello_world.html
# ~\~ end

# ~\~ begin <<docs/example_tutorial_pandoc.md|verify_output_equal_expected_value>>[0]

if ! cmp ./tutorials/pandoc/hello_world.html ./tutorials/pandoc/tests/hello_world.html 2>&1
then
 echo "The generated hello_world.html is not identical to the expected...."
 exit 1;
fi

# ~\~ end
# ~\~ end
