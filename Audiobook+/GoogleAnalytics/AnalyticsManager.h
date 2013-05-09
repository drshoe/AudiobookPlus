//
//  AnalyticsManager.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-09.
//
//

#import <Foundation/Foundation.h>
#import "GAI.h"
@interface AnalyticsManager : NSObject
@property (nonatomic, strong) id<GAITracker> tracker;
+ (AnalyticsManager *)sharedManager;
- (void)initWithTrackingId: (NSString *)trackingId;
@end
