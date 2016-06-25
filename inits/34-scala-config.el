(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/ensime_2.10.0-0.9.8.9/elisp/"))
;; (add-to-list 'load-path "/home/osaki/Application/ensime_2.9.2-0.9.8.9/elisp")
;; (use-package ensime)

(use-package ensime
  :commands (ensime)
  :config
  (message "ensime loading")
  (add-hook 'scala-mode-hook 'ensime)
  (bind-keys :map ensime-mode-map
             ("C-x C-SPC" . ensime-format-source)
             ("M-n" . nil)
             ("M-p" . nil)
             ("C-," . ensime-forward-note)
             ("M-," . ensime-backward-note)
             ("C-." . ensime-edit-definition)
             ("M-." . nil)
             ("C-x C-a" . ensime-refactor-rename)
             ("C-S-o" . ensime-import-type-at-point)
             )
  (defadvice ensime-edit-definition (before mark-register activate)
    (my-register-set)
    )
  )


(add-hook 'scala-mode-hook
          (lambda ()
            (ensime)
            (delete 'ac-source-yasnippet 'ac-sources)
            ))
