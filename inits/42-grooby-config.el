(use-package groovy-mode
  (:mode (("\\.gradle$" . groovy-mode)))
  :config (add-hook 'groovy-mode-hook (lambda () (setq tab-width 8)))
  )
