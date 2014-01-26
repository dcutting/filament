//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegrationReportGenerator.h"

@implementation FLTIntegrationReportGenerator

- (FLTIntegrationReport *)reportWithBuildOutput:(NSString *)buildOutput {

    FLTIntegrationReport *report = [FLTIntegrationReport new];
    
    report.status = FLTIntegrationReportStatusFailure;
    
    return report;
}

@end
