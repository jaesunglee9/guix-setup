;; base.scm

;; This file contains three variable definitions: base, terminal, [server] This may increase later
;; base is minimal config upon build other more complex machine specification
;; example: (inherit (base-system))

(define-module (guix-config systems base)
  #:use-modules (gnu)
  #:export (base-system terminal-system))


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-service-modules cups desktop networking ssh xorg)

(define base-system
  (operating-system
    (host-name "base-system")
    (timezone "Asia/Seoul")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout "us" #:options '("ctrl:swapcaps")))

    (users (cons* (user-account
                (name "user0")
                (comment "user0")
                (group "users")
                (home-directory "/home/user0")
                (supplementary-groups '("wheel" "netdev" "audio" "video")))
              %base-user-accounts))

    ;; Packages installed for all systems.
    (packages
     (append
      (specifications->packages (list "git" "neovim" "wget" "less" "htop"))
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
      (specifications->packages (list "plasma-desktop" "sddm"))))

    (services
     (append
      (operating-system-services base-system)
      (list
        (service cups-service-type)
        (service sddm-service-type
          (sddm-configuration
            (default-session "plasma.desktop")
            (theme "breeze")))
        (set-xorg-configuration
          (xorg-configuration
            (keyboard-layout (operating-system-keyboard-layout base-system)))))
      %desktop-services))))

