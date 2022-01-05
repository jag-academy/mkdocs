# ~\~ language=Dockerfile filename=.gitpod.Dockerfile
# ~\~ begin <<docs/index.md|.gitpod.Dockerfile>>[0]
FROM gitpod/workspace-full

# ~\~ begin <<docs/index.md|install_entangled>>[0]
RUN wget https://github.com/entangled/entangled/releases/download/v1.2.4/entangled-1.2.4-x86_64-GNU-Linux.tar.xz && tar --extract --file entangled-1.2.4-x86_64-GNU-Linux.tar.xz && sudo cp -r ./entangled-1.2.4/* /usr/local/
# ~\~ end
# ~\~ begin <<docs/index.md|install_filters>>[0]
RUN sudo pip install entangled-filters
# ~\~ end
# ~\~ begin <<docs/index.md|install_mkdocs>>[0]
RUN sudo pip install mkdocs
# ~\~ end
# ~\~ begin <<docs/index.md|install_mkdocs_material>>[0]
RUN sudo pip install mkdocs-material
# ~\~ end
# ~\~ end
