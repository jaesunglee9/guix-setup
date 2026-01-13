;; configuration of terminal 1 machine, a thinkpad t480 model.

;; Indicate which modules to import to access the variables
;; used in this configuration.
(define-module (config systems terminal1)
  #:use-module (gnu)
  #:use-module (guix)
  #:use-module (config systems base)
  #:use-module (gnu packages ssh)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  #:use-module (gnu services cups)
  #:use-module (gnu services ssh)
  #:use-module (gnu services desktop)
  #:use-module (gnu services networking)
  #:use-module (gnu services xorg)
  #:use-module (gnu services virtualization)
  #:use-module (gnu services docker)
  #:use-module (packages docker))

(define (add-groups-to-user username new-groups users)
  (map (lambda (u)
         (if (string=? (user-account-name u) username)
             (user-account
              (inherit u)
              (supplementary-groups 
               (append (user-account-supplementary-groups u) new-groups)))
             u))
       users))


(operating-system
 (inherit terminal-system)
  
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list sof-firmware linux-firmware))
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets (list "/boot/efi"))
              (keyboard-layout (operating-system-keyboard-layout terminal-system))))

 (host-name "terminal1")
 (users (add-groups-to-user "user0" 
                            '("libvirt" "kvm") 
                            (operating-system-users terminal-system)))
 
 (packages
  (append
   (operating-system-packages terminal-system)
   (unique-specs->packages (list "virt-manager"))))

 (services
  (cons* (service libvirt-service-type
		  (libvirt-configuration
		   (unix-sock-group "libvirt")))
	 (service virtlog-service-type)
	 (service docker-service-type 
                 (docker-configuration
                   (package docker-static)))
	 (operating-system-user-services terminal-system)))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.
 (file-systems (cons* (file-system
                       (mount-point "/")
                       (device (uuid
                                "b2246e27-eeda-4cb4-81dc-3bc917037684"
                                'ext4))
                       (type "ext4"))
                      (file-system
                       (mount-point "/boot/efi")
                       (device (uuid "2F79-5A20"
                                     'fat32))
                       (type "vfat")) %base-file-systems)))
