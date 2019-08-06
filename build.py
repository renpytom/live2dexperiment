#!/usr/bin/env python3

import subprocess
import os

framework_source = """
    src/Effect/CubismBreath.cpp
    src/Effect/CubismEyeBlink.cpp
    src/Effect/CubismPose.cpp

    src/Id/CubismId.cpp
    src/Id/CubismIdManager.cpp

    src/Math/CubismMath.cpp
    src/Math/CubismMatrix44.cpp
    src/Math/CubismModelMatrix.cpp
    src/Math/CubismTargetPoint.cpp
    src/Math/CubismVector2.cpp
    src/Math/CubismViewMatrix.cpp

    src/Model/CubismModel.cpp
    src/Model/CubismModelUserData.cpp
    src/Model/CubismModelUserDataJson.cpp
    src/Model/CubismUserModel.cpp
    src/Model/CubismMoc.cpp

    src/Motion/CubismExpressionMotion.cpp
    src/Motion/CubismMotion.cpp
    src/Motion/CubismMotionJson.cpp
    src/Motion/CubismMotionManager.cpp
    src/Motion/CubismMotionQueueEntry.cpp
    src/Motion/CubismMotionQueueManager.cpp
    src/Motion/ACubismMotion.cpp

    src/Physics/CubismPhysicsJson.cpp
    src/Physics/CubismPhysics.cpp

    src/Rendering/CubismRenderer.cpp

    src/Type/csmRectF.cpp
    src/Type/csmString.cpp

    src/Utils/CubismDebug.cpp
    src/Utils/CubismJson.cpp
    src/Utils/CubismString.cpp

    src/CubismDefaultParameterId.cpp
    src/CubismFramework.cpp
    src/CubismModelSettingJson.cpp
    src/CubismCdiJson.cpp
""".split()

main_source = """
    LAppAllocator.cpp
    LAppPal.cpp
    main.cpp
""".split()


def compile(src):

    obj = "build/" + os.path.basename(src.replace(".cpp", ".o"))

    subprocess.check_call([
        "ccache",
        "g++",
        "-c",
        "-o", obj,
        "-ggdb",
        "-I.",
        "-ICubism3SDKforNative/Core/include",
        "-ICubism3SDKforNative/Framework/src",
        src,
        ])

    return obj


def main():

    objects = [ ]

    for src in framework_source:
        objects.append(compile("Cubism3SDKforNative/Framework/" + src))

    for src in main_source:
        objects.append(compile(src))

    subprocess.check_call([
        "g++",
        "-o", "main",
        "-no-pie",
        ] + objects + [
        "Cubism3SDKforNative/Core/lib/linux/x86_64/libLive2DCubismCore.a",
        ])


if __name__ == "__main__":
    main()
