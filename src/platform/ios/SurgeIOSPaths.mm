#include "SurgeIOSPaths.h"
#import <Foundation/Foundation.h>

// Resolving this class's bundle avoids looking in the AUv3 host application's bundle.
@interface SurgeIOSBundleAnchor : NSObject
@end

@implementation SurgeIOSBundleAnchor
@end

namespace Surge::Platform
{
fs::path iosFactoryDataPath()
{
    auto *bundle = [NSBundle bundleForClass:[SurgeIOSBundleAnchor class]];
    auto *path = [[bundle resourcePath] stringByAppendingPathComponent:@"SurgeXTData"];
    return fs::path{[path fileSystemRepresentation]};
}
}
