#pragma once

#include "filesystem/import.h"

namespace Surge::Platform
{
// Each iOS executable owns its factory data, including when loaded by another app.
fs::path iosFactoryDataPath();
}
