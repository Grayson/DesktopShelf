#import "_ShelfItem.h"

@interface ShelfItem : _ShelfItem {}

+ (id)item;
+ (NSArray *)everyItem;
- (void)updateDateModified;
- (void)fetchFavicon;

@end
