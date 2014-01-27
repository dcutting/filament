//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegration.h"

@interface FLTIntegration ()

@property (nonatomic, strong) FLTIntegrator *integrator;

@end

@implementation FLTIntegration

- (instancetype)initWithIntegrator:(FLTIntegrator *)integrator {

    self = [super init];
    if (self) {
        
        _integrator = integrator;
    }
    return self;
}

- (void)integrateGitURL:(NSURL *)gitURL branchName:(NSString *)branchName toPath:(NSString *)toPath repository:(FLTRepository *)repository completionHandler:(FLTIntegrationCompletionHandler)completionHandler {
    
    [repository checkoutGitURL:gitURL branchName:branchName toPath:toPath completionHandler:^(FLTIntegratorConfiguration *configuration) {
        
        [self.integrator integrateConfiguration:configuration completionHandler:nil];
    }];
}

@end
