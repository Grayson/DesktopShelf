#import "_ShelfItem.h"

#import "includes.h"

@interface ShelfItem : _ShelfItem {}

+ (id)item;
+ (NSArray *)everyItem;
- (void)updateDateModified;
- (void)fetchIcon;

@end
