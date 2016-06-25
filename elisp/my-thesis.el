(define-minor-mode thesis-mode
  "Thesis mode"
  :lighter " 論文"
  ;; :keymap ac-mode-map
  :group 'my-thesis
  (if thesis-mode
      (progn
        (make-local-variable 'before-save-hook)
        (add-hook 'before-save-hook 'before-save-hook-for-thesis)
        (set-colors)
        (load-ng-words)
        )
    (remove-hook 'before-save-hook 'replace-general-to-thesis)
    )
  )
(defun before-save-hook-for-thesis ()
  (replace-general-to-thesis)
  ;; (add-space-before-cite)
  )

(defun add-space-before-cite ()
  (replace-regexp-except-string-comment "\\([^ \n]\\)\\\\cite" "\\1 \\\\cite" (point-min)))

(defun file-read (path)
  "read string from file"
  (with-temp-buffer
    (insert-file-contents path)
    (buffer-substring-no-properties (point-min) (point-max))
    )
  )
(defun set-colors ()
  "no document"
  (highlight-regexp "TODO" 'hi-pink)
  )
(defvar ng-words-list-path (expand-file-name "~/.emacs.d/elisp/thesis-ng-words"))
(defun load-ng-words ()
  ;; (let ((ng-words   (s-split "\n" (f-read-text ng-words-list-path))))
  (let ((ng-words (split-string (file-read ng-words-list-path))))
    (mapc (lambda (e) (highlight-regexp e 'hi-yellow)) ng-words)
    )
  )
(defun add-thesis-ng-word (begin end)
  (interactive "r")
  (append-to-file begin end ng-words-list-path)
  (append-to-file "\n" nil ng-words-list-path)
  (reload-ng-words)
  )

(defun reload-ng-words ()
  (interactive)
  (load-ng-words)
  )


(provide 'my-thesis)
