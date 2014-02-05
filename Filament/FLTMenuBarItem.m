//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.
//

#import "FLTMenuBarItem.h"

@implementation FLTMenuBarItem


- (void)awakeFromNib {
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setTitle:@"Filament"];
    [self.statusItem setEnabled:YES];
    [self.statusItem setToolTip:@"Filament CI"];
    
    [self.statusItem setAction:@selector(menuBarItemPressed:)];
    [self.statusItem setTarget:self];
    
    NSMenu *aMenu = [[NSMenu alloc] initWithTitle:@"WooHoo!"];
    
    NSMenuItem *anItem = [[NSMenuItem alloc] initWithTitle:@"Option 1" action:@selector(menuBarItemPressed:) keyEquivalent:@""];
    
    [aMenu addItem:anItem];
    
    [self.statusItem setMenu:aMenu];
}

- (void)menuBarItemPressed:(id)sender {
    NSLog(@"menuBarItemPressed: %@", sender);
}


@end
