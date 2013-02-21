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

+ (NSView *)loadMainViewFromNib:(NSString *)nibName
                      withOwner:(id)owner
{
    
    SInt32 major = 0;
    SInt32 minor = 0;
    Gestalt(gestaltSystemVersionMajor, &major);
    Gestalt(gestaltSystemVersionMinor, &minor);
    
    
    FRLog(@"%s : Args : %@, %@", __FUNCTION__, nibName, [owner class]);
    NSNib * nib = [[NSNib alloc] initWithNibNamed:nibName
                                           bundle:nil];
    
    FRLog(@"%s : Nib %@", __FUNCTION__, nib);
    NSArray * arrayOfViews;
    
    BOOL instanciated = FALSE;
    
    if (major == 10 && (minor <= 7 && minor >= 3))
    {
        instanciated = [nib instantiateNibWithOwner:owner
                                    topLevelObjects:&arrayOfViews];
    }
    else if ((major == 10 && minor >= 7) || minor >= 11)
    {
        instanciated = [nib instantiateWithOwner:owner
                                 topLevelObjects:&arrayOfViews];
    }
    
    if (!instanciated)
    {
        FRLog(@"Cannot instanciate view from %@", nibName);
        return nil;
    }
    
    
    
    
    for (id object in arrayOfViews)
    {
        if ([object isKindOfClass:[NSView class]])
        {
            return object;
        }
    }
    
    return nil;
}
@end
