完整版本  https://www.jianshu.com/p/37f763e0805a

## 一.插件介绍

https://github.com/papyros/qml-material
相对于内置QtQucik Material 风格,这个插件是实现Material Design 所有规范要求的UI 控件,因此结合Qt Qml 可快速开发符合Material风格的App

本次是在Qt 5.11 ,用QtCreator编译运行, 操作系统是Mac OS X.

编译插件本身非常简单,只用QtCreator 打开qml-material.pro .选中平台编译即可编译相应插件


![image.png](https://upload-images.jianshu.io/upload_images/1493747-09ccb63697d945e9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


这个项目很早很早就停更了,因此要想运行演示程序,需要做一些额外操作

## 二.Mac OS X 版本运行演示
在项目配置make 步骤增加 install 目标
 ![
](https://upload-images.jianshu.io/upload_images/1493747-bbaa98fb4f5a05de.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这样Mac OS X 编译后插件直接安装Qt Mac 版本系统的 plugin目录,

我的Qt  Mac 目录是 /Users/pro/Qt5.11.1/5.11.1/clang_64,则插件安装在目录
/Users/pro/Qt5.11.1/5.11.1/clang_64/qml/Material
![image.png](https://upload-images.jianshu.io/upload_images/1493747-1119ee6c987d1d6c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

但是demo 运行死活找不到相应插件.因此根据引用第三方qml 插件步骤.调整一下源码,
把demo源码和编译好插件直接拷入新的目录

有如下目录结构,
  |+ -- demo
  |
  |+--  Material

![下hhh](https://upload-images.jianshu.io/upload_images/1493747-e3e7fc67fc785c68.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

修改demo.pro 
```
TEMPLATE = app

QT += qml quick


SOURCES += main.cpp
RESOURCES += demo.qrc icons/icons.qrc


QML_IMPORT_PATH = $$PWD/../   #新增语句,指向Material 上一级目录
message($$QML_IMPORT_PATH)
```
修改 main.cpp 增加导入目径(重要)  engine.addImportPath()
```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

     QQmlApplicationEngine engine;
//这里指向插件所在目录
       engine.addImportPath("/Users/pro/Documents/other-workspace/qt-workspace/qml-material/Material"); 
       engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
```
这样直接在QtCreator 运行即可.
![](https://upload-images.jianshu.io/upload_images/1493747-61a9a3e295c41b18.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

响应式界面
![image.png](https://upload-images.jianshu.io/upload_images/1493747-ca756409ffbf8f7f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/1493747-fc97e6b1089ac0d6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![image.png](https://upload-images.jianshu.io/upload_images/1493747-eb01abc2007017f0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##三.plugins.qmltypes 生成
在测试时,Android /iOS版本发现,运行总是提醒

>W libdemo.so: [qrc:/main.qml:2](qrc:/main.qml:2) module "Material" is not installed
>W libdemo.so: [qrc:/main.qml:3](qrc:/main.qml:3) module "Material.ListItems" is not installed

查阅资料发现,这安装不成功原因之一是qmldir 里缺少 qmltypes文件.生成qmltypes的方法之一是使用qmlplugindump
在插件qmldir所在目录执行

>/Users/pro/Qt5.11.1/5.11.1/clang_64/bin/qmlplugindump -v -nonrelocatable Material  0.3 . > plugins.qmltypes

但很不幸每次执行就报错:
> QQmlComponent: Component is not ready
file:///Users/pro/Documents/other-workspace/qt-workspace/qml-material/demo/Material/qmldir: plugin cannot be loaded for module "": Module namespace 'Material' does not match import URI ''



看人有在Qt 5.6.3 下是成功,估计是版本原因.因此换成ubunt 下Qt 5.6.3导出成功
>/home/hxy/Qt5.6.3/5.6.3/gcc_64/bin/qmlplugindump -v -nonrelocatable Material  0.3 . > plugins.qmltypes
/home/hxy/Qt5.6.3/5.6.3/gcc_64/bin/qmlplugindump -v -nonrelocatable Material.Extras 0.1 . > plugins.qmltypes
/home/hxy/Qt5.6.3/5.6.3/gcc_64/bin/qmlplugindump -v -nonrelocatable Material.ListItems 0.1 . > plugins.qmltypes




第一次导出提示有一个错误:

>file:///home/hxy/Qt5.6.3/5.6.3/gcc_64/qml/Material/ThemePalette.qml:44: ReferenceError: theme is not defined

这个qml缺省值theme找不到,注释后生成qmltypes文件
```json
  //property color accentColor :  theme.accentColor
//将其注释掉
  property color accentColor
 ```

编译Android 运行后提示
```
Warnings while parsing QML type information of /Users/pro/Documents/other-workspace/qt-workspace/qml-material/demo/Material:
Failed to parse "/Users/pro/Documents/other-workspace/qt-workspace/qml-material/demo/Material/plugins.qmltypes".
Error: /Users/pro/Documents/other-workspace/qt-workspace/qml-material/demo/Material/plugins.qmltypes:585:19: Expected string literal to contain 'Package/Name major.minor' or 'Name major.minor'.
/Users/pro/Documents/other-workspace/qt-workspace/qml-material/demo/Material/plugins.qmltypes:586:36: Expected array literal with only number literal members.
/Users/pro/Documents/other-workspace/qt-workspace/qml-material/demo/Material/plugins.qmltypes:1803:19: Expected string literal to contain 'Package/Name major.minor' or 'Name major.minor'.
/Users/pro/Documents/other-workspace/qt-workspace/qml-material/demo/Material/plugins.qmltypes:1804:36: Expected array literal with only number literal members.
```
查看相应内容,是出现-1,这样版本号
```json
  Component {
        prototype: "QObject"
        name: "Object -1.-1"
        exports: ["Object -1.-1"]
        exportMetaObjectRevisions: [-1]
        isComposite: true
        defaultProperty: "children"
        Property { name: "__childrenFix"; type: "QObject"; isList: true; isReadonly: true }
        Property { name: "children"; type: "QObject"; isList: true; isReadonly: true }
    }
```
将其改为
```json
Component {
        prototype: "QObject"
        name: "Object 0.1"
        exports: ["Object 0.1"]
        exportMetaObjectRevisions: [0]
        isComposite: true
        defaultProperty: "children"
        Property { name: "__childrenFix"; type: "QObject"; isList: true; isReadonly: true }
        Property { name: "children"; type: "QObject"; isList: true; isReadonly: true }
    }
```
##四. Android运行Material 演示
总结: 这套样式,对于如何用QML开发一个完整样式,有一定借鉴经验,但只在windows/Mac下测试通过,无法在Android运行.以下是部分运行测试经验,方
因为完成一半的代码 在 https://github.com/work4blue/qml-material 
这里直接编译qml--material 只要编译,demo.apk,在最后一步因为找不到插件报错.
因些我们分两步,先用src.pro 单独编译出插件来,
它是在编译目录的下的目录输出.
build-src-Android_for_armeabi_v7a_GCC_4_9_Qt_5_11_1_for_Android_armv7-Release/android-build/Users/pro/Qt5.11.1/5.11.1/android_armv7/qml/Material/qmldir


它最终会编译出 libmaterial.so 和一系统的qml 出来.但是apk,不可能使用单独目录来放插件及相关qml,因此只能将其编译资源文件来引用.

```
Failed to notify ProjectEvaluationListener.afterEvaluate(), but primary configuration failure takes precedence.
java.lang.IllegalStateException: buildToolsVersion is not specified.


E AndroidRuntime: java.lang.UnsatisfiedLinkError: dlopen failed: library "libmaterial.so" not found


libdemo.so: (null):0 ((null)): [qrc:/main.qml:2](qrc:/main.qml:2) module "Material" is not installed


https://forum.qt.io/topic/40464/deploy-qml-plugin-on-android-device


https://github.com/luoyayun361/QML-Android-ScanCode


https://forum.qt.io/topic/75452/problem-with-custom-plugin-for-qtquick-on-ios/8
 
/Users/pro/Qt5.11.1/5.11.1/clang_64/bin/qmlplugindump -v -nonrelocatable Material  0.3 . > plugins.qmltypes

file:///home/hxy/Qt5.6.3/5.6.3/gcc_64/qml/Material/ThemePalette.qml:44: ReferenceError: theme is not defined
hxy@hxy-dev:~/Qt5.6.3/5.6.3/gc


/Users/pro/Qt5.11.1/5.11.1/android_armv7/qml/QtQuick/Controls.2/Material/


Input file: /Users/pro/Documents/other-workspace/qt-workspace/qml-material-develop/build-demo-Android_for_armeabi_v7a_GCC_4_9_Qt_5_11_1_for_Android_armv7-Release/android-libdemo.so-deployment-settings.json
```

可到代码 https://github.com/work4blue/qml-material 下载