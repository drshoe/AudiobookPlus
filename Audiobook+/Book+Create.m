//
//  Book+Create.m
//  Audiobook+
//
//  Created by Sheng Xu on 2012-08-02.
//
//

#import "Book+Create.h"

@implementation Book (Create)

+ (Book *)bookWithAlbumTitle:(NSString *)albumTitle inManagedObjectContext:(NSManagedObjectContext *)context
{
    Book *book = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    request.predicate = [NSPredicate predicateWithFormat:@"albumTitle = %@", albumTitle];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"albumTitle" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *books = [context executeFetchRequest:request error:&error];
    
    if (!books || ([books count] > 1)) {
        // handle error
        // there should only be one unique album by that album title exist in the database
        NSLog (@"duplicate book objects with same album title exists in database");
    } else if (![books count]) {
        book = [NSEntityDescription insertNewObjectForEntityForName:@"Book"
                                                     inManagedObjectContext:context];
        book.albumTitle = albumTitle;
    } else {
        //if it exists, then we simply point to that object without making a new one
        book = [books lastObject];
    }
    
    return book;
}

@end
