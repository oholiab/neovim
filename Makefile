SHELL=/bin/bash
.ONESHELL:
INDEX?=pypi.org
REGISTRY?=https://registry.npmjs.org
PYTHON?=py3

.PHONY: install clean npmbullshit
default: install

npmbullshit:
	mkdir "${HOME}/.npm-packages"
	npm config set prefix "${HOME}/.npm-packages"
	npm config set coc.nvim:registry $(REGISTRY)
	npm i -g vim-language-server
	npm i -g pyright

$(PYTHON):
	virtualenv -p python3 ./$@
	source $@/bin/activate
	pip install --index-url https://$(INDEX)/simple pynvim

install: npmbullshit
	nvim +PlugInstall +UpdateRemotePlugins

clean:
	rm -rf $(HOME)/.nvim/plugged $(HOME)/.local/share/nvim/* $(HOME)/.cache/nvim/* $(PYTHON)
