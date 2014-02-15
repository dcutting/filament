//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.
//

#import "FLTMenuBarItem.h"

@interface FLTMenuBarItem ()

@property (nonatomic, weak) IBOutlet NSMenu *menu;

@end

@implementation FLTMenuBarItem


- (void)awakeFromNib {
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setTitle:@"Filament"];
    [self.statusItem setEnabled:YES];
    [self.statusItem setToolTip:@"Filament CI"];
    
    [self configureMenu];
}

- (void)configureMenu {
    [self.statusItem setMenu:self.menu];
}


@end
