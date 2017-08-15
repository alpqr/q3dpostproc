import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0

RenderTargetSelector {
    id: offscreenLayer
    target: rt

    property alias renderTarget: rt
    property alias width: rt.width
    property alias height: rt.height

    Layer { id: sceneLayerOpaque }
    Layer { id: sceneLayerTrans }

    Scene {
        targetLayerOpaque: sceneLayerOpaque
        targetLayerTrans: sceneLayerTrans
        FirstPersonCameraController { camera: sceneCamera }
    }

    TextureRenderTarget {
        id: rt
        depthTexture: depthRt.depthTexture
    }

    DepthRenderTarget {
        id: depthRt
        width: rt.width
        height: rt.height
    }

    Camera {
        id: sceneCamera
        projectionType: CameraLens.PerspectiveProjection
        fieldOfView: 45
        aspectRatio: rt.width / rt.height
        position: Qt.vector3d( 0.0, 0.0, 40.0 )
        upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
        viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
    }

    // Depth pre-pass
    RenderTargetSelector {
        target: depthRt
        Viewport {
            normalizedRect: Qt.rect(0, 0, 1, 1)
            CameraSelector {
                camera: sceneCamera
                ClearBuffers {
                    buffers: ClearBuffers.DepthBuffer
                    NoDraw { }
                }
                RenderPassFilter {
                    matchAny: [ FilterKey { name: "pass"; value: "depth" } ]
                    FrustumCulling {
                        LayerFilter {
                            layers: [ sceneLayerOpaque ]
                        }
                    }
                }
                // To help early Z the depth buffer is reused in the later passes (won't be cleared).
                // This assumes that transparent objects are not in there.
                // To get a full depth texture suitable for other purposes, reenable this.
//                RenderPassFilter {
//                    matchAny: [ FilterKey { name: "pass"; value: "depth" } ]
//                    SortPolicy {
//                        sortTypes: [ SortPolicy.BackToFront ]
//                        FrustumCulling {
//                            LayerFilter {
//                                layers: [ sceneLayerTrans ]
//                            }
//                        }
//                    }
//                }
            }
        }
    }

    // Opaque+transparent passes onto the normal render target
    Viewport {
        normalizedRect: Qt.rect(0, 0, 1, 1)
        CameraSelector {
            camera: sceneCamera
            // clear first always (opaque list may be empty so ClearBuffers must not be a child there)
            ClearBuffers {
                clearColor: Qt.rgba(0, 0.5, 1, 1)
                buffers: ClearBuffers.ColorBuffer // don't clear depth -> reusing existing depth buffer
                NoDraw { }
            }
            RenderPassFilter {
                matchAny: [ FilterKey { name: "pass"; value: "opaque" } ]
                FrustumCulling {
                    LayerFilter {
                        layers: [ sceneLayerOpaque ]
                    }
                }
            }
            RenderPassFilter {
                matchAny: [ FilterKey { name: "pass"; value: "transparent" } ]
                SortPolicy {
                    sortTypes: [ SortPolicy.BackToFront ]
                    FrustumCulling {
                        LayerFilter {
                            layers: [ sceneLayerTrans ]
                        }
                    }
                }
            }
        }
    }
}
