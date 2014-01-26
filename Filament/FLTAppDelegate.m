//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTAppDelegate.h"

#import "FLTIntegration.h"

@implementation FLTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSString *xctoolPath = @"~/Code/3rdParty/xctool/xctool.sh";

    FLTIntegratorConfiguration *configuration = [FLTIntegratorConfiguration new];
    configuration.rootPath = @"~/Code/Tests/BasicApp";
    configuration.workspace = @"BasicApp.xcworkspace";
    configuration.scheme = @"BasicApp";

    FLTIntegrator *integrator = [[FLTIntegrator alloc] initWithXctoolPath:xctoolPath taskFactory:[NSTaskFactory new]];
    
    NSLog(@"Started integration");
    [integrator integrateConfiguration:configuration completionHandler:^(FLTIntegrationReport *report) {
        NSLog(@"Completed integration.");
    }];
}

@end
