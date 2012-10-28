//
//  FRWindowController.m
//  FileRenamor
//
//  Created by Michael Mouchous on 19/10/12.
//  Copyright (c) 2012 Michael Mouchous. All rights reserved.
//

#import "FRWindowController.h"
#import "FRSpecialToken.h"

@implementation FRWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        model = [[FRModel alloc] init];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self.window setMinSize:NSMakeSize(863.0f, 555.0f)];
    
}

- (IBAction)rename:(id)sender
{
}

- (IBAction)remove:(id)sender
{
}

- (IBAction)add:(id)sender
{
    NSLog(@"Number of rows %lu", model.numberOfFiles);
    // Get the window.
    NSWindow* window = [self window];
    
    // Create and configure the panel.
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    [panel setMessage:@"Select files or directories"];
    
    // Display the panel attached to the document's window.
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton)
        {
            // Add all selected files in URL
            [model addFilesToArrayOfUrls:[panel URLs]];
            [self.tableView reloadData];
        }
        
    }];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSLog(@"Number of rows %lu", model.numberOfFiles);
    return model.numberOfFiles;
}

- (IBAction)changeSelection:(NSButton *)sender
{
    NSIndexSet * selectedRows;
    if (self.tableView.numberOfSelectedRows)
    {
        selectedRows = self.tableView.selectedRowIndexes;
    }
    else
    {
        selectedRows = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfRows)];
    }
    
    NSUInteger indexes[selectedRows.count];
    [selectedRows getIndexes:indexes
                    maxCount:selectedRows.count
                inIndexRange:nil];
    
    for (NSUInteger i = 0; i < selectedRows.count; i++)
    {
        [model setSelection:sender.tag atIndex:indexes[i]];
    }
    
    [self.tableView reloadDataForRowIndexes:selectedRows
                              columnIndexes:[NSIndexSet indexSetWithIndex:[self.tableView columnWithIdentifier:@"selected"]]];
}

#pragma mark -
#pragma mark TableView Delegate/Datasource Methods
-(id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
           row:(NSInteger)row
{
    return [[model fileAtIndex:row] valueForKey:tableColumn.identifier];
}

-(void)tableView:(NSTableView *)tableView
  setObjectValue:(id)object
  forTableColumn:(NSTableColumn *)tableColumn
             row:(NSInteger)row
{
    if ([tableColumn.identifier isEqualToString:@"selected"])
    {
        [model setSelection:-1 atIndex:row];
    }
}

- (IBAction)groupSelection:(id)sender
{
    NSIndexSet * selectedRows;
    if (self.tableView.numberOfSelectedRows)
    {
        selectedRows = self.tableView.selectedRowIndexes;
    }
    else
    {
        selectedRows = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfRows)];
    }
    
    NSLog(@"F : %s / %@ -> %@", __FUNCTION__, selectedRows, ((NSTextFieldCell * )self.groupName.cell).stringValue);
    
    NSUInteger indexes[selectedRows.count];
    [selectedRows getIndexes:indexes
                    maxCount:selectedRows.count
                inIndexRange:nil];
    
    for (NSUInteger i = 0; i < selectedRows.count; i++)
    {
        [model fileAtIndex:indexes[i]].groupName = ((NSTextFieldCell * )self.groupName.cell).stringValue;
    }
    
    
    [self.tableView reloadDataForRowIndexes:selectedRows
                              columnIndexes:[NSIndexSet indexSetWithIndex:[self.tableView columnWithIdentifier:@"groupName"]]];
}

-(BOOL) selectionShouldChangeInTableView:(NSTableView *)tableView
{
    NSLog(@"%s : clickedColumn %ld", __FUNCTION__, [tableView clickedColumn]);
    if ([tableView clickedColumn] == [self.tableView columnWithIdentifier:@"selected"])
    {
        return NO;
    }
    return YES;
}

#pragma mark
#pragma mark TokenField Delegate Methods

-(NSString *)tokenField:(NSTokenField *)tokenField editingStringForRepresentedObject:(id)representedObject
{
    FRSpecialToken * token = (FRSpecialToken *) representedObject;
    NSLog(@"F : %s / %@", __FUNCTION__, token.string);
    return token.string;
}

-(NSString *)tokenField:(NSTokenField *)tokenField displayStringForRepresentedObject:(id)representedObject
{
    FRSpecialToken * token = (FRSpecialToken *) representedObject;
    NSString * tokenString = token.string;
    NSLog(@"F : %s / %@", __FUNCTION__, tokenString);
    return tokenString;
}

- (NSMenu *)tokenField:(NSTokenField *)tokenField menuForRepresentedObject:(id)representedObject
{
    FRSpecialToken * token = (FRSpecialToken *) representedObject;
    NSLog(@"F : %s / %@", __FUNCTION__, token.menu.title);
    return token.menu;
}
- (BOOL)tokenField:(NSTokenField *)tokenField hasMenuForRepresentedObject:(id)representedObject
{
    FRSpecialToken * token = (FRSpecialToken *) representedObject;
    NSLog(@"F : %s : %@", __FUNCTION__, token.string);
    return (token.menu != nil);
}

- (id)tokenField:(NSTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString
{
    FRSpecialToken * token = [[FRSpecialToken alloc] initWithString:editingString];
    NSLog(@"F : %s / %@", __FUNCTION__, editingString);
    return token;
}

-(NSTokenStyle)tokenField:(NSTokenField *)tokenField
styleForRepresentedObject:(id)representedObject
{
    NSLog(@"F : %s", __FUNCTION__);
    FRSpecialToken * token = (FRSpecialToken *) representedObject;
    if (token.tokenType==FRTokenTypeUser)
    {
        return NSPlainTextTokenStyle;
    }
    return NSRoundedTokenStyle;
}

- (IBAction)addTokenField:(NSButton *)sender
{
    FRSpecialToken * token = [[FRSpecialToken alloc] initWithString:[@"\x1B" stringByAppendingString:sender.title]];
    _fileNameFormatTokenField.objectValue = [_fileNameFormatTokenField.objectValue arrayByAddingObject:token];
    
}

- (IBAction)previewRenaming:(id)sender
{
    [model calculateAllNewNamesWithTokens:_fileNameFormatTokenField.objectValue];
    [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfRows)]
                              columnIndexes:[NSIndexSet indexSetWithIndex:[self.tableView columnWithIdentifier:@"newFileName"]]];
    
}

@end
