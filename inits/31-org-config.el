;; org-modeで折り返し
(setq org-startup-truncated nil)

;; 色分けだったかな
(setq org-src-fontify-natively t)


(eval-after-load "org"
  '(progn
     (define-key org-mode-map (kbd "C-a") nil)
     (define-key org-mode-map (kbd "C-e") nil)
     (define-key org-mode-map [C-tab] nil)
     ))
