.DEFAULT_GOAL := dev

GIT_VERSION:=$(shell git rev-parse --short HEAD)
export GIT_VERSION
OUT:="../static/${GIT_VERSION}/elm.js"
export OUT

install: 
		@brew install nginx
		@yarn global add elm-review
		@yarn global add elm-format

dev:
		@lsof -ti tcp:8000 | xargs kill -9 | true
		@$(MAKE) copy-template
		@$(MAKE) -C .elm dev & 
		@nginx -c $(PWD)/.dev/nginx.conf -p $(PWD)

fix:
		@$(MAKE) -C .elm fix

copy-template:
		@cat .dev/templates/index.html | sed "s/dev/${GIT_VERSION}/g" | xargs echo > index.html
		@cat .dev/templates/index.html | sed "s/dev/${GIT_VERSION}/g" | xargs echo > contact/index.html
		@cat .dev/templates/index.html | sed "s/dev/${GIT_VERSION}/g" | xargs echo > faq/index.html

build:
		@rm -rf static/*
		@mkdir -p static/${GIT_VERSION}
		@$(MAKE) -C .elm build 
		@$(MAKE) copy-template

publish:
		@$(MAKE) build
		@git add .
		@git commit -m "Publish site update"
