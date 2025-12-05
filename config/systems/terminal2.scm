;; configuration of terminal 1 machine, a thinkpad t480 model.

;; Indicate which modules to import to access the variables
;; used in this configuration.
(define-module (config systems terminal2)
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

  (host-name "terminal2")

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
