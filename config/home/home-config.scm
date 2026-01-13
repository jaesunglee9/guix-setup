

;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(define-module (config home home-config)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu packages gnupg))

(home-environment
  ;; Below is the list of packages that will show up in your
  ;; Home profile, under ~/.guix-home/profile.
  (packages (specifications->packages (list "bash" "git"
					    "zig" "julia"
                                            "emacs" "emacs-use-package"
                                            "emacs-org-roam" "emacs-emacsql" "emacs-magit" "emacs-projectile" "emacs-counsel-projectile"
					    "emacs-geiser" "emacs-geiser-guile"
                                            "emacs-counsel" "emacs-ivy" "emacs-ivy-rich" "emacs-swiper" "emacs-which-key" "emacs-helpful" "emacs-paredit"
                                            "emacs-gruvbox-theme" "emacs-mixed-pitch"
					    "font-et-book")))
  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list
    (service home-dotfiles-service-type
              (home-dotfiles-configuration
                (directories '("../../files"))))
    
    (service home-gpg-agent-service-type
	     (home-gpg-agent-configuration
	       (pinentry-program
		(file-append pinentry "/bin/pinentry"))
	       (extra-content "allow-loopback-pinentry"))))))



