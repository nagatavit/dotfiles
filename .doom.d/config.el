;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Vitor Nagata"
      user-mail-address "nagatavit@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Input Mono Compressed" :size 13)
      doom-variable-pitch-font (font-spec :family "SFNS Display" :size 10))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'dracula)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(when (display-graphic-p)
  (custom-set-faces
   '(highlight ((t (:background "orange" :foreground "black"))))
   ;; '(bold ((t (:foreground "orange" :weight bold))))
   ;; '(font-lock-comment-face ((t (:foreground "#9acd32"))))
   ;; '(default ((t (:inherit nil :stipple nil :background "#131417" :foreground "#f8f8f2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width extra-condensed :foundry "FBI " :family "Input Mono Compressed"))))
   '(show-paren-match ((t (:background "orange" :foreground "black" :weight extra-bold))))

   ;; Org mode
   '(org-level-1 ((t (:inherit outline-1 :height 1.15))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.1))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.05))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
   ;; '(org-hide ((t (:background "#131417" :foreground "#131417"))))
   ;; '(org-agenda-date ((t (:inherit org-agenda-date :background "gray4" :foreground "ForestGreen"))))
   ;; '(org-agenda-date-today ((t (:inherit org-agenda-date :background "orange" :foreground "#300b66"))))
   ;; '(org-agenda-date-weekend ((t (:inherit org-agenda-date :background "#97BC62" :foreground "NavyBlue"))))
   '(org-block-begin-line ((t (:foreground "#9acd32" :background "#3d4551"))))
   '(org-block-end-line ((t (:foreground "#9acd32" :background "#3d4551"))))
   ;; '(org-verbatim ((t (:inherit shadow :foreground "DarkGoldenrod1" :box (:line-width 1 :color "grey75" :style pressed-button)))))
   ;; '(org-roam-link ((t (:inherit org-link :foreground "dark orange"))))
   ;; '(org-list-dt ((t (:foreground "#105fff" :weight bold))))
   )
  )

(use-package rainbow-mode
  :hook
  (prog-mode . rainbow-mode))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(custom-theme-set-faces! 'dracula
  '(mode-line :background "#0a2832" :box '(:line-width 0.5 :style released-button))
  '(mode-line-inactive :background "gray4" :box '(:line-width 0.5 :style released-button))
  )

(setq doom-modeline-height 5)

;; Removes *Completions* from buffer after you've opened a file.
(add-hook 'minibuffer-exit-hook
          '(lambda ()
             (let ((buffer "*Completions*"))
               (and (get-buffer buffer)
                    (kill-buffer buffer)))))

