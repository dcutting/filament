//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

#import "FLTIntegrator.h"
#import "FLTRepository.h"

typedef void(^FLTIntegrationCompletionHandler)(FLTIntegrationReport *);

@interface FLTIntegration : NSObject

- (instancetype)initWithIntegrator:(FLTIntegrator *)integrator;
- (void)integrateGitURL:(NSURL *)gitURL branchName:(NSString *)branchName toPath:(NSString *)toPath repository:(FLTRepository *)repository completionHandler:(FLTIntegrationCompletionHandler)completionHandler;

@end
