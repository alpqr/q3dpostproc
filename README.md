Testbed for offscreen rendering and compositing with Qt3D.

The real thing is in the LayerTest branch: this also demos how a UI-oriented scenegraph
with the two typical passes (first an opaque pass with depth test, then an optional
back-to-front, blend-enabled, no-depth transparent pass) could be implemented inside the
offscreen layers.
