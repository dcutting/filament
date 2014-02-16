//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

#import "FLTFileReader.h"
#import "FLTIntegrationReportGenerator.h"
#import "FLTIntegratorConfiguration.h"
#import "NSTaskFactory.h"

typedef void(^FLTIntegratorCompletionHandler)(FLTIntegrationReport *report);

@interface FLTIntegrator : NSObject

- (instancetype)initWithXctoolPath:(NSString *)xctoolPath taskFactory:(NSTaskFactory *)taskFactory fileReader:(FLTFileReader *)fileReader integrationReportGenerator:(FLTIntegrationReportGenerator *)integrationReportGenerator;
- (void)integrateConfiguration:(FLTIntegratorConfiguration *)configuration completionHandler:(FLTIntegratorCompletionHandler)completionHandler;

@end
