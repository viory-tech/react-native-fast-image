#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <RNFastImage/FFFastImageViewManager.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"ReactNativeFastImageExample";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};
  
  [FFFastImageViewManager setup:@{@"primaryMemoryCacheSizeMB":@100,
                                  @"secondaryMemoryCacheSizeMB":@100,
                                  @"primaryDiskCacheSizeMB":@250,
                                  @"secondaryDiskCacheSizeMB":@250}];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self bundleURL];
}

- (NSURL *)bundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
