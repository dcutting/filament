//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

#import "FLTIntegrationReport.h"

@interface FLTIntegrationReportGenerator : NSObject

- (FLTIntegrationReport *)reportWithBuildOutput:(NSString *)buildOutput;

@end
