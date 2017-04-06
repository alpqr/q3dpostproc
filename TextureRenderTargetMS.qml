import Qt3D.Core 2.0
import Qt3D.Render 2.0

RenderTarget {
    id: rt

    property real width: 512
    property real height: 512

    property alias colorTexture: colorTexture
    property alias depthTexture: depthTexture

    attachments : [
        RenderTargetOutput {
            attachmentPoint: RenderTargetOutput.Color0
            texture: Texture2DMultisample {
                samples: 4
                id: colorTexture
                width: rt.width
                height: rt.height
                format: Texture.RGBA8_UNorm
            }
        },
        RenderTargetOutput {
            attachmentPoint : RenderTargetOutput.Depth
            texture : Texture2DMultisample {
                samples: 4
                id: depthTexture
                width: rt.width
                height: rt.height
                format: Texture.D24
            }
        }
    ]
}
