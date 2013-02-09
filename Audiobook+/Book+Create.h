//
//  Book+Create.h
//  Audiobook+
//
//  Created by Sheng Xu on 2012-08-02.
//
//

#import "Book.h"

@interface Book (Create)

+ (Book *)bookWithAlbumTitle:(NSString *)albumTitle
                inManagedObjectContext:(NSManagedObjectContext *)context;

@end
