SHELL=/bin/bash
.ONESHELL:
INDEX?=pypi.org

py37:
	virtualenv -p python3.7 --system-site-packages ./$@
	source $@/bin/activate
	pip install --index-url https://$(INDEX)/simple neovim

install: py37
	nvim +PlugInstall +UpdateRemotePlugins
