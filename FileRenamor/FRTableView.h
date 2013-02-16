//
//  FRTableView.h
//  FileRenamor
//
//  Created by Michaël Mouchous on 16/02/13.
//  Copyright (c) 2013 Michael Mouchous. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FRWindowController.h"

@class FRWindowController;

@interface FRTableView : NSTableView

@property (assign) FRWindowController * owner;

@end
