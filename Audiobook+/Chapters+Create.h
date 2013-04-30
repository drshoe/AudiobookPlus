//
//  Chapters+Create.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-04-30.
//
//

#import "Chapters.h"

@interface Chapters (Create)
+ (Chapters *)chapterWithTrackInfo: (NSDictionary *)trackInfo inManagedObjectContext:(NSManagedObjectContext*)context;
@end
