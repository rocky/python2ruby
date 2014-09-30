(require 'test-simple)
(require 'load-relative)
(load-file "../ruby2python-rough.el")

(declare-function ruby2python-regexp-search-replace 'ruby2python2-rough)

(eval-when-compile
  (defvar temp-srcbuf)
)

(test-simple-start)

(note "ruby2python regexps")
(set (make-local-variable 'temp-srcbuf)
     (generate-new-buffer "*ruby2python*"))

(defun check-replace (string expect)
  (with-current-buffer temp-srcbuf
    (erase-buffer)
    (insert string)
    (ruby2python-regexp-search-replace (point-min) (point-max) 'replace-regexp)
    (assert-equal expect
		  (buffer-substring-no-properties
		   (point-min) (point-max)))
  ))

(check-replace "$VERBOSE=true" "$VERBOSE=True")
(check-replace "@dataset.query :paging=>false, :limit => limit"
	       "@dataset.query :paging=>False, :limit => limit")
(check-replace "exit 5" "import sys\nsys.exit(5)")

(end-tests)
