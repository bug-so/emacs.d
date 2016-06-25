(defvar-local structures-var nil)
(defvar tmp-output-buffer "tmp-indent")
(defun my-c-indent ()
  (interactive)
  (if (executable-find "cmigemo")
      (save-window-excursion
        (let* ((p (point))
               (cb (current-buffer))
               (before (buffer-substring-no-properties (point-min) (point-max)))
               (after (indent-source-code before))
               )
          (if (and (check-indent-error after) (not (equal before after)))
              (copy-to-buffer cb (point-min) (point-max)))
          ;; (my-copy-buffer (current-buffer) cb))
          (switch-to-buffer cb)
          (kill-buffer tmp-output-buffer)
          (goto-char p)
          (delete-file tmp-output-buffer)
          )
        ))
  )
(defun check-indent-error (indent-code)
  (not (string-match "^indent:.*Error.*" indent-code)))

;; unused
(defun my-copy-buffer (from to)
  (let* ((cursor-p (save-excursion
                     (switch-to-buffer to)
                     (point)))
         (before (buffer-substring (point-min) cursor-p))
         (after (buffer-substring (- cursor-p 1) (point-max)))
         )
    (switch-to-buffer to)
    (save-excursion
      (goto-char (point-min))
      (insert before)
      (delete-char cursor-p)
      (insert after)
      (delete-char (- (point-max) (point)))
      )
    )
  )


(defvar k-and-r-style t "-kr general style named Kernighan & Ritchie coding style")
(defvar cuddle-else t "-ce Cuddle else and preceding ‘}’.")
(defvar braces-on-if-line t "-br Put braces on line with if, etc.")
(defvar braces-on-func-def-line t "-brf
        int one(void) {
          return 1;
        };

         ↓

        int one(void)
        {
          return 1;
        };
")

(defun get-structures ()
  (if (not structures-var)
      (setq structures-var (search-struct))
    )
  structures-var)

(defun indent-source-code (before)
  (with-temp-file tmp-output-buffer
    (insert before))
  (let ((indent-command (get-indent-command)))
    (shell-command (concat "nkf -w " tmp-output-buffer " | " indent-command) tmp-output-buffer))
  (set-buffer tmp-output-buffer)
  (goto-char (point-min))
  (while (re-search-forward "indent:.*Warning:.*\n" nil t)
    (replace-match ""))
  (buffer-substring-no-properties (point-min) (point-max))
  )

(defun get-indent-command ()
  (let ((command "indent -kr -ce -br -lp -i 2 -nut -cs -cdw -bbb -nbbo -bbo -bap -nbc -brf -npsl -l120"))
    (mapc (lambda (v) (set 'command (concat command " -T " v))) (get-structures))
    command
    )
  )

(defun jone-filter (condp lst)
  (delq nil
        (mapcar (lambda (x) (and (funcall condp x) x)) lst)))
(defun search-struct ()
  (let* ((regexp "}[ ]*[a-z_]+[ ]*;")
         (c-files (jone-filter (lambda (f) (string-match ".*\\.[ch]$" f)) (directory-files ".")))
         (structures (search-struct-c-h c-files))
         )
    structures
    )
  )

(defun search-struct-c-h (c-files)
  (let ((result '()))
    (mapc (lambda (c-file)
            (set 'result (append result (_search-struct c-file))))
          c-files)
    (delete-dups result)
    ))


(defun _search-struct (c-file)
  (with-temp-buffer
    (insert-file-contents c-file)
    (let ((regexp "}[ ]*\\([a-z_]+\\)[ ]*;")
          (structures '())
          )
      (goto-char (point-min))
      (while (re-search-forward regexp nil t)
        (set 'structures (append structures (list (match-string-no-properties 1)))))
      (delete-dups structures)
      )
    )
  )

(provide 'c-formatter)
