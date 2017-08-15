import Qt3D.Core 2.0
import Qt3D.Render 2.0

Material {
    effect: Effect {
        techniques: [
            Technique {
                FilterKey { id: depthOpaqueKey; name: "pass"; value: "depthOpaque" }
                FilterKey { id: depthTransKey; name: "pass"; value: "depthTransparent" }
                FilterKey { id: opaqueKey; name: "pass"; value: "opaque" }
                FilterKey { id: transKey; name: "pass"; value: "transparent" }
                graphicsApiFilter {
                    api: GraphicsApiFilter.OpenGL
                    majorVersion: 3
                    minorVersion: 2
                    profile: GraphicsApiFilter.CoreProfile
                }

                // Here we are simulating the way a UI-oriented scenegraph
                // would work: First an opaque pass with depth testing
                // enabled. Then an optional transparent pass with no depth
                // writes, blending enabled and back-to-front sorting.

                renderPasses: [
                    // Bonus: demonstrate a depth pre-pass
                    RenderPass {
                        filterKeys: [ depthOpaqueKey ]
                        shaderProgram: ShaderProgram {
                            vertexShaderCode: loadSource("qrc:/depth.vert")
                            fragmentShaderCode: loadSource("qrc:/depth.frag")
                        }
                        renderStates: [
                            DepthTest {
                                depthFunction: DepthTest.LessOrEqual
                            },
                            ColorMask {
                                redMasked: false; greenMasked: false; blueMasked: false; alphaMasked: false
                            }
                        ]
                    },
                    // for early Z the transparent pre-pass is probably pointless, but should be there for other uses
                    RenderPass {
                        filterKeys: [ depthTransKey ]
                        shaderProgram: ShaderProgram {
                            vertexShaderCode: loadSource("qrc:/depth.vert")
                            fragmentShaderCode: loadSource("qrc:/depth.frag")
                        }
                        renderStates: [
                            DepthTest {
                                depthFunction: DepthTest.Always
                            },
                            ColorMask {
                                redMasked: false; greenMasked: false; blueMasked: false; alphaMasked: false
                            }
                        ]
                    },
                    RenderPass {
                        filterKeys: [ opaqueKey ]
                        shaderProgram: ShaderProgram {
                            vertexShaderCode: loadSource("qrc:/scene.vert")
                            fragmentShaderCode: loadSource("qrc:/scene_o.frag")
                        }
                        renderStates: [
                            DepthTest {
                                depthFunction: DepthTest.LessOrEqual
                            }
                        ]

                    },
                    RenderPass {
                        filterKeys: [ transKey ]
                        shaderProgram: ShaderProgram {
                            vertexShaderCode: loadSource("qrc:/scene.vert")
                            fragmentShaderCode: loadSource("qrc:/scene_t.frag")
                        }
                        renderStates: [
                            DepthTest {
                                depthFunction: DepthTest.Always // best would be to disable depth testing altogether, but how?
                            },
                            NoDepthMask {
                            },
                            BlendEquation {
                                blendFunction: BlendEquation.Add
                            },
                            BlendEquationArguments {
                                sourceRgb: BlendEquationArguments.One
                                destinationRgb: BlendEquationArguments.OneMinusSourceAlpha
                                sourceAlpha: BlendEquationArguments.One
                                destinationAlpha: BlendEquationArguments.OneMinusSourceAlpha
                            }
                        ]
                    }
                ]
            }
        ]
    }
}