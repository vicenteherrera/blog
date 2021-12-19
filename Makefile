.PHONY: prerequisites serve-watch build install test

all: serve-drafts-watch

prerequisites:
	gem install bundler
	bundle install

serve-watch:
	JEKYLL_ENV=local bundle exec jekyll serve --watch

serve-drafts-watch:
	JEKYLL_ENV=development JEKYLL_LOG_LEVEL=error bundle exec jekyll serve --watch --drafts --unpublished --future \
		--strict_front_matter --verbose --trace

test:
	exit 0

update:
	bundle update