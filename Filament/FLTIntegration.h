//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

#import "FLTIntegrator.h"
#import "FLTRepository.h"

typedef void(^FLTIntegrationCompletionHandler)(FLTIntegrationReport *);

@interface FLTIntegration : NSObject

- (instancetype)initWithIntegrator:(FLTIntegrator *)integrator;
- (void)integrateRepository:(FLTRepository *)repository completionHandler:(FLTIntegrationCompletionHandler)completionHandler;

@end
