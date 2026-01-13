(define-module (packages docker-compose-binary)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:))

(define-public docker-compose-binary
  (package
    (name "docker-compose-binary")
    (version "5.0.1") ;; Check https://github.com/docker/compose/releases for latest
    (source
     (origin
       (method url-fetch)
       ;; Note: This downloads a raw binary file, not a tarball
       (uri (string-append "https://github.com/docker/compose/releases/download/v"
                           version "/docker-compose-linux-x86_64"))
       (sha256
        ;; Remember to calculate this!
        ;; guix download https://github.com/docker/compose/releases/download/v2.32.1/docker-compose-linux-x86_64
        (base32 "09wk3d9n017vfxx2yvkk0xnd0i2icarl9h7v58qhkl1f85jdzhfd"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan
       ;; Rename the ugly filename to just "docker-compose" and put it in bin/
       '(("docker-compose-linux-x86_64" "bin/docker-compose"))
       #:phases
       (modify-phases %standard-phases
         ;; Because it's a raw download, we must manually make it executable
         (add-after 'unpack 'make-executable
           (lambda _
             (chmod "docker-compose-linux-x86_64" #o555)
             #t)))))
    (home-page "https://docs.docker.com/compose/")
    (synopsis "Docker Compose (Static Binary)")
    (description "Define and run multi-container applications with Docker.")
    (license license:asl2.0)))

docker-compose-binary
