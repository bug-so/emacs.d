;; (use-package dired-subtree
;;   :config
;;   (define-key dired-mode-map (kbd "i") 'dired-subtree-insert)
;;   )

;; (define-key dired-mode-map (kbd "f") dired-filter-map)

(bind-keys :map dired-mode-map
           ("q" . quit-winoow-and-back)
           ([C-return] . my-dired-find-file-other-window)
           ("\\" . dired-narrow)
           )

(defun my-dired-find-file-other-window ()
  (interactive)
  (let ((buffer (dired-get-file-for-visit)))
    (other-window-or-split)
    (find-file buffer)
    )
  )

(defun quit-winoow-and-back ()
  "quit window and kill buffer and back to last visit buffer"
  (interactive)
  (kill-and-back-to-last-buffer (current-buffer))
  )
