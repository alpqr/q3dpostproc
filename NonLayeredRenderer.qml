// This is in effect equivalent to just adding ForwardRenderer { }
// but skip the convenience now for the demo's sake

import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0

RenderSurfaceSelector {
    property alias sceneCamera: cameraSelector.camera
    property alias sceneLayer: sceneLayer

    Layer { id: sceneLayer }

    Viewport {
        normalizedRect: Qt.rect(0, 0, 1, 1)

        CameraSelector {
            id: cameraSelector

            ClearBuffers {
                clearColor: Qt.rgba(0, 0.5, 1, 1)
                buffers: ClearBuffers.ColorDepthStencilBuffer

                FrustumCulling {
                }
            }
        }
    }
}
