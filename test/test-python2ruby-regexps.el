(require 'test-simple)
(require 'load-relative)
(load-file "../python2ruby-rough.el")

(declare-function python2ruby-regexp-search-replace 'python2ruby-rough)

(eval-when-compile
  (defvar temp-srcbuf)
)

(test-simple-start)

(note "python2ruby regexps")
(set (make-local-variable 'temp-srcbuf)
     (generate-new-buffer "*python2ruby*"))

(defun check-replace (string expect)
  (with-current-buffer temp-srcbuf
    (erase-buffer)
    (insert string)
    (python2ruby-regexp-search-replace (point-min) (point-max) 'replace-regexp)
    (assert-equal expect
		  (buffer-substring-no-properties
		   (point-min) (point-max)))
  ))

(check-replace "[fn(x) for x in rows]" "rows.map{|x| fn(x)}")
(check-replace "#!/usr/bin/env python" "#!/usr/bin/env ruby")
(check-replace "zip(cols, coltypes)"   "cols.zip(coltypes)")

(end-tests)
