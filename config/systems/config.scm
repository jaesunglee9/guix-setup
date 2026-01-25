;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "Asia/Seoul")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "server0")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "user0")
                  (comment "user0")
                  (group "users")
                  (home-directory "/home/user0")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list (specification->package "nss-certs"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list

                 ;; To configure OpenSSH, pass an 'openssh-configuration'
                 ;; record as a second argument to 'service' below.
                 (service openssh-service-type
			  (openssh-configuration
			    (password-authentication? #t)
			    (permit-root-login 'without-password)))
                 (service dhcp-client-service-type)
                 (service ntp-service-type)
		 (service guix-publish-service-type
			  (guix-publish-configuration
			    (host "0.0.0.0")
			    (port 8080)
			    (advertise? #t)
			    (nar-path "/var/cache/guix/publish")
			    (workers 3)
			    (secret-key-file "/root/.config/guix/signing-key.sec")
			    (public-key-file "/root/.config/guix/signing-key.pub")
			    (compression-level 3)
			    ))

           ;; This is the default list of services we
           ;; are appending to.
           %base-services)))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "485b94b8-82a3-44bd-84f5-894a2988b882")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "6f3b122d-7b27-4fc7-9f48-9e6f4ce6f496"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "D199-F929"
                                       'fat32))
                         (type "vfat")) %base-file-systems)))
