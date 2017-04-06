TEMPLATE = app

QT += qml quick 3dcore 3drender 3dinput 3dquick 3dquickextras

SOURCES += \
    main.cpp

OTHER_FILES += \
    main.qml \
    Scene.qml \
    NonLayeredRenderer.qml \
    LayeredRenderer.qml \
    TextureRenderTarget.qml \
    compositor.vert \
    compositor.frag

RESOURCES += \
    q3dpostproc.qrc
