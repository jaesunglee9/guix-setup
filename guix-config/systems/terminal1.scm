;; configuration of terminal 1 machine, a thinkpad t480 model.

;; Indicate which modules to import to access the variables
;; used in this configuration.

;; base.scm

;; This file contains three variable definitions: base, terminal, [server] This may increase later
;; base is minimal config upon build other more complex machine specification
;; example: (inherit (base-system))

;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu) (nongnu packages linux) (guix) (nongnu system linux-initrd))
(use-service-modules cups desktop networking ssh xorg sddm)

;; Not meant to be used on its own.
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
      (specifications->packages (list "nss-certs" "git" "neovim" "wget" "less" "htop"))
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
      %base-services))
    (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
              (targets (list "/dev/sdb"))
              (keyboard-layout keyboard-layout)))

    ;; The list of file systems that get "mounted".  The unique
    ;; file system identifiers there ("UUIDs") can be obtained
    ;; by running 'blkid' in a terminal.
    (file-systems (cons* (file-system
                          (mount-point "/")
                          (device (uuid
                                    "e45a594e-0627-4979-9751-b3f33c9989f5"
                                    'ext4))
                          (type "ext4")) %base-file-systems))))



;; (define server)

(define terminal-system
  (operating-system
    (inherit base-system)

    (packages
     (append
      (operating-system-packages base-system)
      (specifications->packages (list "firefox" "font-google-noto-sans-cjk"))))

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
				 (list (local-file "../../nonguix-signing-key.pub"))
				 %default-authorized-guix-keys))))))))

    

(operating-system
  (inherit terminal-system)
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list sof-firmware linux-firmware))

  (host-name "terminal1")

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "/dev/sdb"))
                (keyboard-layout (operating-system-keyboard-layout terminal-system))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "e45a594e-0627-4979-9751-b3f33c9989f5"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
