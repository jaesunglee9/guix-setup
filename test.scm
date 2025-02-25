(use-modules (guix config))

(set-build-options (build-options)
		   #:fallback? #t
		   #:max-jobs 4
		   #:substitute-urls '("https://substitutes.nonguix.org"
				       "https://ci.guix.gnu.org"))
