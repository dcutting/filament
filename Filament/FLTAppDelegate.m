//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTAppDelegate.h"

#import "FLTIntegration.h"

@implementation FLTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (IBAction)clickedIntegrate:(id)sender {

    NSString *xctoolPath = @"~/Code/3rdParty/xctool/xctool.sh";
    FLTIntegrator *integrator = [[FLTIntegrator alloc] initWithXctoolPath:xctoolPath taskFactory:[NSTaskFactory new] integrationReportGenerator:[FLTIntegrationReportGenerator new]];
    
    FLTIntegration *integration = [[FLTIntegration alloc] initWithIntegrator:integrator];

    NSURL *gitURL = [NSURL URLWithString:@"/Users/dcutting/Code/Tests/BasicApp"];
    NSString *branchName = @"sampleBranch";
    NSString *clonePath = @"/tmp/BasicAppClone";

    NSString *gitPath = @"/usr/local/bin/git";
    FLTRepository *repository = [[FLTRepository alloc] initWithGitPath:gitPath taskFactory:[NSTaskFactory new]];

    NSLog(@"Started integration...");

    [integration integrateGitURL:gitURL branchName:branchName toPath:clonePath repository:repository completionHandler:^(FLTIntegrationReport *report) {

        NSLog(@"Completed integration: %@", report);
    }];
}

@end
