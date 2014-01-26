//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

#import "FLTIntegrationReport.h"
#import "FLTIntegratorConfiguration.h"
#import "NSTaskFactory.h"

typedef void(^FLTIntegratorCompletionHandler)(FLTIntegrationReport *report);

@interface FLTIntegrator : NSObject

- (instancetype)initWithXctoolPath:(NSString *)xctoolPath taskFactory:(NSTaskFactory *)taskFactory;
- (void)integrateConfiguration:(FLTIntegratorConfiguration *)configuration completionHandler:(FLTIntegratorCompletionHandler)completionHandler;

@end
