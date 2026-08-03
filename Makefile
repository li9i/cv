THUMBS = assets/thumbnails
MKTHUMB = tools/mkthumb.sh

# Regenerates the README thumbnails from the current PDFs. Needs poppler-utils
# and imagemagick.
thumbs:
	mkdir -p $(THUMBS)
	$(MKTHUMB) calling-card/cv_card_alexandros_filotheou.pdf   $(THUMBS)/calling-card.png
	$(MKTHUMB) compact/cv_compact_alexandros_filotheou.pdf     $(THUMBS)/compact.png
	$(MKTHUMB) extended/cv_extended_alexandros_filotheou.pdf   $(THUMBS)/extended.png
	$(MKTHUMB) σύντομο/cv_compact_alexandros_filotheou.pdf     $(THUMBS)/syntomo.png
	$(MKTHUMB) αναλυτικό/cv_extended_alexandros_filotheou.pdf  $(THUMBS)/analytiko.png

.PHONY: thumbs
