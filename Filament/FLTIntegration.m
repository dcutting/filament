//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegration.h"

@implementation FLTIntegration

- (instancetype)initWithIntegrator:(FLTIntegrator *)integrator {

    self = [super init];
    return self;
}

- (void)integrateRepository:(FLTRepository *)repository completionHandler:(FLTIntegrationCompletionHandler)completionHandler {
}

@end
