EMACS=emacs

HASKELL_MODE_DIR="/home/sergey/emacs/third-party/haskell-mode/"
ORG_REVEAL_DIR="/home/sergey/emacs/third-party/org-reveal/"

BATCH=$(EMACS) --batch --no-init-file                                   \
  --directory "$(HASKELL_MODE_DIR)"                                     \
  --directory "$(ORG_REVEAL_DIR)"                                       \
  --eval '(require (quote org))'                                        \
  --eval '(require (quote ob))'                                         \
  --eval '(require (quote ob-tangle))'                                  \
  --eval '(require (quote ox-reveal))'                                  \
  --eval '(require (quote haskell-mode))'                               \
  --eval "(org-babel-do-load-languages 'org-babel-load-languages        \
            '((haskell . t)))"                                          \
  --eval "(setq org-confirm-babel-evaluate nil)"                        \
  --eval '(setq starter-kit-dir default-directory)'

  # --eval '(org-babel-tangle-file "README.org")'                         \
  # --eval '(org-babel-load-file   "README.org")'

.PHONY: all clean

all: talk.html Talk.hs

Talk.hs: talk.org
	$(BATCH) --visit '$^' -f org-babel-tangle

talk.html: talk.org
	$(BATCH) --visit '$^' -f org-reveal-export-to-html

check: Talk.hs
	ghc -fno-code -Wall $<

# --highlight-style=haddock
opts = --slide-level=2 --highlight-style=kate -V theme=white -V progress=true -V keyboard=true -V overview=true -V fragments=true -V history=true

talk.md.html: talk.exported.md
	pandoc --standalone --self-contained --to revealjs $(opts) $< --output $@


# --eval '(org-babel-tangle-file "$^")'

clean:
	rm -f talk.html
	rm -f Talk.hs

# soffice --headless --convert-to png --outdir "xxx" "test.txt"

# $(BATCH) --eval '(progn (find-file "$^") (org-babel-tangle))'

# all: talk.html talk.pdf
#
# talk = talk.md
# deps = $(talk)
# opts = --highlight-style=haddock --slide-level=2
# #--from markdown_strict
#
# clean:
# 	rm -f talk.html
# 	rm -f talk.pdf
#
# #  --variable transition="concave"
# # --variable revealjs-url=fo
#
# # --variable theme="solarized"
#
# talk.md.html: $(deps)
# 	pandoc --standalone --self-contained --to revealjs $(opts) $(talk) --output $@
#
# # s5, slidy, slideous, dzslides, revealjs
#
# talk.pdf: $(deps)
# 	pandoc --to beamer $(opts) $(talk) --output $@
