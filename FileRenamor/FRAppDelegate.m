//
//  FRAppDelegate.m
//  FileRenamor
//
//  Created by Michael Mouchous on 18/10/12.
//  Copyright (c) 2012 Michael Mouchous. All rights reserved.
//

#import "FRAppDelegate.h"


@interface FRAppDelegate()
@end


@implementation FRAppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.windowController.window = self.window;
    [self.windowController windowDidLoad];

}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}
@end
