#import "FFFastImageHelper.h"

static SDImageCache *static_cachePrimary = nil;
static SDImageCache *static_cacheSecondary = nil;
static float static_primaryMemoryCacheSizeMB = 100;
static float static_secondaryMemoryCacheSizeMB = 100;
static float static_primaryDiskCacheSizeMB = 200;
static float static_secondaryDiskCacheSizeMB = 200;

@implementation FFFastImageHelper

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

+ (SDImageCache *)primaryCache {
    if (static_cachePrimary == nil) {
        NSLog(@"ATTENTION, fast image primary cache not initialized. Call [FFFastImageHelper setup] from your AppDelegate.");
    }
    return static_cachePrimary;
}

+ (SDImageCache *)secondaryCache {
    if (static_cacheSecondary == nil) {
        NSLog(@"ATTENTION, fast image secondary cache not initialized. Call [FFFastImageHelper setup] from your AppDelegate.");
    }
    return static_cacheSecondary;
}

@end
