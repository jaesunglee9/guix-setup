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
  #:use-module (gnu services xorg))

(operating-system
  (inherit terminal-system)
  
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list sof-firmware linux-firmware))

  (host-name "terminal1")

  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets (list "/boot/efi"))
               (keyboard-layout (operating-system-keyboard-layout terminal-system))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "b43eb8f2-df43-4077-8716-a43709329c15"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "F85B-F2AD"
                                       'fat32))
                         (type "vfat")) %base-file-systems)))
