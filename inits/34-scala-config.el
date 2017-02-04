(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))

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
  (bind-key (kbd "C-x C-a") nil)
  (setq ensime-completion-style 'auto-complete)
  (setq ensime-startup-notification nil)
  (setq ensime-startup-snapshot-notification nil)
  (add-hook 'scala-mode-hook
            (lambda ()
              (ensime)
              (delete 'ac-source-yasnippet 'ac-sources)
              ))

  (defadvice ensime-edit-definition (before mark-register activate)
    (my-register-set)
    )
  )
