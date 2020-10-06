SHELL=/bin/bash
.ONESHELL:

py37:
	virtualenv -p python3.7 --system-site-packages ./$@
	source $@/bin/activate
	pip install --index-url https://pypi.org/simple neovim
