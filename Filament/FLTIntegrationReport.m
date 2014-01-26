//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegrationReport.h"

@implementation FLTIntegrationReport

- (NSString *)description {

    NSString *statusDescription = [self descriptionForStatus];
    
    return [NSString stringWithFormat:@"%@: %ld errors, %ld warnings", statusDescription, self.numberOfErrors, self.numberOfWarnings];
}

- (NSString *)descriptionForStatus {
    
    return FLTIntegrationReportStatusSuccess == self.status ? @"Success" : @"FAILURE";
}

@end
