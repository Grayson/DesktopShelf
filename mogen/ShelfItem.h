#import "_ShelfItem.h"

#import "includes.h"
#import "URLFile.h"
#import "WeblocFile.h"
#import "NSImage+QuickLook.h"

@interface ShelfItem : _ShelfItem {}

+ (id)item;
+ (NSArray *)everyItem;
- (void)updateDateModified;
- (void)fetchIcon;

-(void)open;

@end
