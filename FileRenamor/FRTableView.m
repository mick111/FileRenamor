//
//  FRTableView.m
//  FileRenamor
//
//  Created by Michaël Mouchous on 16/02/13.
//  Copyright (c) 2013 Michael Mouchous. All rights reserved.
//

#import "FRTableView.h"

@implementation FRTableView

@synthesize owner;

- (void)keyDown:(NSEvent *)theEvent
{
    NSLog(@"TableView %s %@", __FUNCTION__, theEvent);
    
    unichar character = ((theEvent.type == NSKeyDown) && ([theEvent.characters length])) ? [theEvent.characters characterAtIndex:0] : 0;
    if ((character == NSBackspaceCharacter) ||
        (character == NSDeleteCharacter))
    {
        [owner remove:self];
    }
    else
        [super keyDown:theEvent];
}

@end
