;; debug.scm
(use-modules (guix)
             (gnu)
             (srfi srfi-1)
             (config systems base)  ;; Import your base module
             (gnu services)
             (gnu services networking)
             (gnu services ssh)
             (gnu services web))

;; ---------------------------------------------------------
;; DIAGNOSTIC FUNCTION
;; ---------------------------------------------------------
(define (analyze-os os name)
  (format #t "\n========================================\n")
  (format #t "ANALYSIS FOR: ~a\n" name)
  (format #t "========================================\n")
  
  (let* ((services (operating-system-services os))
         ;; Extract the name of the service type for every service
         (type-names (map (lambda (s) 
                            (service-type-name (service-kind s))) 
                          services)))
    
    ;; 1. Print total count
    (format #t "Total Services: ~d\n" (length services))
    
    ;; 2. Check for ANY duplicates
    (let ((counts (fold (lambda (name acc)
                          (assoc-set! acc name (+ 1 (or (assoc-ref acc name) 0))))
                        '()
                        type-names)))
      (for-each (lambda (pair)
                  (when (> (cdr pair) 1)
                    (format #t "!!! DUPLICATE DETECTED: ~a (Count: ~d)\n" 
                            (car pair) (cdr pair))))
                counts))
    
    ;; 3. Check specifically for 'system' (guix-service-type)
    (let ((system-count (count (lambda (x) (eq? x 'guix)) type-names)))
      (if (> system-count 1)
          (format #t ">>> CRITICAL ERROR: Multiple 'guix' services detected! (System will crash)\n")
          (format #t ">>> 'guix' service count is OK.\n")))))

;; ---------------------------------------------------------
;; RUN THE TESTS
;; ---------------------------------------------------------

;; TEST 1: Check the base server-system defined in base.scm
(analyze-os server-system "Base Server System (from base.scm)")

;; TEST 2: Check the logic you are using in server0.scm
;; We reconstruct the exact service list from your server0.scm here to test it.
(format #t "\nTesting your 'server0' configuration logic...\n")

(let ((test-services 
       (append
        ;; The new services you added in server0.scm
        (list 
         (service ntp-service-type)
         (service guix-publish-service-type
                  (guix-publish-configuration
                   (host "0.0.0.0")
                   (port 8080)
                   (advertise? #t)
                   (workers 2))))
        
        ;; The modification logic you used
        (modify-services (operating-system-services server-system)
          (openssh-service-type config =>
            (openssh-configuration
             (inherit config)
             (password-authentication? #t)
             (permit-root-login 'without-password)))
          ;; Ensure we are replacing, not adding duplicate DHCP
          (dhcp-client-service-type config =>
            (service dhcpcd-service-type))))))

  ;; Create a dummy OS with this list to analyze it
  (let ((dummy-os (operating-system (inherit server-system) (services test-services))))
    (analyze-os dummy-os "Server0 Final Build")))
