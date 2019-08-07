#include <stdio.h>
#include <CubismFramework.hpp>
#include <Rendering/CubismRenderer.hpp>
#include <LAppAllocator.hpp>
#include <LAppPal.hpp>

static LAppAllocator cubismAllocator;              ///< Cubism3 Allocator
static Csm::CubismFramework::Option cubismOption;  ///< Cubism3 Option

Live2D::Cubism::Framework::Rendering::CubismRenderer* Live2D::Cubism::Framework::Rendering::CubismRenderer::Create() {
    return NULL;
}

void  Live2D::Cubism::Framework::Rendering::CubismRenderer::StaticRelease() {
}

using namespace Csm;


int main(int argc, char **argv) {

    //setup cubism
    cubismOption.LogFunction = LAppPal::PrintMessage;
    cubismOption.LoggingLevel = CubismFramework::Option::LogLevel_Verbose; // LAppDefine::CubismLoggingLevel;
    CubismFramework::StartUp(&cubismAllocator, &cubismOption);

    //Initialize cubism
    CubismFramework::Initialize();


    CubismFramework::Dispose();
    CubismFramework::CleanUp();

    return 0;
}

