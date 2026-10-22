#!/usr/bin/env bash

BOOK_MAKER_TRIGGER_KEYWORDS=(
  "write me a book"
  "build a book"
  "produce a non-fiction book"
  "generate a book"
  "create a book"
)

if [[ -f "${CLAUDE_PROJECT_DIR:-.}/.book-maker.sh" ]]; then
  source "${CLAUDE_PROJECT_DIR:-.}/.book-maker.sh"
fi
