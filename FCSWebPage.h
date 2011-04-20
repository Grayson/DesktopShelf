//
//  FCSWebPage.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 4/12/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FCSWebPage : NSObject {
@private
	NSURL *_url;
}
@property (retain) NSURL *url;

- (NSString *)faviconPath;

@end
