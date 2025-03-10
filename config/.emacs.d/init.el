;; Except for packages, this config is generally procedural

;; Startup 
(setq inhibit-startup-message t)
(setq debug-on-error t)

;; General looks setups
(scroll-bar-mode -1)  ; Disable visible scrollbar
(tool-bar-mode -1)  ; Disable the toolbar
(tooltip-mode -1)  ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room
(set-face-attribute 'default nil :height 120)

;; configuration of basic settings for certain modes
;; column-number-setup
(column-number-mode)
(global-display-line-numbers-mode t)
;;Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups" user-emacs-directory))))
;; auto-save-mode doesn't create path automatically
(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))

;; (set-face-font 'variable-pitch "EtBembo")
;; (setq-default line-spacing 0.1)

;;(setq package-archives
;;      '(("gnu elpa" . "https://elpa.gnu.org/packages/")
;;        ("nongnu elpa" . "https://elpa.nongnu.org/nongnu/")
;;        ("melpa" . "https://melpa.org/packages/")
;;	    ("melpa-stable" . "https://stable.melpa.org/packages/"))
;;      package-archive-priorities
;;      '(("gnu elpa" . 4)
;;	    ("nongnu elpa" . 3)
;;	    ("melpa" . 2)
;;	    ("melpa-stable". 1)))


;;(package-initialize)
;;(unless package-archive-contents
;;  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
;;(unless (package-installed-p 'use-package)
;;  (package-install 'use-package))

(add-to-list 'load-path (expand-file-name "~/.guix-home/profile/share/emacs/site-lisp"))
(add-to-list 'load-path (expand-file-name "~/.guix-profile/share/emacs/site-lisp/") t)

(require 'guix-emacs)
(guix-emacs-autoload-packages)

(require 'use-package) ;; since guix takes care of packages, no need for :ensure t

(require 'project)
(require 'desktop)
(setq desktop-dirname

;; packages.el
(with-eval-after-load 'org
  (add-to-list 'org-modules 'org-habit t))


(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.2))

(use-package swiper)

(use-package ivy
  :demand t ;; load on startup
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :config
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; paredit
(use-package paredit
  :hook ((emacs-lisp-mode
          eval-expression-minibuffer-setup
          ielm-mode
          lisp-mode
          lisp-interaction-mode
          scheme-mode) . enable-paredit-mode))

;; make eldoc paredit aware
(use-package eldoc
  :hook ((emacs-lisp-mode lisp-interaction-mode ielm-mode) . eldoc-mode)
  :config
  (eldoc-add-command 'paredit-backward-delete 'paredit-close-round))

;(custom-set-faces
;  '(variable-pitch
;    (:family "EtBembo"
;	     :background nil
;	     :foreground bg-dark
;	     :height 1.7))
; '(org-document-title
;    (:inherit variable-pitch
;	      :height 1.3
;	      :weight normal
;	      :foreground gray)))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '("~/projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit)

;;  NOTE: Make sure to configure a Github token before using this package!
;;  - https://magit.vc/manul/gorge/Token-Creation.html#Token-Creation
;;  - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
;;  (use-package forge)

(use-package org
  :config
  (setq org-agenda-files
	'("~/org/"))
  (setq org-agenda-tag-filter-preset '("-REFILE"))

  (setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	  (sequence "WAIT(w)" "HOLD(h)" "|""NOTE(o@/!)" "STOP(s@/!)")))

  (setq org-todo-state-tags-triggers
	'(("CANCELLED" ("CANCELLED" . t))
	  ("WAITING" ("WAITING" . t))
	  ("HOLD" ("WAITING") ("HOLD" . t))
	  (done ("WAITING") ("HOLD"))
	  ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
	  ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
	  ("DONE" ("WAITING") ("CANCELLED") ("HOLD"))))

  (setq org-directory "~/org")
  (setq org-default-notes-file "~/org/refile.org")

  ;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
  (setq org-capture-templates
	'(("t" "todo" entry (file "~/org/refile.org")
	   "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
	  ("r" "respond" entry (file "~/org/refile.org")
	   "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
	  ("n" "note" entry (file "~/org/refile.org")
	   "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
	  ("j" "JOURNAL" entry (file "~/org/refile.org")
	   "* %?\n%U\n" :clock-in t :clock-resume t)
	  ("w" "org-protocol" entry (file "~/org/refile.org")
	   "* TODO Review %c\n%U\n" :immediate-finish t)
	  ("m" "MEETING" entry (file "~/org/refile.org")
	   "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
	  ("p" "Phone call" entry (file "~/org/refile.org")
	   "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
	  ("h" "Habit" entry (file "~/org/refile.org")
 	   "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")))

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-deadline-warning-days 0) ;; show all deadlines
  (setq org-archive-location "~/org/archive/journal.org::datetree/"))

;; org keys
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(with-eval-after-load 'org
  (setq org-startup-indented t)
  (add-hook 'org-mode-hook #'visual-line-mode))

;; org aesthetics
;(let* ((variable-tuple
;	(cond ((x-list-fonts "ETBembo") '(:font "ETBembo"))
;	      (base-font-color (face-foreground 'default nil 'defautl)))))
;	      ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
;	      ((x-list-fonts "Lucida Grande") '(:font "Lucida Grande"))
;	      ((x-list-fonts "Verdana") '(:font "Verdana"))
;	      ((x-family-fonts "Sans Serif") '(:family "Sans Serif"))
;	      (nil (warn "cannot find Sans Serif font. Install source sans pro."))))
;       (base-font-color (face-foreground 'default nil 'default))
;      (headline `(:inherit default :weight bold :foreground ,base-font-color))))

;  (custom-theme-set-faces
;  'user
;   `(org-level-8 ((t (,@headline ,@variable-tuple))))
;   `(org-level-7 ((t (,@headline ,@variable-tuple))))
;   `(org-level-6 ((t (,@headline ,@variable-tuple))))
;   `(org-level-5 ((t (,@headline ,@variable-tuple))))
;   `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
;   `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
;   `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
;   `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
;   `(org-document-title ((t (,@headline, ,@variable-tuple :height 2.0 :underline nil)))))

(setq org-roam-database-connector 'sqlite-builtin)

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/org/org-roam")
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

;; Themes can run malicious lisp codes. Do not recommend! I am doing this because I am lazy and stupid.
(setq custom-safe-themes t)
(use-package gruvbox-theme)
;; Emacs only autoload the package after processing the init file, so load theme
;; command at init.el may not work. Therefore, the correct way to autoload themes
;; would be to add a hook to after-init-hook
(add-hook 'after-init-hook (lambda () (load-theme 'gruvbox-light-soft)))

(use-package mixed-pitch
  :hook
  ;; If you want it in all text modes:
  (text-mode . mixed-pitch-mode)
  :config
  (setq mixed-pitch-set-height t)
  (set-face-attribute 'variable-pitch nil :height 1.3))



