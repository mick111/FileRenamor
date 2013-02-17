//
//  FRTokenField.h
//  FileRenamor
//
//  Created by Michaël Mouchous on 17/02/13.
//  Copyright (c) 2013 Michael Mouchous. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FRWindowController;

@interface FRTokenField : NSTokenField

@property (assign) FRWindowController * owner;

@end
