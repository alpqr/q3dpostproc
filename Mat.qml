import Qt3D.Core 2.0
import Qt3D.Render 2.0

Material {
    effect: Effect {
        techniques: [
            Technique {
                FilterKey { id: depthKey; name: "pass"; value: "depth" }
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
                        filterKeys: [ depthKey ]
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
                                depthFunction: DepthTest.LessOrEqual
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
