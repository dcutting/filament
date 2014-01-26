//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTAppDelegate.h"

#import "FLTIntegration.h"

@implementation FLTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (IBAction)clickedIntegrate:(id)sender {

    NSString *xctoolPath = @"~/Code/3rdParty/xctool/xctool.sh";
    NSString *gitPath = @"/usr/local/bin/git";
    
    NSURL *gitURL = [NSURL URLWithString:@"/Users/dcutting/Code/Tests/BasicApp"];
    NSString *branchName = @"sampleBranch";
    NSString *clonePath = @"/tmp/BasicAppClone";
    
    FLTRepository *repository = [[FLTRepository alloc] initWithGitPath:gitPath taskFactory:[NSTaskFactory new]];

    NSLog(@"Started checkout");
    
    [repository checkoutGitURL:gitURL branchName:branchName toPath:clonePath completionHandler:^(FLTIntegratorConfiguration *configuration) {

        NSLog(@"Completed checkout");
        
        FLTIntegrator *integrator = [[FLTIntegrator alloc] initWithXctoolPath:xctoolPath taskFactory:[NSTaskFactory new] integrationReportGenerator:[FLTIntegrationReportGenerator new]];
        
        NSLog(@"Started integration");
        
        [integrator integrateConfiguration:configuration completionHandler:^(FLTIntegrationReport *report) {
            
            NSLog(@"Completed integration:");
            NSLog(@"%@", report);
        }];
    }];
}

@end
