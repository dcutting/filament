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
}

- (void)menuBarItemPressed:(id)sender {
    NSLog(@"menuBarItemPressed: %@", sender);
}


@end
