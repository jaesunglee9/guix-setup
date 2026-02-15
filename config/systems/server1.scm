;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
	     (gnu system)
	     (gnu services)
	     (guix)
	     (config systems base)
	     (gnu packages ssh)
	     (gnu services cups)
	     (nongnu packages linux)
	     (nongnu system linux-initrd)
	     (gnu services ssh)
	     (gnu services desktop)
	     (gnu services networking)
	     (gnu services xorg)
	     (gnu services avahi)
	     (gnu services web)
	     (gnu services certbot))


(operating-system
 (inherit server-system)

 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets (list "/boot/efi"))
              (keyboard-layout (operating-system-keyboard-layout server-system))))


 (host-name "server1")
 ;; Below is the list of system services.  To search for available
 ;; services, run 'guix system search KEYWORD' in a terminal.
 (services
   (modify-services
  (append (list

           ;; To configure OpenSSH, pass an 'openssh-configuration'
           ;; record as a second argument to 'service' below.
	   (service dhcpcd-service-type)
	   (service avahi-service-type)
           (service ntp-service-type)
	   (service nginx-service-type
		    (nginx-configuration
		      (server-blocks
			(list (nginx-server-configuration
				(server-name '("localhost"))
				(listen '("80"))
				(ssl-certificate #f)
				(ssl-certificate-key #f)
				(root "/srv/http/my-blog")
				(index '("index.html")))))))

	   (service guix-publish-service-type
		    (guix-publish-configuration
		     (host "0.0.0.0")
		     (port 8080)
		     (advertise? #t)
		     (nar-path "/var/cache/guix/publish")
		     (workers 2))))	   
	  (operating-system-user-services server-system))

  (nftables-service-type config =>
		    (nftables-configuration
		      (ruleset (plain-file "nftables.conf"
					   "table inet filter {
                                             chain input {
                                               type filter hook input priority 0; policy drop;
                                               iifname \"lo\" accept
                                               ct state { established, related } accept
                                   
                                               # Open doors for your services
                                               tcp dport 22 accept   # SSH
                                               tcp dport 80 accept   # Nginx (Your Blog!)
                                               tcp dport 8080 accept # Guix Publish
                                   
                                               # Allow pings for debugging
                                               ip protocol icmp accept
                                               ip6 nexthdr ipv6-icmp accept
                                             }
                                           }"))))))


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
