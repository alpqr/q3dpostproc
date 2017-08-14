TEMPLATE = app

QT += qml quick 3dcore 3drender 3dinput 3dquick 3dquickextras

SOURCES += \
    main.cpp

OTHER_FILES += \
    main.qml \
    Scene.qml \
    OffscreenLayer.qml \
    TextureRenderTarget.qml \
    TextureRenderTargetMS.qml \
    compositor.vert \
    compositor.frag \
    compositor_ms.frag \
    scene.vert \
    scene_o.frag \
    scene_t.frag

RESOURCES += \
    q3dpostproc.qrc
