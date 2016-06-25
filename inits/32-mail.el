(use-package wl
  :commands (wl)
  :config
  (setq user-mail-address "s092018@ike.tottori-u.ac.jp")
  (setq user-full-name "Shin Osaki")
  (setq smtpmail-smtp-server "smtp-ike.ike.tottori-u.ac.jp")
  (setq mail-user-agent 'message-user-agent)
  (setq message-send-mail-function 'message-smtpmail-send-it)
  (add-to-list 'auto-mode-alist '(".wl$" . emacs-lisp-mode))
  (use-package helm-wl-address)
  )
