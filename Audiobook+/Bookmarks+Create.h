//
//  Bookmarks+Create.h
//  Audiobook+
//
//  Created by Sheng Xu on 2012-08-02.
//
//

#import "Bookmarks.h"

@interface Bookmarks (Create)

+ (Bookmarks *)bookmarkWithTrackInfo: (NSDictionary *)trackInfo inManagedObjectContext: (NSManagedObjectContext*)context;

@end
