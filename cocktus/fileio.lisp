(defun get-file (filename)
  (with-open-file (stream (merge-pathnames filename *load-truename*))
    (loop for line = (read-line stream nil)
          while line
          collect line)))