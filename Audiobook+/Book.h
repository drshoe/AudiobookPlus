//
//  Book.h
//  Audiobook+
//
//  Created by Sheng Xu on 2013-05-01.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmarks, Chapters;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * albumTitle;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) NSSet *chapters;
@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmarks *)value;
- (void)removeBookmarksObject:(Bookmarks *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

- (void)addChaptersObject:(Chapters *)value;
- (void)removeChaptersObject:(Chapters *)value;
- (void)addChapters:(NSSet *)values;
- (void)removeChapters:(NSSet *)values;

@end
