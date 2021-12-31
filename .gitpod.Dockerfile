    FROM gitpod/workspace-base

    RUN sudo apt-get update && sudo apt-get install -y haskell-platform
    RUN sudo curl -sSL https://get.haskellstack.org/ | sh
    RUN sudo apt-get install -y nodejs npm
    RUN wget https://github.com/jgm/pandoc/releases/download/2.9.2.1/pandoc-2.9.2.1-1-amd64.deb && sudo dpkg -i pandoc-2.9.2.1-1-amd64.deb
    RUN sudo apt-get install -y inotify-tools
    RUN sudo apt-get install -y tmux
    RUN sudo apt-get install -y python3-pip
    RUN sudo pip install entangled-filters
    RUN sudo pip install cookiecutter

    RUN wget https://github.com/dhall-lang/dhall-haskell/releases/download/1.40.2/dhall-json-1.7.9-x86_64-linux.tar.bz2 && tar --extract --bzip2 --file ./dhall-json-1.7.9-x86_64-linux.tar.bz2 && sudo cp ./bin/dhall-to-json /usr/local/bin/
    RUN wget https://github.com/entangled/entangled/releases/download/v1.2.4/entangled-1.2.4-x86_64-GNU-Linux.tar.xz && tar --extract --file entangled-1.2.4-x86_64-GNU-Linux.tar.xz && sudo cp -r ./entangled-1.2.4/* /usr/local/
