//
//  FCSWebPage.m
//  DesktopShelf
//
//  Created by Grayson Hansard on 4/12/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "FCSWebPage.h"


@implementation FCSWebPage
@synthesize url = _url;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
	self.url = nil;
	
    [super dealloc];
}

- (NSString *)faviconPath {
	if (!self.url) return nil;
	NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithContentsOfURL:self.url options:NSXMLDocumentTidyHTML error:nil] autorelease];
	NSArray *tmp = [doc objectsForXQuery:@".//link[@rel='shortcut icon']" constants:nil error:nil];
	if (!tmp) return nil;
	return (NSString *)[[[tmp lastObject] attributeForName:@"href"] stringValue];
}

@end
