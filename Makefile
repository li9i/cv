THUMBS = build/thumbnails
MKTHUMB = build/tools/mkthumb.sh

# Regenerates the README thumbnails from the current PDFs. Needs poppler-utils
# and imagemagick.
thumbs:
	mkdir -p $(THUMBS)
	$(MKTHUMB) versions/calling-card/cv_card_alexandros_filotheou.pdf   $(THUMBS)/calling-card.png
	$(MKTHUMB) versions/compact/cv_compact_alexandros_filotheou.pdf     $(THUMBS)/compact.png
	$(MKTHUMB) versions/extended/cv_extended_alexandros_filotheou.pdf   $(THUMBS)/extended.png
	$(MKTHUMB) versions/σύντομο/cv_compact_alexandros_filotheou.pdf     $(THUMBS)/syntomo.png
	$(MKTHUMB) versions/αναλυτικό/cv_extended_alexandros_filotheou.pdf  $(THUMBS)/analytiko.png

.PHONY: thumbs
