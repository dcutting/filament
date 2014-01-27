//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegration.h"

@implementation FLTIntegration

- (instancetype)initWithIntegrator:(FLTIntegrator *)integrator {

    self = [super init];
    return self;
}

- (void)integrateGitURL:(NSURL *)gitURL branchName:(NSString *)branchName toPath:(NSString *)toPath repository:(FLTRepository *)repository completionHandler:(FLTIntegrationCompletionHandler)completionHandler {
    
    [repository checkoutGitURL:gitURL branchName:branchName toPath:toPath completionHandler:nil];
}

@end
