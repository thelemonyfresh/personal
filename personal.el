;;; Personal init.el file for daniel porter (dp@danielporter.ca)
;;;
;;; loaded from .emacs.d/init.el by Prelude
;;;
;;; References:
;;; -https://github.com/bbatsov/prelude
;;; -http://tuhdo.github.io/helm-intro.html
;;;

;; Include MELPA in package-archive
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
;; Set the maximum line length to 100 chars [whitespace]
(setq whitespace-line-column 100)

;; HELM configuration for prelude
(helm-autoresize-mode t)
(require 'prelude-helm-everywhere)

;; Turn off flyspell
(setq prelude-flyspell nil)

;; disable scroll, menu, tool bars
(scroll-bar-mode -1)

;; enable line numbering for programming buffers
(add-hook 'prog-mode-hook 'linum-mode)

;; enable line numbering globally
;;(global-linum-mode t)

;; but disable for org mode
;; (defun nolinum ()
;;   (global-linum-mode 0)
;;   (linum-mode 0)
;;   )
;; (add-hook 'org-mode-hook 'nolinum)

;; Open new files in the existing window
(setq ns-pop-up-frames nil)

;; remove encoding magic for non-ascii files
;; http://stackoverflow.com/questions/6453955/how-do-i-prevent-emacs-from-adding-coding-information-in-the-first-line
(setq ruby-insert-encoding-magic-comment nil)

;; rvm.el -- integrate emacs with ruby version manager [https://github.com/senny/rvm.el]
(require 'rvm)
(rvm-use-default)

;; hook for robe mode (https://github.com/dgutov/robe)
(add-hook 'ruby-mode-hook 'robe-mode)
(add-hook 'robe-mode-hook 'ac-robe-setup) ; auto_complete hook
(defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
  (rvm-activate-corresponding-ruby)) ; activate rvm before robe

;; rainbow-delimiters-mode require and hook for programming
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; hook projectile-ruby into projectile
(add-hook 'projectile-mode-hook 'projectile-rails-on)

;; use caching to speed up projectile
(setq projectile-enable-caching t)

;; configure highlight-indent-guides mode
;;  https://github.com/DarthFennec/highlight-indent-guides
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'fill)

;; Set up sonic_pi.el (https://github.com/repl-electric/sonic-pi.el)
;;(add-to-list 'load-path "~/.sonic-pi.el/")
;;(setq sonic-pi-path "/Users/daniel/src/sonicpi/sonic-pi/app/") ; Must end with "/"
;; Optionally define a hook
;; (add-hook 'sonic-pi-mode-hook
;;           (lambda ()
;;             (define-key ruby-mode-map "\C-c\C-b" 'sonic-pi-stop-all)))

;; https://github.com/stsquad/emacs_chrome
;; (require 'edit-server)
;; (edit-server-start)

;; Remove keybindings for move-text.el (interrupts org mode org-xxx-subtree-xxx)
;; http://stackoverflow.com/questions/34652692/how-to-turn-off-company-mode-in-org-mode
;; DISABLE THE FOLLOWING in prelude-mode.el
;;    (define-key map [(meta shift up)]  'move-text-up)
;;    (define-key map [(meta shift down)]  'move-text-down)

;; disable flycheck for files > 1000 lines
(add-hook 'prog-mode-hook
          (lambda ()
            (when (> (buffer-size) 1000)
              (flycheck-mode -1))))

;; set default tab-width to 2 spaces (https://www.emacswiki.org/emacs/IndentationBasics)
(setq tab-width 2)
(setq js-indent-level 2)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-block-padding 2)

;; org-mode wrap lines
(setq org-startup-truncated nil)

;; org capture templates
(define-key global-map "\C-cc" 'org-capture)
(setq org-capture-templates
      '(
        ("p" "personal" entry (file+headline "~/org/personal.org" "personal#scratch")
         "* %U ")
        ("c" "code" entry (file+headline "~/org/code.org" "code#scratch")
         "* %U ")
        ("m" "music" entry (file+headline "~/org/music.org" "music#scratch")
         "* %U ")
        ("r" "research" entry (file+headline "~/org/research.org" "research#scratch")
         "* %U ")
        ("w" "work" entry (file+headline "~/org/work.org" "work#scratch")
         "* %U ")
        ("g" "Cookbook" entry (file "~/src/org/cookbook.org")
         "%(org-chef-get-recipe-from-url)"
         :empty-lines 1)
        ("f" "Manual Cookbook" entry (file "~/src/org/cookbook.org")
         "* %^{Recipe title: }\n  :PROPERTIES:\n  :source-url:\n  :servings:\n  :prep-time:\n  :cook-time:\n  :ready-in:\n  :END:\n** Ingredients\n   %?\n** Directions\n\n")
        )
      )
;; set shortcuts to org files
(global-set-key (kbd "C-c M-o s")
                (lambda () (interactive) (find-file "~/src/org/sciex.org")))
(global-set-key (kbd "C-c M-o p")
                (lambda () (interactive) (find-file "~/src/org/personal.org")))
(global-set-key (kbd "C-c M-o c")
                (lambda () (interactive) (find-file "~/src/org/code.org")))
(global-set-key (kbd "C-c M-o w")
                (lambda () (interactive) (find-file "~/src/org/work.org")))
(global-set-key (kbd "C-c M-o r")
                (lambda () (interactive) (find-file "~/src/org/research.org")))
(global-set-key (kbd "C-c M-o m")
                (lambda () (interactive) (find-file "~/src/org/music.org")))

;; org TODO state workflows
(setq org-todo-keywords
      '((sequence "TODO" "BLOCKED" "|" "DONE")))

;; set company mode from being so annoying
(setq company-idle-delay 2)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; do not add newlines
(setq require-final-newline nil)

;; rubocop
(require 'rubocop)
(require 'rubocopfmt)
(add-hook 'ruby-mode-hook 'rubocopfmt-mode) ;; hook into ruby mode
(setq rubocopfmt-use-bundler-when-possible nil) ;; don't require rubocop in bundle

;; multiple cursor mode https://github.com/magnars/multiple-cursors.el
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; react mode, rjsx major mode
(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

;; Swiper use fancy colors http://pragmaticemacs.com/emacs/dont-search-swipe/
(setq ivy-display-style 'fancy)

;; org chef mode https://github.com/Chobbes/org-chef
(require 'org-chef)
