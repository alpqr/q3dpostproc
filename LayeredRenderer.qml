import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0

RenderSurfaceSelector {
    id: surfaceSelector

    property alias sceneCamera: cameraSelector.camera
    property alias sceneLayer: sceneLayer

    Layer { id: sceneLayer }
    Layer { id: compositorLayer }

    // Pass 1: render the scene into a texture

    //TextureRenderTarget {
    TextureRenderTargetMS {
        id: rt
        width: surfaceSelector.surface ? surfaceSelector.surface.width : 512
        height: surfaceSelector.surface ? surfaceSelector.surface.height : 512
    }

    LayerFilter {
        layers: [ sceneLayer ]
        RenderTargetSelector {
            target: rt
            Viewport {
                normalizedRect: Qt.rect(0, 0, 1, 1)
                CameraSelector {
                    id: cameraSelector
                    ClearBuffers {
                        clearColor: Qt.rgba(0, 0.5, 1, 1)
                        buffers: ClearBuffers.ColorDepthBuffer
                        FrustumCulling { }
                    }
                }
            }
        }
    }

    // Pass 2: get something into the default framebuffer

    Entity {
        components: [
            compositorLayer,
            quadMesh,
            quadTrans,
            compositorMaterial
        ]

        PlaneMesh {
            id: quadMesh
            width: 2
            height: 2
        }

        Transform {
            id: quadTrans
            rotationX: -90
        }

        Material {
            id: compositorMaterial
            parameters: [
                Parameter { name: "tex"; value: rt.colorTexture }
            ]
            effect: Effect {
                techniques: [
                    Technique {
                        graphicsApiFilter {
                            api: GraphicsApiFilter.OpenGL
                            majorVersion: 3
                            minorVersion: 2
                            profile: GraphicsApiFilter.CoreProfile
                        }
                        renderPasses: RenderPass {
                            shaderProgram: ShaderProgram {
                                vertexShaderCode: loadSource("qrc:/compositor.vert")
                                //fragmentShaderCode: loadSource("qrc:/compositor.frag")
                                fragmentShaderCode: loadSource("qrc:/compositor_ms.frag")
                            }
                            renderStates: [
                                FrontFace {
                                    direction: FrontFace.ClockWise
                                }
                            ]
                        }
                    }
                ]
            }
        }
    }

    Camera {
        id: compositorCamera
        left: -1
        right: 1
        bottom: -1
        top: 1
        projectionType: CameraLens.OrthographicProjection
        position: Qt.vector3d(0, 0, 1)
        viewCenter: Qt.vector3d(0, 0, 0)
    }

    LayerFilter {
        layers: [ compositorLayer ]
        Viewport {
            normalizedRect: Qt.rect(0, 0, 1, 1)
            CameraSelector {
                camera: compositorCamera
                ClearBuffers {
                    clearColor: "black"
                    buffers: ClearBuffers.ColorDepthBuffer
                }
            }
        }
    }
}
