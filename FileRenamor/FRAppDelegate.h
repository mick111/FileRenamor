//
//  FRAppDelegate.h
//  FileRenamor
//
//  Created by Michael Mouchous on 18/10/12.
//  Copyright (c) 2012 Michael Mouchous. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FRWindowController.h"

@interface FRAppDelegate : NSObject <NSApplicationDelegate>
@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet FRWindowController *windowController;
+ (NSView *)loadMainViewFromNib:(NSString *)nibName
                      withOwner:(id)owner;
@end
