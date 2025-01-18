;; Configure the gcc paths
(setenv "LIBRARY_PATH" (string-join '(
                                      "/opt/local/lib/gcc14/gcc/x86_64-apple-darwin24/14.2.0/"
                                      "/opt/local/lib/gcc14/")
                                    ":"))

;; Adds the MacPorts bin to the exec-path
(add-to-list 'exec-path "/opt/local/bin")

;; Silent errors and reports on native-comp
(setq native-comp-async-report-warnings-errors 'silent)

;;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package with straight.el
(straight-use-package 'use-package)

(setq
 ;; Always use straight.el
 straight-use-package-by-default t
 ;; Backups folder
 backup-directory-alist `(("." . "~/.saves"))
 ;; Backup by copying (safer)
 backup-by-copying t
 ;; Fill Column
 fill-column 80
 ;; Indent to Spaces with insert-tab
 indent-line-function 'insert-tab
 ;; No Splash
 inhibit-startup-screen t
 )

(setq-default
 ;; Indentation
 indent-tabs-mode nil
 tab-width 2)

;; Fonte
(add-to-list 'default-frame-alist
             '(font . "Wumpus Mono Pro-14"))

(use-package time
  :straight nil
  :custom (display-time-mode t))


(use-package paredit
  :hook (prog-mode . paredit-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package plantuml-mode
  :custom plantuml-default-exec-mode 'executable)

(use-package org
  :straight nil
  :config
  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml)))

(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

(use-package counsel
  :diminish counsel-mode
  :config (counsel-mode 1)
  :bind (("C-x C-b" . ivy-switch-buffer)
         ("M-x" . counsel-M-x)
         ("C-x b" . ivy-switch-buffer))
  :custom ((counsel-find-file-at-point t)))

(use-package ivy
  :diminish ivy-mode
  :requires (counsel)
  :config ((ivy-mode 1))
  :custom ((ivy-use-virtual-buffers t)
           (ivy-use-selectable-prompt t)))

(use-package swiper
  :bind ("M-C-s" . swiper))

(use-package ivy-hydra)

(use-package which-key
  :diminish which-key-mode
  :config (which-key-mode 1))

(use-package vertico
  :config (vertico-mode 1))

(use-package marginalia
  :config (marginalia-mode 1))

(use-package diminish)

(use-package clojure-mode)

(use-package cider
  :requires (clojure-mode))

(use-package magit)
