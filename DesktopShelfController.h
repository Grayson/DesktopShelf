//
//  DesktopShelfController.h
//  DesktopShelf
//
//  Created by Grayson Hansard on 2/24/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileWatcher.h"
#import "URLFile.h"
#import "WeblocFile.h"

#define UD_SEARCH_PATHS_KEY @"SearchPaths"
#define UD_SHOULD_LOG_KEY @"ShouldLog"

@interface DesktopShelfController : NSObject {

}

- (void)folderUpdatedAtPath:(NSString *)updatedPath userInfo:(NSDictionary *)userInfo;

@end
