//
//  FRTokenField.m
//  FileRenamor
//
//  Created by Michaël Mouchous on 17/02/13.
//  Copyright (c) 2013 Michael Mouchous. All rights reserved.
//

#import "FRTokenField.h"
#import "FRAppDelegate.h"

@implementation FRTokenField

@synthesize owner;

-(void)textDidChange:(NSNotification *)notification
{
    FRLog(@"%s",__FUNCTION__);
    if (owner.autoPreview) [owner previewRenaming:self];
    [super textDidChange:notification];
}
@end
