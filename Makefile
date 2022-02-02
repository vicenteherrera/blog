.PHONY: prerequisites serve-watch build install test

all: serve-drafts-watch

prerequisites:
	gem install bundler
	bundle install
	$$(MAKE) -s install-imagemagick

install-imagemagick:
	@echo "Installing imagemagick"
	brew install imagemagick ||:
	sudo apt-get update
	sudo apt-get install imagemagick -y

make generate-thumbnails:
	./tools/thumbnails.sh

serve-watch:
	JEKYLL_ENV=local bundle exec jekyll serve --watch

serve-drafts-watch:
	JEKYLL_ENV=development JEKYLL_LOG_LEVEL=error bundle exec jekyll serve --watch --drafts --unpublished --future \
		--strict_front_matter --livereload

# --verbose --trace 

test:
	exit 0

update:
	bundle update