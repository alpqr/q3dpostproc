import Qt3D.Core 2.0
import Qt3D.Render 2.0

RenderTarget {
    id: rt

    property real width: 512
    property real height: 512

    property alias depthTexture: depthTexture

    attachments : [
        RenderTargetOutput {
            attachmentPoint : RenderTargetOutput.Depth
            texture : Texture2D {
                id: depthTexture
                width: rt.width
                height: rt.height
                format: Texture.DepthFormat
                minificationFilter: Texture.Linear
                magnificationFilter: Texture.Linear
                comparisonFunction: Texture.CompareLessEqual
                comparisonMode: Texture.CompareRefToTexture
            }
        }
    ]
}
