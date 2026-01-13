;; (use-modules (guix)
;; 	    (gnu)
;; 	    (srfi srfi-1)
;; 	    (config systems base)
;;   ;; Add any other modules needed to load terminal-system
;; 	    (gnu services)
;; 	    (gnu services virtualization)
;; 	    (gnu services desktop))

;; (define (analyze-os os name)
;;   (format #t "\n========================================\n")
;;   (format #t "ANALYSIS FOR: ~a\n" name)
;;   (format #t "========================================\n")
  
;;   (let* ((services (operating-system-services os))
;;          ;; Extract the name of the service type for every service
;;          (type-names (map (lambda (s) 
;;                             (service-type-name (service-kind s))) 
;;                           services)))
    
;;     ;; 1. Print total count
;;     (format #t "Total Services: ~d\n" (length services))
    
;;     ;; 2. Look specifically for 'system' service duplicates (the likely culprit)
;;     ;; The 'system' service usually comes from guix-service-type or shepherd-root
;;     (let ((system-count (count (lambda (x) (eq? x 'guix)) type-names)))
;;       (format #t "Instances of 'guix' service: ~d\n" system-count)
;;       (if (> system-count 1)
;;           (format #t ">>> CRITICAL ERROR: Multiple 'guix' services detected!\n")
;;           (format #t ">>> 'guix' service count is OK.\n")))

;;     ;; 3. Check for ANY duplicates
;;     (let ((counts (fold (lambda (name acc)
;;                           (assoc-set! acc name (+ 1 (or (assoc-ref acc name) 0))))
;;                         '()
;;                         type-names)))
;;       (for-each (lambda (pair)
;;                   (when (> (cdr pair) 1)
;;                     (format #t "DUPLICATE DETECTED: ~a (Count: ~d)\n" 
;;                             (car pair) (cdr pair))))
;;                 counts))))

;; ;; Run the analysis on the base system
;; (analyze-os terminal-system "terminal-system (Inherited Parent)")

;; ;; If you want to test the hypothetical new list:
;; (format #t "\nTesting the 'terminal1' combination...\n")
;; (let ((new-list (cons* (service libvirt-service-type
;;                                 (libvirt-configuration (unix-sock-group "libvirt")))
;;                        (service virtlog-service-type)
;;                        (operating-system-services terminal-system))))
  
;;   ;; Analyze this new list as if it were an OS
;;   (let ((dummy-os (operating-system (inherit terminal-system) (services new-list))))
;;     (analyze-os dummy-os "terminal1 (Hypothetical)")))
