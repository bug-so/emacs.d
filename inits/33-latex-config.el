(use-package xdvi-search
  :commands (xdvi-jump-to-line)
  )

(eval-after-load "latex-mode"
  '(progn
     (custom-set-variables '(xdvi-bin "pxdvi"))
     ))

(use-package my-thesis
  :commands (thesis-mode)
  :config
  (custom-set-variables '(xdvi-bin "pxdvi"))
  (bind-keys :map latex-mode-map
            ("C-c C-j" . xdvi-jump-to-line-and-focus)
            ("C-c C-i" . open-latex-pdf-file)
            )
  )

(defun xdvi-jump-to-line-and-focus ()
  (interactive)
  (xdvi-jump-to-line nil)
  (call-process "wmctrl" nil 0 nil "-a" "xdvi")
  )

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/"))
(add-hook 'latex-mode-hook
          (lambda ()
            (turn-on-reftex)
            (make-local-variable 'compile-command)
            (setq compile-command "rake dvi")
            (use-package latex-mode-expansions)

            (when (require 'helm-migemo nil t)
              (init-imenu))
            ;; 自作の論文モード。保存時に句読点をカンマ、ピリオドに書き換える
            (thesis-mode)
            ))

;;;###autoload
(defun check-back-slash-for-latex ()
  "check backslash for yasnippet for latex-mode"
  (interactive)
  (if (equal (string (preceding-char)) "\\")
      ""
    "\\"
    ))

;;;###autoload
(defun remove-back-slash-for-latex ()
  "check backslash for yasnippet for latex-mode"
  (interactive)
  (if (equal (string (preceding-char)) "\\")
      (delete-char -1)
    ))

(defun init-imenu ()
  (defun latex-helm-imenu ()
    (interactive)
    (helm-imenu))
  (helm-migemize-command latex-helm-imenu)

  (setq reftex-toc-follow-mode t)
  (defun reftex-toc-with-popwin ()
    (interactive)
    (my-switch-buffer-with-popwin'reftex-toc))

  (bind-key (kbd "C-;") 'latex-helm-imenu latex-mode-map)

  )

;; bibtex
(add-hook 'bibtex-mode-hook
          (lambda ()
            (setq bibtex-entry-offset 0)
            (setq bibtex-align-at-equal-sign t)
            ))


;;;###autoload
(defun open-latex-pdf-file ()
  (interactive)
  (let ((pdf-filename (concat (file-name-sans-extension (file-name-nondirectory (buffer-file-name))) ".pdf")))
    (call-process "gnome-open" nil 0 nil pdf-filename)
    ;; (start-process-shell-command "latex-pdf" nil "evince" pdf-filename)
    ;; (start-process-shell-command "latex-pdf" "pdf" "ls " (file-name-directory (buffer-file-name)))
    )
  )
