#import <React/RCTViewManager.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#import <SDWebImagePhotosPlugin/SDWebImagePhotosPlugin.h>
#import <SDWebImageVideoCoder/SDWebImageVideoCoder.h>
#import <SDWebImageAVIFCoder/SDImageAVIFCoder.h>
#import <SDWebImageWebPCoder/SDImageWebPCoder.h>


#if !defined(RCT_NEW_ARCH_ENABLED) || RCT_NEW_ARCH_ENABLED == 0

@interface FFFastImageViewManager : RCTViewManager
 // call this from your AppDelegate in order for customizations to work
+ (void)setup:(NSDictionary *)params;
+ (SDImageCache *)primaryCache;
+ (SDImageCache *)secondaryCache;
@end

#endif