;; IDO-style directory navigation (for ivy)
(after! ivy
  (define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)
  (dolist (k '("C-j" "C-RET"))
    (define-key ivy-minibuffer-map (kbd k) #'ivy-immediate-done))
  )

(global-set-key (kbd "C-x k") 'kill-current-buffer)

(global-set-key (kbd "C-q") 'er/expand-region)

(global-set-key (kbd "C-c c p") 'insert-parentheses)
(global-set-key (kbd "C-c d") 'duplicate-line)
(global-set-key (kbd "C-c c r") 'replace-string)
(global-set-key (kbd "C-c c R") 'query-replace)
(global-set-key (kbd "C-c c ç") 'org-capture)

(global-set-key (kbd "C-ç") 'other-window)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-w") 'kill-region-or-backward-word)

(global-set-key (kbd "M-p") 'move-line-up)
(global-set-key (kbd "M-n") 'move-line-down)
(global-set-key (kbd "M-s") 'avy-goto-char)
(global-set-key "\C-x\C-m" 'compile)

(global-set-key (kbd "C-c u") 'dumb-jump-go)
(global-set-key (kbd "C-c x o") 'xref-find-definitions)
(global-set-key (kbd "C-c x j") 'xref-find-references)
(global-set-key (kbd "C-M-p") 'xref-pop-marker-stack)

(global-set-key (kbd "C-,") 'undo-fu-only-redo)

(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (other-window 1)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (other-window 1)))

;;----------------------------------------------------------------------------
;; Proper C-w behavior (borrowed from https://stackoverflow.com/a/14047437/3581311)
;;----------------------------------------------------------------------------
(defun kill-region-or-backward-word ()
  "If the region is active and non-empty, call `kill-region'.
Otherwise, call `backward-kill-word'."
  (interactive)
  (call-interactively
   (if (use-region-p) 'kill-region 'backward-kill-word)))

;;----------------------------------------------------------------------------
;; duplicate line
;;----------------------------------------------------------------------------
(defun duplicate-line()
  "Duplicate current line."
  (interactive)
  (let (sline)
    (setq sline (buffer-substring (point-at-bol) (point-at-eol)))
    (end-of-line)
    (newline)
    (insert sline)))

;;----------------------------------------------------------------------------
;; Move the current line up (and down)
;;----------------------------------------------------------------------------
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))
(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

;;----------------------------------------------------------------------------
;; Insert pairs: insert a pair from the arguments. If the region is selected
;; put the pair around the region.
;;----------------------------------------------------------------------------
(defun my-insert-pair (open close)
  (if (region-active-p)
      (progn
        (let* ((mark-start (region-beginning))
               (mark-end (region-end)))
          (goto-char mark-end)
          (insert close)
          (goto-char mark-start)
          (insert open)))
    (insert open close))
  (backward-char))

;; Double quotes insertion
(defun insert-double-quotes()
  (interactive)
  (my-insert-pair  "\"" "\""))

;;----------------------------------------------------------------------------
;; Curly brackets insertion
;;----------------------------------------------------------------------------
(defun insert-curly-braces()
  (interactive)
  (end-of-line)
  (insert " {")
  (indent-according-to-mode)
  (newline)
  (indent-according-to-mode)
  (newline)
  (insert "}")
  (indent-according-to-mode)
  (forward-line -1)
  (end-of-line))

(after! dired
  (setq dired-listing-switches "-aBhl  --group-directories-first"
        dired-dwim-target t
        dired-recursive-copies (quote always)
        dired-recursive-deletes (quote top)))

(use-package! dired-narrow
  :commands (dired-narrow-fuzzy)
  :init
  (map! :map dired-mode-map
        :desc "narrow" "/" #'dired-narrow-fuzzy))

(use-package! git-link
  :commands
  (git-link git-link-commit git-link-homepage)
  :custom
  (git-link-use-commit t))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Org/"
      org-ellipsis "⬎"
      org-adapt-indentation nil
      org-archive-location (concat "archive/" "%s_archive::")
      org-log-into-drawer t
      )

(use-package org-bullets
  :init
  (setq org-bullets-bullet-list
        '("⬢" "✤" "◉" "❄" "✧" "▶" "◆" "✿" "✸"))
  :hook
  (org-mode . org-bullets-mode))

(use-package org-fragtog
  :hook
  (org-mode . org-fragtog-mode))

(use-package org-download)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ORG ROAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-roam-directory "~/Org/roam/")

(use-package! org-roam
  :commands (org-roam-insert org-roam-find-file org-roam-switch-to-buffer org-roam)
  :hook
  (after-init . org-roam-mode)
  :init
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
        :desc "org-roam-find-file" "f" #'org-roam-find-file
        :desc "org-roam-show-graph" "g" #'org-roam-show-graph
        :desc "org-roam-jump-to-index" "k" #'org-roam-jump-to-index
        :desc "org-roam-capture" "ç" #'org-roam-capture)
  (setq org-roam-directory (file-truename "~/Org/roam")
        org-roam-db-location "~/Org/roam/org-roam.db"
        org-roam-index-file "~/Org/roam/20200522064155-index.org"
        org-roam-db-gc-threshold most-positive-fixnum
        org-roam-graph-exclude-matcher '("Index")
        org-roam-buffer-width 0.3
        org-roam-tag-sources '(prop last-directory)
        org-id-link-to-org-use-id t)
  :config
  (setq org-roam-capture-templates
        '(("d" "default" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "%<%Y%m%d%H%M%S>-${slug}"
           :head "#+TITLE: ${title}
#+ROAM_ALIAS:
#+DATE: %u\n
- tags :: \n\n"
           :unnarrowed t)
          ("c" "concept" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "concepts/${slug}"
           :head "#+TITLE: ${title}
#+ROAM_ALIAS:
#+DATE: %u\n
- tags :: \n\n"
           :unnarrowed t)
          ("p" "private" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "private/${slug}"
           :head "#+title: ${title}\n"
           :unnarrowed t)))
  (setq org-roam-capture-ref-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "websites/%<%Y%m%d%H%M%S>-${slug}"
           :head "#+TITLE: ${title}
#+ROAM_KEY: ${ref}\n
- tags ::  [[file:../20200526100421-web_captures.org][Web Captures]]
- source :: ${ref}\n\n"
           :unnarrowed t)))

  )

(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Org/roam"))

(after! (org-roam)
  (winner-mode +1)
  (map! :map winner-mode-map
        "<M-right>" #'winner-redo
        "<M-left>" #'winner-undo)
  (org-roam-server-mode))

(use-package org-journal
  :bind
  ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-dir "~/Org/roam/journal")
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-date-format "%A, %d %B %Y"))
;; (setq org-journal-enable-agenda-integration t)

(use-package company
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  (setq company-dabbrev-downcase nil)
  (setq company-show-numbers t))

(use-package company-org-roam
  :config
  (set-company-backend! 'org-mode '(company-org-roam company-yasnippet company-dabbrev)))
  ;; (push 'company-org-roam company-backends))

(after! org-journal
  (set-company-backend! 'org-journal-mode 'company-org-roam))

(use-package! org-roam-protocol
  :after org-protocol)

(use-package org-roam-server
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))

(defun spell (language)
  "Enable flyspell in this buffer for LANGUAGE as en or pt."
  (interactive "sLanguage: ")
  (if (string= "pt" language)
      (progn
        (ispell-change-dictionary "pt_BR")
        (spell-fu-mode 0)
        (flyspell-mode 1)))
  (if (string= "en" language)
      (progn
        (ispell-change-dictionary "en_US")
        (spell-fu-mode 1)))
  (if (string= "" language)
      (spell-fu-mode 0)
    )
  )

(use-package magit
  :config
  (setq git-commit-summary-max-length 50)
  :bind
  ("C-x g" . magit-status))

(add-hook 'git-commit-mode-hook #'(lambda ()
                                    (ispell-change-dictionary "en_US")
                                    (flyspell-mode)))
