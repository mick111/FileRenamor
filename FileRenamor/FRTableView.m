//
//  FRTableView.m
//  FileRenamor
//
//  Created by Michaël Mouchous on 16/02/13.
//  Copyright (c) 2013 Michael Mouchous. All rights reserved.
//

#import "FRTableView.h"
#import "FRAppDelegate.h"

@implementation FRTableView

@synthesize owner;

- (void)keyDown:(NSEvent *)theEvent
{
    FRLog(@"%s",__FUNCTION__);
    
    unichar character = ((theEvent.type == NSKeyDown) && ([theEvent.characters length])) ? [theEvent.characters characterAtIndex:0] : 0;
    if ((character == NSBackspaceCharacter) ||
        (character == NSDeleteCharacter))
    {
        [owner remove:self];
    }
    else if ((character == NSUpArrowFunctionKey) ||
             (character == NSDownArrowFunctionKey))
    {
        if (theEvent.modifierFlags & NSCommandKeyMask)
        {
            if (character == NSUpArrowFunctionKey)
                [owner moveSelectionUp];
            else
                [owner moveSelectionDown];
        }
        else
            [super keyDown:theEvent];
    }
    else
        [super keyDown:theEvent];
}


@end
