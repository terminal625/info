(load "~/quicklisp/setup.lisp")
(load (merge-pathnames "render.lisp" *load-truename*))
(ql:quickload "lispbuilder-sdl")

(defun myinit ()
	(sdl:window 720 480 :title-caption "a fuck made by terminal256" :flags '(sdl:sdl-opengl))
  (setf (sdl:frame-rate) 60)

  ;; cl-opengl needs platform specific support to be able to load GL
  ;; extensions, so we need to tell it how to do so in lispbuilder-sdl
  (setf cl-opengl-bindings:*gl-get-proc-address* #'sdl-cffi::sdl-gl-get-proc-address)
  (sdl-cffi::sdl-wm-grab-input sdl-cffi::sdl-enable)
  (sdl-cffi::sdl-show-cursor sdl-cffi::sdl-disable)
  (sdl:disable-key-repeat)
  (make-my-texture *the-texture* texture-data))

(defun myexit ()
	(gl:delete-textures (list *the-texture*)))

(defun myloop ()
  (draw))

(defun terminal256 ()
  (sdl:with-init ()
    (myinit)
    (sdl:with-events ()
      (:quit-event () t)
      (:key-down-event ()
        (sdl:push-quit-event))
      (:idle ()
             (myloop)))
    (myexit)))


(terminal256)