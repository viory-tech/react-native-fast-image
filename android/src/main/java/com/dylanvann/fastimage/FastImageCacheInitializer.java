package com.dylanvann.fastimage;

import android.content.Context;
import com.bumptech.glide.load.engine.cache.DiskCache;
import java.util.HashMap;

public class FastImageCacheInitializer {

    private static final int SECONDARY_DISK_CACHE_SIZE = 100 * 1024 * 1024; // 100 MB

    public static void init(Context context) {
        HashMap<String, Integer> tiers = new HashMap<>();
        tiers.put(ExtraDiskCacheAdapter.DEFAULT_TIER_NAME, DiskCache.Factory.DEFAULT_DISK_CACHE_SIZE);
        tiers.put("secondary", SECONDARY_DISK_CACHE_SIZE);

        ExtraDiskCacheAdapter.init(context, tiers);
    }
}
