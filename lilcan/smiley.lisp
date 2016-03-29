(load "~/quicklisp/setup.lisp")
(ql:quickload "lispbuilder-sdl")
(ql:quickload "cl-opengl")
(ql:quickload "cl-glu")


(defparameter *the-texture* (car (gl:gen-textures 1)))
(defparameter	texture-data 	#(#xff #x00 #x00 #x00 #x00 #x00 #x00 #xff
						                  #x00 #x00 #xff #xff #xff #xff #x00 #x00
						                  #x00 #xff #x00 #xff #xff #x00 #xff #x00
						                  #x00 #xff #xff #xff #xff #xff #xff #x00
						                  #x00 #xff #x00 #xff #xff #x00 #xff #x00
						                  #x00 #xff #x30 #x00 #x00 #x30 #xff #x00
						                  #x00 #x00 #xff #xf2 #xff #xff #x00 #x00
						                  #xff #x00 #x00 #x00 #x00 #x00 #x00 #xff))

(defun make-my-texture (the-texture the-tex-data)
	(gl:bind-texture :texture-2d the-texture)
  (gl:tex-parameter :texture-2d :texture-min-filter :nearest)
  (gl:tex-parameter :texture-2d :texture-mag-filter :nearest)
  (gl:tex-parameter :texture-2d :texture-wrap-s :clamp-to-edge)
  (gl:tex-parameter :texture-2d :texture-wrap-t :clamp-to-edge)
  (gl:tex-parameter :texture-2d :texture-border-color '(0 0 0 0))
  (gl:tex-image-2d :texture-2d 0 :rgba 8 8 0 :luminance :unsigned-byte the-tex-data))

(defun draw ()
  "draw a frame"
  (gl:clear :color-buffer-bit)
  ;; if our texture is loaded, activate it and turn on texturing
  (gl:enable :texture-2d)

  (when *the-texture*
    (gl:bind-texture :texture-2d *the-texture*))
  ;; draw the entire square white so it doens't interfere with the texture
  (gl:color 1 1 1)
  ;; draw a square
  (gl:with-primitive :quads
    ;; we need to specify a texture coordinate for every vertex now...
    (gl:tex-coord 0 1)
    (gl:vertex -1 -1 0)
    (gl:tex-coord 1 1)
    (gl:vertex  1 -1 0)
    (gl:tex-coord 1 0)
    (gl:vertex  1  1 0)
    (gl:tex-coord 0 0)
    (gl:vertex -1  1 0))
  ;; finish the frame
  (gl:flush)
  (sdl:update-display))

(defun myinit ()
	(sdl:window 320 240 :flags sdl:sdl-opengl)
  ;; cl-opengl needs platform specific support to be able to load GL
  ;; extensions, so we need to tell it how to do so in lispbuilder-sdl
  (setf cl-opengl-bindings:*gl-get-proc-address* #'sdl-cffi::sdl-gl-get-proc-address)
  (make-my-texture *the-texture* texture-data))

(defun myexit ()
	(gl:delete-textures (list *the-texture*)))



(defun main-loop ()
  (sdl:with-init ()
    (myinit)
    (sdl:with-events ()
      (:quit-event () t)
      (:idle ()
             (draw)))
    (myexit)))


(main-loop)