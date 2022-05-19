SHELL=/bin/bash
.ONESHELL:
INDEX?=pypi.org

.PHONY: install clean
default: install

py37:
	virtualenv -p python3.7 ./$@
	source $@/bin/activate
	pip install --index-url https://$(INDEX)/simple pynvim==0.4.3

install: py37
	nvim +PlugInstall +UpdateRemotePlugins

clean:
	rm -rf $(HOME)/.nvim/plugged $(HOME)/.local/share/nvim/* $(HOME)/.cache/nvim/* py37
