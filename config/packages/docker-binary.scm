(define-module (config packages docker-binary)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix licenses:))  

(define-public docker-static
  (package
    (name "docker-static")
    (version "29.1.4") ; Update this to the version you want
    (source
     (origin
       (method url-fetch)
       ;; Docker publishes static binaries here
       (uri (string-append "https://download.docker.com/linux/static/stable/x86_64/docker-"
                           version ".tgz"))
       (sha256
        ;; You must calculate this hash. 
        ;; Run: guix download https://download.docker.com/linux/static/stable/x86_64/docker-27.4.1.tgz
        ;; and replace the string below with the result.
        (base32 "0bhwjq69nyn13r4a4s4qcflf3kh7a40xjrl2nilh27qpsnp5pva5"))))
    (build-system copy-build-system)
    (arguments
     `(#:install-plan
       ;; The tarball extracts to a "docker" directory containing the binaries.
       ;; We tell Guix: "Copy everything from the current directory (.) to bin/ in the output."
       '(("docker/" "bin/")))) 
    (home-page "https://www.docker.com")
    (synopsis "Docker Static Binary")
    (description "Docker Engine static binaries for Linux.")
    (license licenses:asl2.0)))
    
