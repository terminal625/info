(ql:quickload "cl-opengl") 
(ql:quickload "cl-glu")
(ql:quickload "lispbuilder-sdl")

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

(defun random-hue ()
  (/ (random 1024) 1024))

(defun random-gl-color ()
  (gl:color (random-hue) (random-hue) (random-hue)))


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

  ;; draw a triangle
  (gl:with-primitive :triangles
    (gl:color 1 0 0)
    (gl:vertex -1 -1 0) ;;  hmm, i need to add an option to the syntax
    (gl:color 0 1 0)
    (gl:vertex 0 1 0)   ;;  highlighting to show changed lines...
    (gl:color 0 0 1)
    (gl:vertex 1 -1 0)) ;; (this one changed too)
  ;; finish the frame
  (gl:flush)
  (sdl:update-display))
