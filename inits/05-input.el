;; mozcの設定(入ってないからどうせしない)
(use-package mozc
  :config
  (setq default-input-method "japanese-mozc")
  (setq mozc-candidate-style 'echo-area)
  ;; (setq mozc-candidate-style 'overlay)

  ;; mozc周り
  (global-set-key [henkan] 'my-active)
  (define-key mozc-mode-map [muhenkan] 'my-deactive)
  (defun my-active ()
    (interactive)
    (activate-input-method "japanese-mozc")
    )
  (defun my-deactive ()
    (interactive)
    (deactivate-input-method)
    )
  )

;; カーソルを細い縦棒にする
;; (setq cursor-type 'bar)
