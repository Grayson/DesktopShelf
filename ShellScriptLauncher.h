//
//  ShellScriptLauncher.h
//  Countdown
//
//  Created by Grayson Hansard on 11/6/07.
//  Copyright 2007 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ShellScriptLauncher : NSObject {

}

+(NSDictionary *)extensionsToLaunchPathsDict;
+(BOOL)canLaunchScriptAtPath:(NSString *)path;
+(NSString *)launchScriptAtPath:(NSString *)path;
+(NSString *)launchScriptAtPath:(NSString *)path withArguments:(NSArray *)arguments;

@end
