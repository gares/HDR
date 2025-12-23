

slides.pdf: slides.md Makefile
	npm exec slidev -- export --with-clicks --format png --output slides.png/
	convert slides.png/*.png slides.pdf
	rm -rf slides.png/

html: slides.md Makefile
	npm exec slidev -- build --out html --base /members/Enrico.Tassi/hdr/html/

upload: slides.pdf html index.html
	scp -Cr  roquableu.inria.fr:/net/servers/www-sop/members/Enrico.Tassi/hdr/
	@echo
	@echo 'https://www-sop.inria.fr/members/Enrico.Tassi/'
