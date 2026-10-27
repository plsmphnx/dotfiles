;; -*- lexical-binding: t; -*-

;; keybindings
(ergoemacs-mode 1)

;; mouse
(xterm-mouse-mode 1)
(context-menu-mode 1)

;; clipboard
(setq xterm-extra-capabilities '(setSelection getSelection))

;; scrolling
(setq scroll-conservatively 101)

;; treeview
(use-package treemacs
  :ensure t
  :defer t
  :bind (("C-\\" . treemacs))
  :config
  (setq treemacs-width 30
        treemacs-follow-mode t
	treemacs-show-cursor nil)
  (treemacs-project-follow-mode 1)
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))
(add-hook 'emacs-startup-hook #'treemacs)

;; tabs and panes
(global-tab-line-mode 1)
(set-display-table-slot standard-display-table 'vertical-border ?\u2502)
(set-face-foreground 'vertical-border "brightblack")

(use-package corfu
  :ensure t
  :init (global-corfu-mode 1)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.15
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preselect 'prompt))

(use-package treesit-auto
  :config
  (global-treesit-auto-mode))
