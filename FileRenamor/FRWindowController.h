//
//  FRWindowController.h
//  FileRenamor
//
//  Created by Michael Mouchous on 19/10/12.
//  Copyright (c) 2012 Michael Mouchous. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FRModel.h"


@interface FRWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate, NSTokenFieldDelegate>
{
    FRModel * model;
}

@property (weak) IBOutlet NSTableView *tableView;

@property (assign) NSUInteger addFileOption;

- (IBAction)rename:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)changeSelection:(NSButton *)sender;
- (IBAction)groupSelection:(id)sender;
- (IBAction)previewRenaming:(id)sender;

@property (weak) IBOutlet NSTextField *groupName;

@property (weak) IBOutlet NSTokenField *fileNameFormatTokenField;
- (IBAction)addTokenField:(NSButton *)sender;

@property BOOL autoPreview;
@property BOOL removeTreatedItems;
@end
