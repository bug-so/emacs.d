;; (defun gcm-scroll-down ()
;;   (interactive)
;;   (scroll-up 1))

;; (defun gcm-scroll-up ()
;;   (interactive)
;;   (scroll-down 1))

;; (global-set-key [(control down)] 'gcm-scroll-down)
;; (global-set-key [(control up)]   'gcm-scroll-up)

(defun sfp-page-down ()
  (interactive)
  (next-line
   (- (window-text-height)
      next-screen-context-lines)))

(defun sfp-page-up ()
  (interactive)
  (previous-line
   (- (window-text-height)
      next-screen-context-lines)))

(define-key global-map [remap scroll-up-command] 'sfp-page-down)
(define-key global-map [remap scroll-down-command] 'sfp-page-up)

;; 一時的に無効化中
(use-package sublimity
  :config
  (setq sublimity-auto-hscroll-mode nil)
  (sublimity-mode t)
  (use-package sublimity-scroll
    :config
    (setq sublimity-scroll-weight 3)
    (setq sublimity-scroll-drift-length 5)
    )
  ;; (add-hook 'isearch-mode-hook
  ;;           (lambda ()
  ;;             (sublimity-mode t)))
  ;; (add-hook 'isearch-mode-end-hook
  ;;           (lambda () (sublimity-mode -1)))
  )
