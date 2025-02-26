;; configuration of terminal 2 machine, a thinkpad t420 model.

;; Indicate which modules to import to access the variables
;; used in this configuration.

(include "./base.scm")

(use-modules (gnu) (nongnu packages linux) (guix))

(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (inherit terminal-system)
  (kernel linux)
  (firmware (list linux-firmware))

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
