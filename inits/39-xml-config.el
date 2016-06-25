(add-hook 'nxml-mode-hook
          (lambda ()
            (sgml-mode)
            (sgml-electric-tag-pair-mode t)
            ;; (make-local-variable 'indent-tabs-mode)
            ;; (setq indent-tabs-mode nil)
            ;; (make-local-variable 'tab-width)
            (setq tab-width 4)
            ))
(use-package sgml-mode
  :commands (sgml-mode)
  :config
     (setq sgml-basic-offset 4)
     (define-key sgml-mode-map (kbd "RET") 'xml-newline)
     (define-key sgml-mode-map (kbd "SPC") 'my-xml-close-block)
  )

;;;###autoload
(defun xml-newline ()
  (interactive)
  (if (check-block-start)
      (save-excursion
        (sgml-close-tag)))
  (newline)
  (save-excursion (newline))
  (indent-for-tab-command)
  )
;;;###autoload
(defun my-xml-close-block ()
  (interactive)
  (if (check-block-start)
      (save-excursion
        (sgml-close-tag))

    (insert " ")
    ))

(defun check-block-start ()
  (equal (string (preceding-char)) ">")
  )
