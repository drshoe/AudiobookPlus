//
//  Book.h
//  Audiobook+
//
//  Created by Sheng Xu on 2012-08-02.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bookmarks;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * albumTitle;
@property (nonatomic, retain) NSSet *bookmarks;
@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmarks *)value;
- (void)removeBookmarksObject:(Bookmarks *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

@end
