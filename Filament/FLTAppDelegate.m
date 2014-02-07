//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTAppDelegate.h"

#import "FLTIntegration.h"

@implementation FLTAppDelegate

- (IBAction)clickedIntegrate:(id)sender {

    FLTRepository *repository = [self newRepository];
    FLTIntegration *integration = [self newIntegration];

    NSURL *gitURL = [NSURL URLWithString:@"/Users/mike/Developer/private/objC/wfr_ios/"];
    NSString *branchName = @"filament";
    NSString *clonePath = @"/tmp/BasicAppClone";

    NSLog(@"Started integration...");

    [integration integrateGitURL:gitURL branchName:branchName toPath:clonePath repository:repository completionHandler:^(FLTIntegrationReport *report) {

        NSLog(@"Completed integration: %@", report);
    }];
}

#pragma mark -

- (FLTIntegrator *)newIntegrator {
    
    NSString *xctoolPath = @"~/Code/xctool/xctool.sh";
    FLTIntegrator *integrator = [[FLTIntegrator alloc] initWithXctoolPath:xctoolPath taskFactory:[NSTaskFactory new] integrationReportGenerator:[FLTIntegrationReportGenerator new]];
    return integrator;
}

- (FLTRepository *)newRepository {
    
    NSString *gitPath = @"/usr/bin/git";
    FLTRepository *repository = [[FLTRepository alloc] initWithGitPath:gitPath taskFactory:[NSTaskFactory new] fileReader:[FLTFileReader new]];
    return repository;
}

- (FLTIntegration *)newIntegration {
    
    FLTIntegrator *integrator = [self newIntegrator];
    FLTIntegration *integration = [[FLTIntegration alloc] initWithIntegrator:integrator];
    
    return integration;
}


@end
