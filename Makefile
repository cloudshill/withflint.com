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
		@mkdir -p static/${GIT_VERSION}
		@$(MAKE) copy-template
		@$(MAKE) yc
		@$(MAKE) -C ~elm dev & 
		@nginx -c $(PWD)/~dev/nginx.conf -p $(PWD)

fix:
		@$(MAKE) -C ~elm fix

copy-template:
		@cat ~dev/templates/index.html | sed "s/GIT_VERSION/${GIT_VERSION}/g" | xargs echo > index.html
		@cat ~dev/templates/index.html | sed "s/GIT_VERSION/${GIT_VERSION}/g" | xargs echo > contact/index.html
		@cat ~dev/templates/index.html | sed "s/GIT_VERSION/${GIT_VERSION}/g" | xargs echo > faq/index.html
		@cat ~dev/templates/index.html | sed "s/GIT_VERSION/${GIT_VERSION}/g" | xargs echo > careers/index.html

build:
		@rm -rf static/*
		@mkdir -p static/${GIT_VERSION}
		@$(MAKE) -C ~elm build 
		@$(MAKE) copy-template
		@$(MAKE) yc


publish:
		@$(MAKE) build
		@git add .
		@git commit -m "Publish site update"

yc:
		@curl -XGET https://www.ycombinator.com/companies/flint -o static/${GIT_VERSION}/yc.html