all: build

build: clean generate-favicons
	@hugo --gc

dev-server:
	@if ! ls static/android-chrome* static/apple* static/favicon* static/site.webmanifest >/dev/null 2>&1; then \
		echo -e '\033[1;31mSome favicon or manifest files are missing!\033[0m'; \
		echo 'Run "make generate-favicons" to generate them'; \
		sleep 3; \
	fi

	@hugo server --buildDrafts --buildFuture --disableFastRender

generate-favicons:
	@./favicon/generate_favicons.sh

clean:
	@# Remove Hugo dirs
	@rm -rf .hugo_build.lock public/ resources/

	@# Remove favicons
	@rm static/android-chrome* \
	  static/apple* \
	  static/favicon* \
	  static/site.webmanifest 2>/dev/null || true
