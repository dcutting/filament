//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTAppDelegate.h"

#import "FLTIntegration.h"

@implementation FLTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (IBAction)clickedIntegrate:(id)sender {

    NSString *xctoolPath = @"~/Code/3rdParty/xctool/xctool.sh";

    FLTIntegratorConfiguration *configuration = [FLTIntegratorConfiguration new];
    configuration.resultsPath = @"/tmp/myresults.json";
    configuration.rootPath = @"~/Code/Tests/BasicApp";
    configuration.workspace = @"BasicApp.xcworkspace";
    configuration.scheme = @"BasicApp";

    FLTIntegrator *integrator = [[FLTIntegrator alloc] initWithXctoolPath:xctoolPath taskFactory:[NSTaskFactory new] integrationReportGenerator:[FLTIntegrationReportGenerator new]];

    NSLog(@"Started integration");
    [integrator integrateConfiguration:configuration completionHandler:^(FLTIntegrationReport *report) {
        NSLog(@"Completed integration: %@", FLTIntegrationReportStatusSuccess == report.status ? @"success" : @"FAILURE");
    }];
}

@end
