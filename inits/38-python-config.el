(use-package python
  :config
  (use-package epc)
  (use-package auto-complete-config)
  (use-package jedi
    :config
    (add-hook 'python-mode-hook 'jedi:setup)
    (setq jedi:complete-on-dot t)
    (define-key jedi-mode-map [C-tab] nil)
    (setenv "PYTHONPATH" "/usr/local/lib/python2.7/site-packages")
    )
  ;; PYTHONPATH上のソースコードがauto-completeの補完対象になる
  ;; (setenv "PYTHONPATH" "/usr/lib/python2.7/dist-packages/autokey/service.py")
  )
;; (setenv "PYTHONPATH" "/usr/local/lib/python2.7/site-packages")



