.PHONY: prerequisites serve-watch build install test

all: serve-drafts-watch

prerequisites:
	gem install bundler
	bundle install

serve-watch:
	bundle exec jekyll serve --watch

serve-drafts-watch:
	bundle exec jekyll serve --watch --drafts --unpublished --future

test:
	exit 0

update:
	bundle update