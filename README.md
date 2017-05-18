Testbed for offscreen rendering and compositing with Qt3D.

The real thing is in the LayerTest branch. This demos how a UI-oriented scenegraph
with the typical two passes (first an opaque pass with depth test, then an optional
back-to-front, blend-enabled, no-depth transparent pass) could be implemented on top
of Qt3D.
