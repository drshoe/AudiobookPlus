//
//  AnalyticsManager.m
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-09.
//
//

#import "AnalyticsManager.h"
static AnalyticsManager *sharedManager;
@implementation AnalyticsManager

+ (AnalyticsManager *) sharedManager {
    if (!sharedManager) {
        sharedManager = [[AnalyticsManager alloc] init];
        // Optional: automatically send uncaught exceptions to Google Analytics.
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 30;
        // Optional: set debug to YES for extra debugging information.
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
        // Create tracker instance.
    }
    return sharedManager;
}

- (void)initWithTrackingId: (NSString *)trackingId {
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingId];
}
@end
