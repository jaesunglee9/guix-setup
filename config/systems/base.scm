;; base.scm

;; This file contains three variable definitions: base, terminal, [server] This may increase later
;; base is minimal config upon build other more complex machine specification
;; example: (inherit (base-system))

;; Indicate which modules to import to access the variables
;; used in this configuration.
(define-module (config systems base)
  ;; Core Gnu/Guix system
  #:use-module (gnu)
  #:use-module (guix)
  #:use-module (guix gexp)
  #:use-module (guix channels)
  #:use-module (srfi srfi-1)
  
  ;; Services
  #:use-module (gnu services)
  #:use-module (gnu services ssh)
  #:use-module (gnu services networking)
  #:use-module (gnu services cups)
  #:use-module (gnu services desktop)
  #:use-module (gnu services xorg)
  
  ;; Packages
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages firmware)
  #:use-module (nongnu packages linux)
  
  #:export (base
	    base-system
	    terminal-system
	    server-system
	    unique-specs->packages
	    %nonguix-key))

(define %nonguix-key
  (local-file (string-append (dirname (current-filename))
                             "/../../keys/nonguix-signing-key.pub")
              "nonguix-signing-key.pub"))

;; Convenience: turn spec strings into unique package list, avoiding duplicates.
;; Normalize spec items to a package object.
(define (->pkg x)
  (cond
    ((package? x) x)
    ((pair? x)   (car x))                      ; (pkg . "out")
    ((string? x) (specification->package x))   ; "git", "firefox@123", "foo:static"
    (else (error "unsupported spec item for ->pkg" x))))

;; Robust helper: specs -> list of unique packages.
(define (unique-specs->packages specs)
  (let ((pkgs (map ->pkg specs)))
    (delete-duplicates
     pkgs
     (lambda (a b)
       (string=? (package-full-name a) (package-full-name b))))))


(define base-system
  (operating-system
   (host-name "base-system")
   (timezone "Asia/Seoul")
   (locale "en_US.utf8")
   (keyboard-layout (keyboard-layout "us" #:options '("ctrl:swapcaps")))

   (firmware '())

   ;; REQUIRED FIELDS (placeholders)
    (bootloader (bootloader-configuration
                 (bootloader grub-efi-bootloader)   ; use BIOS to avoid EFI mount requirement
                 (targets '("placeholder"))))           ; dummy device; will be overridden

    (file-systems %base-file-systems)            ; minimal default; will be overridden

    (users (cons* (user-account
                   (name "user0")
                   (comment "user0")
                   (group "users")
                   (home-directory "/home/user0")
                   (supplementary-groups '("wheel"
					   "netdev"
					   "audio"
					   "video")))
		  %base-user-accounts))
    
   ;; Packages installed for all systems.
   (packages
    (append
     (unique-specs->packages (list "git"
				   "neovim"
				   "wget"
				   "less"
				   "htop"))
     %base-packages))

   ;; Below is the list of system services.  To search for available
   ;; services, run 'guix system search KEYWORD' in a terminal.
   (services
    (append
     (list
      ;; To configure OpenSSH, pass an 'openssh-configuration'
      ;; record as a second argument to 'service' below.
      (service openssh-service-type))
     ;; This is the default list of services we
     ;; are appending to.
     %base-services))))

;; (define server)

(define terminal-system
  (operating-system
    (inherit base-system)
    
    (packages
     (append
      (operating-system-packages base-system)
      (unique-specs->packages (list "plasma-desktop" "sddm"
				      "firefox"				     
				      "font-google-noto-sans-cjk"))))

    (services
     (modify-services 
      (append
       (list 
	(service plasma-desktop-service-type)
	(service openssh-service-type)
	(service cups-service-type)
	(set-xorg-configuration 
	 (xorg-configuration
	  (keyboard-layout (operating-system-keyboard-layout base-system)))))
       %desktop-services)
      
      (guix-service-type config =>
			 (guix-configuration
			  (inherit config)
			  (substitute-urls 
			   (append
			    (list "https://substitutes.nonguix.org")
			    %default-substitute-urls))
			  (authorized-keys
			   (append
			    (list %nonguix-key)
			    %default-authorized-guix-keys))))))

    (firmware
     (append (list linux-firmware)
	     (operating-system-firmware base-system)))))

;; ------------------------
;; Server (headless)
;; ------------------------
(define server-system
  (operating-system
    (inherit base-system)

    ;; Server tools on top of base (adjust to your taste).
    (packages
     (append
      (operating-system-packages base-system)
      (unique-specs->packages '("ncdu" "rsync" "curl" "tmux"))))

    ;; Harden SSH; add a simple firewall and keep it headless (no %desktop-services).
    (services
     (append
      (modify-services (operating-system-services base-system)
        (openssh-service-type
         config => (openssh-configuration
                    (inherit config)
                    (password-authentication? #f) ; key-only by default
                    (permit-root-login 'no))))
      (list
       ;; simple-firewall is under (gnu services networking)
       (service simple-firewall-service-type
                (simple-firewall-configuration
                 (open-ports '(22)))))  ; open only SSH by default
      '()))))


