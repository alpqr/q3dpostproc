import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0

Entity {
    components: [
        RenderSettings {
            activeFrameGraph: LayeredRenderer { id: renderer }
        },
        InputSettings { }
    ]

    Scene {
        targetLayer: renderer.sceneLayer
    }
}
