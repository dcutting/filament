//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTAppDelegate.h"

#import "FLTIntegration.h"

@implementation FLTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSURL *gitURL = [NSURL URLWithString:@"/Users/dcutting/Code/Tests/BasicApp"];
    NSString *branchName = @"master";
    FLTRepository *repository = [[FLTRepository alloc] initWithGitURL:gitURL branchName:branchName];

    FLTIntegrator *integrator = [FLTIntegrator new];
    
    FLTIntegration *integration = [[FLTIntegration alloc] initWithIntegrator:integrator];
    
    NSLog(@"Beginning integration for %@", repository);
    [integration integrateRepository:repository completionHandler:^(FLTIntegrationReport *report) {
        if (FLTIntegrationReportStatusSuccess == report.status) {
            NSLog(@"Success!");
        } else {
            NSLog(@"Failed integration.");
        }
    }];
}

@end
