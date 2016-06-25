;; elisp-modeは絶対に読み込まれるので遅延評価は無理かな
(use-package eldoc
  :config
  (setq eldoc-idle-delay 1)
  (setq eldoc-echo-area-use-multiline-p t)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
  )
(use-package eldoc-extension)

;; (use-package elisp-format)

(use-package elisp-slime-nav
  :config
  (define-key elisp-slime-nav-mode-map (kbd "C-.") 'elisp-slime-nav-find-elisp-thing-at-point)
  (define-key elisp-slime-nav-mode-map (kbd "M-.") 'pop-tag-mark)
  )

(use-package lispxmp)

(provide '35-elisp-config)
