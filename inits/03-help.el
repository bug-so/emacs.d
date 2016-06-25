;; キーバインドのガイド
;; 共通設定

(use-package guide-key
  :commands (guide-key/add-local-guide-key-sequence)
  :config
  (custom-set-variables
      '(guide-key/idle-delay 0.1)
      '(guide-key/popup-window-position 'right)
      '(guide-key/recursive-key-sequence-flag t))
     (guide-key-mode 1)
  )

(defun guide-key/for-js2 ()
  (guide-key/add-local-guide-key-sequence "C-c"))
(defun guide-key/for-org ()
  (guide-key/add-local-guide-key-sequence "C-c"))

;; (add-hook 'js2-mode-hook 'guide-key/for-js2)
;; (add-hook 'org-mode-hook 'guide-key/for-org)
