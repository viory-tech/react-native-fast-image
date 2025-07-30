#import "FFFastImageViewManager.h"
#import "FFFastImageView.h"

#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>
#ifdef RCT_NEW_ARCH_ENABLED
#import <RNFastImageSpec/RNFastImageSpec.h>
#endif

static SDImageCache *static_cachePrimary = nil;
static SDImageCache *static_cacheSecondary = nil;
static float static_primaryMemoryCacheSizeMB = 100;
static float static_secondaryMemoryCacheSizeMB = 100;
static float static_primaryDiskCacheSizeMB = 200;
static float static_secondaryDiskCacheSizeMB = 200;

@implementation FFFastImageViewManager

RCT_EXPORT_MODULE(FastImageView)

+ (void)setup:(NSDictionary*)params {
    NSLog(@"FFFastImageViewManager setup called");

    if ([params valueForKey: @"primaryMemoryCacheSizeMB"] != nil) {
        static_primaryMemoryCacheSizeMB = [[params valueForKey: @"primaryMemoryCacheSizeMB"] floatValue];
    }
    if ([params valueForKey: @"secondaryMemoryCacheSizeMB"] != nil) {
        static_secondaryMemoryCacheSizeMB = [[params valueForKey: @"secondaryMemoryCacheSizeMB"] floatValue];
    }
    if ([params valueForKey: @"primaryDiskCacheSizeMB"] != nil) {
        static_primaryDiskCacheSizeMB = [[params valueForKey: @"primaryDiskCacheSizeMB"] floatValue];
    }
    if ([params valueForKey: @"secondaryDiskCacheSizeMB"] != nil) {
        static_secondaryDiskCacheSizeMB = [[params valueForKey: @"secondaryDiskCacheSizeMB"] floatValue];
    }
    
    // Supports Photos URL globally (and HTTP as by default)
    SDImagePhotosLoader.sharedLoader.requestImageAssetOnly = NO;
    SDImageLoadersManager.sharedManager.loaders = @[SDWebImageDownloader.sharedDownloader, SDImagePhotosLoader.sharedLoader];

    // Replace default manager's loader implementation with customized loader
    SDWebImageManager.defaultImageLoader = SDImageLoadersManager.sharedManager;
    
    // Add custom coders to global coders manager
    [[SDImageCodersManager sharedManager] addCoder:[SDImageVideoCoder sharedCoder]];
    [[SDImageCodersManager sharedManager] addCoder:[SDImageAVIFCoder sharedCoder]];
    [[SDImageCodersManager sharedManager] addCoder:[SDImageWebPCoder sharedCoder]];
    
    // Setup caches
    // Sizes can be altered by calling [FFFastImageViewManager setup] from your AppDelegate
    static_cachePrimary = [[SDImageCache alloc] initWithNamespace:@"primary"];
    [static_cachePrimary.config setMaxMemoryCost:static_primaryMemoryCacheSizeMB * 1024 * 1024]; // X MB of memory
    [static_cachePrimary.config setMaxDiskSize:static_primaryDiskCacheSizeMB * 1024 * 1024]; // X MB of disk
    
    static_cacheSecondary = [[SDImageCache alloc] initWithNamespace:@"secondary"];
    [static_cacheSecondary.config setMaxMemoryCost:static_secondaryMemoryCacheSizeMB * 1024 * 1024]; // X MB of memory
    [static_cacheSecondary.config setMaxDiskSize:static_secondaryDiskCacheSizeMB * 1024 * 1024]; // X MB of disk
    
    // [SDImageCachesManager sharedManager] comes with default cache instance which is not configured so we replace the whole list
    [[SDImageCachesManager sharedManager] setCaches:@[static_cachePrimary, static_cacheSecondary]];
    SDWebImageManager.defaultImageCache = [SDImageCachesManager sharedManager];
}

- (FFFastImageView*)view {
    return [[FFFastImageView alloc] init];
}

+ (SDImageCache *)primaryCache {
    return static_cachePrimary;
}

+ (SDImageCache *)secondaryCache {
    return static_cacheSecondary;
}


RCT_EXPORT_VIEW_PROPERTY(source, FFFastImageSource)
RCT_EXPORT_VIEW_PROPERTY(defaultSource, UIImage)
RCT_EXPORT_VIEW_PROPERTY(resizeMode, RCTResizeMode)
RCT_EXPORT_VIEW_PROPERTY(onFastImageLoadStart, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFastImageProgress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFastImageError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFastImageLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFastImageLoadEnd, RCTDirectEventBlock)
RCT_REMAP_VIEW_PROPERTY(tintColor, imageColor, UIColor)

RCT_EXPORT_METHOD(preload:(nonnull NSArray<FFFastImageSource *> *)sources)
{
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:sources.count];
    
    [sources enumerateObjectsUsingBlock:^(FFFastImageSource * _Nonnull source, NSUInteger idx, BOOL * _Nonnull stop) {
        [source.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* header, BOOL *stop) {
            [[SDWebImageDownloader sharedDownloader] setValue:header forHTTPHeaderField:key];
        }];
        [urls setObject:source.url atIndexedSubscript:idx];
    }];
    
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];
}

RCT_EXPORT_METHOD(clearMemoryCache:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    [SDImageCache.sharedImageCache clearMemory];
    resolve(NULL);
}

RCT_EXPORT_METHOD(clearDiskCache:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    [SDImageCache.sharedImageCache clearDiskOnCompletion:^(){
        resolve(NULL);
    }];
}
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeFastImageViewSpecJSI>(params);
}
#endif

@end
