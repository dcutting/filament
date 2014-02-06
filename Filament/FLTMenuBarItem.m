//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.
//

#import "FLTMenuBarItem.h"

@interface FLTMenuBarItem ()

@property (nonatomic, weak) IBOutlet NSMenu *theMenu;

@end

@implementation FLTMenuBarItem


- (void)awakeFromNib {
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setTitle:@"Filament"];
    [self.statusItem setEnabled:YES];
    [self.statusItem setToolTip:@"Filament CI"];
    
    [self.statusItem setAction:@selector(menuBarItemPressed:)];
    [self.statusItem setTarget:self];
    
    [self configureMenu];
}

- (void)menuBarItemPressed:(id)sender {
    NSLog(@"menuBarItemPressed: %@", sender);
}

- (void)configureMenu {
    [self.statusItem setMenu:self.theMenu];
}


@end
