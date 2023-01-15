;;; early-init.el
;;; based on https://github.com/andreyorst/dotfiles/


;;; Early Configuration

(setq
 gc-cons-threshold most-positive-fixnum
 read-process-output-max (* 1024 1024 4) ; 4mb
 inhibit-compacting-font-caches t
 message-log-max 16384
 package-enable-at-startup nil
 load-prefer-newer noninteractive)

;;; Window

(setq-default
 default-frame-alist '((width . 170)
                       (height . 56)
                       (tool-bar-lines . 0)
                       (bottom-divider-width . 0)
                       (right-divider-width . 1))
 initial-frame-alist initial-frame-alist
 frame-inhibit-implied-resize t
 x-gtk-resize-child-frames 'resize-mode
 fringe-indicator-alist (assq-delete-all 'truncation fringe-indicator-alist))

(unless (or (daemonp) noninteractive)
  (when (fboundp #'tool-bar-mode)
    (tool-bar-mode -1))

  (when (fboundp #'scroll-bar-mode)
    (scroll-bar-mode -1)))

;;; Native Compilation

(when (featurep 'native-compile)
  (defvar native-comp-deferred-compilation)
  (setq native-comp-deferred-compilation t)
  (defvar native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors nil))

;;; Straight

(defvar straight-process-buffer)
(setq-default straight-process-buffer " *straight-process*")

(defvar straight-build-dir)
(setq straight-build-dir (format "build-%s" emacs-version))
