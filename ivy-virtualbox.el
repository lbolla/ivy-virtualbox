;;; package --- Control virtualbox with ivy
;;; Commentary:
;;; 18 January 2021
;;; TODO
;;; - add more vboxmanage commands

;;; Code:

(defun ivy-virtualbox--status (candidate)
  "Show CANDIDATE status."
  (let ((vm-info (shell-command-to-string (format "VBoxManage showvminfo \"%s\"" candidate))))
    (save-match-data
      (and (string-match "^State:\\s-*\\(.*\\)$" vm-info)
           (message (format "%s: %s" candidate (match-string 1 vm-info)))))))

(defun ivy-virtualbox--start (candidate)
  "Start CANDIDATE."
  (message "Starting VM")
  (shell-command (format "VBoxManage startvm \"%s\"" candidate)))

(defun ivy-virtualbox--pause (candidate)
  "Pause CANDIDATE."
  (message "Pausing VM")
  (shell-command (format "VBoxManage controlvm \"%s\" pause" candidate)))

(defun ivy-virtualbox--resume (candidate)
  "Resume CANDIDATE."
  (message "Resuming VM")
  (shell-command (format "VBoxManage controlvm \"%s\" resume" candidate)))

(defun ivy-virtualbox--reset (candidate)
  "Reset CANDIDATE."
  (message "Resetting VM")
  (shell-command (format "VBoxManage controlvm \"%s\" reset" candidate)))

(defun ivy-virtualbox--poweroff (candidate)
  "Power CANDIDATE off (unsafe)."
  (message "Powering off VM")
  (shell-command (format "VBoxManage controlvm \"%s\" poweroff" candidate)))

(defun ivy-virtualbox--save-state (candidate)
  "Save CANDIDATE state."
  (message "Saving VM status")
  (shell-command (format "VBoxManage controlvm \"%s\" savestate" candidate)))

(defun ivy-virtualbox--shutdown (candidate)
  "Shutdown CANDIDATE (safe)."
  (message "Saving VM status")
  (shell-command (format "VBoxManage controlvm \"%s\" acpipowerbutton" candidate)))

(defun ivy--virtualbox-vms (prefix)
  "Return a list of VMs.  Only 'running' if PREFIX."
  (let* ((what (if prefix "runningvms" "vms"))
         (cmd (format "VBoxManage list %s" what)))
    (mapcar (lambda (str) (string-trim (car (split-string str "\" ")) "\"" "\""))
            (split-string (string-trim (shell-command-to-string cmd)) "\n"))))

;;;###autoload
(defun ivy-virtualbox (prefix)
  "Control Virtual Box VMs.  List 'running' only if PREFIX."
  (interactive "P")
  (ivy-read "VirtualBox: "
            (ivy--virtualbox-vms prefix)
            :require-match t
            :sort t
            :action '(1
                      ("i" ivy-virtualbox--status "status")
                      ("s" ivy-virtualbox--start "start")
                      ("p" ivy-virtualbox--pause "pause")
                      ("r" ivy-virtualbox--resume "resume")
                      ("w" ivy-virtualbox--save-state "save state")
                      ("x" ivy-virtualbox--reset "reset")
                      ("k" ivy-virtualbox--shutdown "shutdown")
                      ("z" ivy-virtualbox--poweroff "poweroff"))))

(provide 'ivy-virtualbox)
;;; ivy-virtualbox.el ends here
