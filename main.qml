import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

Entity {
    components: [
        RenderSettings {
            activeFrameGraph: RenderSurfaceSelector {
                id: surfaceSelector

                // Offscreen framegraph
                OffscreenLayer {
                    id: offscreenLayer
                    width: surfaceSelector.surface ? surfaceSelector.surface.width : 512
                    height: surfaceSelector.surface ? surfaceSelector.surface.height : 512
                }

                // Compositor framegraph
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
        },
        InputSettings { }
    ]

    Layer { id: compositorLayer }

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
                Parameter { name: "tex"; value: offscreenLayer.renderTarget.colorTexture }
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
                                fragmentShaderCode: loadSource("qrc:/compositor.frag")
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
}
