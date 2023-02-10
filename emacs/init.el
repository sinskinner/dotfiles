;;; Functions

(defun memoize (fn)
  (let ((memo (make-hash-table :test 'equal)))
    (lambda (&rest args)
      (let ((value (gethash args memo)))
        (or value (puthash args (apply fn args) memo))))))


(when (and
       (featurep 'ns)
       (equal system-type 'darwin))
  (defun ns-raise-emacs ()
    "Raise Emacs."
    (ns-do-applescript "tell application \"Emacs\" to activate"))
  (defun ns-raise-emacs-with-frame (frame)
    "Raise Emacs and select the provided frame."
    (with-selected-frame frame
      (when (display-graphic-p)
        (ns-raise-emacs))))(add-hook 'after-make-frame-functions 'ns-raise-emacs-with-frame)(when (display-graphic-p)
    (ns-raise-emacs)))

;;; Bootstrap and install straight.el

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(setq use-package-always-ensure t)
(add-to-list 'load-path (file-name-as-directory (expand-file-name "elisp" user-emacs-directory)))

;;; Vanilla Configs

(setq-default
 indent-tabs-mode nil
 load-prefer-newer t
 truncate-lines t
 bidi-paragraph-direction 'left-to-right
 frame-title-format "Emacs"
 auto-window-vscroll nil
 mouse-highlight nil
 hscroll-step 1
 hscroll-margin 1
 scroll-margin 0
 scroll-preserve-screen-position nil
 scroll-conservatively 101
 frame-resize-pixelwise window-system
 window-resize-pixelwise window-system)
(when (window-system)
  (setq-default
   x-gtk-use-system-tooltips nil
   cursor-type 'box
   cursor-in-non-selected-windows nil))
(setq
 inhibit-startup-screen t
 initial-scratch-message nil
 initial-major-mode 'text-mode
 custom-safe-themes t
 ring-bell-function 'ignore
 mode-line-percent-position nil
 enable-recursive-minibuffers t
 custom-file "~/.emacs.d/custom-vars.el"
 backup-directory-alist '(("." . "~/.emacs-backups")))

(defun focus-out-collect-garbage ()
  (unless (frame-focus-state)
    (garbage-collect)))
(add-function :after after-focus-change-function 'focus-out-collect-garbage)

;; Font and Mac Configs
(when (equal system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (when (member "SauceCodePro Nerd Font Mono" (font-family-list))
    (add-to-list 'initial-frame-alist '(font . "SauceCodePro Nerd Font Mono-14"))
    (add-to-list 'default-frame-alist '(font . "SauceCodePro Nerd Font Mono-14")))
  (set-fontset-font t 'symbol (font-spec :family "Apple Symbols") nil 'prepend)
  (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") nil 'prepend))

;; Recent Files Configuration
(use-package recentf
  :custom
  (recentf-max-menu-items 100)
  (recentf-max-saved-items 100)
  :config
  (recentf-mode t))

;;; Packages

(use-package re-builder+)

(use-package display-line-numbers
  :hook (display-line-numbers-mode . toggle-hl-line)
  :custom
  (display-line-numbers-width 4)
  (display-line-numbers-grow-only t)
  (display-line-numbers-width-start t)
  :config
  (defun toggle-hl-line ()
    (hl-line-mode (if display-line-numbers-mode 1 -1))))

(use-package vertico
  :straight t
  :load-path "straight/repos/vertico/extensions/"
  :bind ( :map vertico-map
          ("M-RET" . vertico-exit-input))
  :init
  (vertico-mode))

(use-package marginalia
  :straight t
  :after vertico
  :config
  (marginalia-mode))

(use-package consult
  :straight t
  :preface
  (defvar consult-prefix-map (make-sparse-keymap))
  (fset 'consult-prefix-map consult-prefix-map)
  :bind ( :map ctl-x-map
          ("c" . consult-prefix-map)
          :map consult-prefix-map
          ("r" . consult-recent-file)
          ("o" . consult-outline)
          ("i" . consult-imenu)
          ("g" . consult-grep))
  :custom
  (consult-preview-key nil)
  :init
  (setq completion-in-region-function #'consult-completion-in-region))

(use-package orderless
  :custom
  (completion-styles '(orderless))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package catppuccin-theme
  :straight (:type git
             :host github
             :local-repo "catppuccin-theme"
             :repo "catppuccin/emacs"
             :branch "main")
  :custom (catppuccin-flavor 'mocha)
  :config (load-theme 'catppuccin))

(use-package smartparens
  :config
  (require 'smartparens-config)
  (sp-use-paredit-bindings)
  (progn (show-smartparens-global-mode t))
  :hook
  (prog-mode . smartparens-strict-mode))

(use-package which-key
  :config
  (which-key-mode))

(use-package eglot
  :custom (alchemist-iex-program-name "iex")
  :config
  (add-to-list 'eglot-server-programs '(elixir-mode "elixir-ls"))
  (add-to-list 'eglot-server-programs '(clojure-mode "clj-kondo")))

(use-package company
  :hook
  (prog-mode . company-mode)
  :custom
  (company-idle-delay 0.1)
  (company-minimum-prefix-length 3)
  (company-selection-wrap-around t)
  :bind (:map company-active-map
              ("<return>" . nil)
              ("RET" . nil)
              ("C-<return>" . company-complete-selection)))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package yaml-mode)

(use-package fish-mode)

(use-package magit)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config
  (exec-path-from-shell-initialize))

;;; Elixir

(use-package elixir-mode)

(use-package mix
  :hook (elixir-mode . mix-minor-mode))

;; Clojure

(use-package clojure-mode)

(use-package cider)

;; Project Management

(use-package projectile
  :bind-keymap ("C-c p" . projectile-command-map))

;; Org-Mode

(use-package org-roam
  :config (org-roam-db-autosync-mode t)
  :custom
  (org-roam-directory "~/Documents/org-mode/org-roam"))

(use-package org-download
  :bind
  (:map org-mode-map
        (("s-Y" . org-download-screenshot)
         ("s-y" . org-download-yank)))
  :custom
  (org-download-method 'attach)
  :hook (dired-mode . org-download-enable))

;; Markdown

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode))
