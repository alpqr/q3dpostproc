// taken from examples/qt3d/simple-qml

import QtQuick 2.2 as QQ2
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

Entity {
    property variant targetLayerOpaque
    property variant targetLayerTrans

    Material {
        id: material
        effect: Effect {
            techniques: [
                Technique {
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

    TorusMesh {
        id: torusMesh
        radius: 5
        minorRadius: 1
        rings: 100
        slices: 20
    }

    Transform {
        id: torusTransform
        scale3D: Qt.vector3d(1.5, 1, 0.5)
        rotation: fromAxisAndAngle(Qt.vector3d(1, 0, 0), 45)
    }

    Entity {
        id: torusEntity
        components: [ targetLayerTrans, torusMesh, material, torusTransform ]

        Entity {
            Transform {
                id: childTorusTrans
                translation: Qt.vector3d(5, 6, -20) // change z to 20 verify back-to-front sorting is indeed active
            }
            components: [ targetLayerTrans, torusMesh, material, childTorusTrans ]
        }
    }

    SphereMesh {
        id: sphereMesh
        radius: 3
    }

    Transform {
        id: sphereTransform
        property real userAngle: 0.0
        matrix: {
            var m = Qt.matrix4x4();
            m.rotate(userAngle, Qt.vector3d(0, 1, 0));
            m.translate(Qt.vector3d(12, 0, 0));
            return m;
        }
    }

    QQ2.NumberAnimation {
        target: sphereTransform
        property: "userAngle"
        duration: 10000
        from: 0
        to: 360

        loops: QQ2.Animation.Infinite
        running: true
    }

    Entity {
        id: sphereEntity
        components: [ targetLayerOpaque, sphereMesh, material, sphereTransform ]

        Entity {
            id: someChildEntity
            Transform {
                id: childTr
                translation: Qt.vector3d(0, 6, 6)
            }
            components: [ targetLayerOpaque, sphereMesh, material, childTr ]
        }
    }
}
