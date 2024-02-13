#!/usr/bin/env bash

if [[ "$BLOCK_FORMAT" == 1 ]]; then
  cp "./style_block.css" "$CSS_BOOK_PATH"
  else
  cp "./style_inline.css" "$CSS_BOOK_PATH"
fi

ebook-convert "$HTML_BOOK_PATH" "$EPUB_BOOK_PATH" --embed-all-fonts --epub-toc-at-end --chapter-mark both --level1-toc "//h:h2" --epub-inline-toc --no-default-epub-cover 1> /dev/null