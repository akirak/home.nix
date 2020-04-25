(in-package :next-user)

;; Use vi-like keybindings for now.
;; TODO: Define a custom keymap.
(defclass default-buffer (buffer)
  ((default-modes :initform
     (cons 'vi-normal-mode (get-default 'buffer 'default-modes)))))

(setf *buffer-class* 'default-buffer)
