import Qt3D.Core 2.0
import Qt3D.Render 2.0

RenderTarget {
    id: rt

    property real width: 512
    property real height: 512

    property alias colorTexture: colorTexture
    property variant depthTexture

    attachments : [
        RenderTargetOutput {
            attachmentPoint: RenderTargetOutput.Color0
            texture: Texture2D {
                id: colorTexture
                width: rt.width
                height: rt.height
                format: Texture.RGBA8_UNorm
                minificationFilter: Texture.Linear
                magnificationFilter: Texture.Linear
            }
        },
        RenderTargetOutput {
            attachmentPoint: RenderTargetOutput.Depth
            texture: depthTexture
        }
    ]
}
