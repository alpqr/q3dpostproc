Testbed for offscreen rendering and compositing with Qt3D.

Demos how a UI-oriented scenegraph with the two typical passes (first an opaque pass with depth test,
then an optional back-to-front, blend-enabled, no-depth transparent pass) could be implemented inside the
offscreen layers.

Additionally, it demonstrates doing a depth pre-pass for the entire scene in order to generate a depth texture
to help early Z for opaque objects, or for other uses.
