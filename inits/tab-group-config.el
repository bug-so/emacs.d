(el-get 'sync 'tab-group)
(use-package tab-group
  :config
  (tab-group:auto-mode)
  (bind-keys :map tab-group:local-mode-map
             ("M-n" . tab-group:next)
             ("M-p" . tab-group:prev)
             ([f8] . 'tab-group:next-group)
             )
  (custom-set-variables
   '(tab-group:tab-separator " ")
   )
  (set-face-attribute 'tab-group:tab nil
                      :box '(:line-width 1 :color "white" :style released-button))
  (set-face-attribute 'tab-group:tab:active nil
                      :box '(:line-width 1 :color "white" :style pressed-button))
  (add-hook 'find-file-hook (lambda () (tab-group:switch "Fundamental")))
  )



(provide 'tab-group-config)
