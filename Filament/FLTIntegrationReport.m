//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegrationReport.h"

@implementation FLTIntegrationReport

- (NSString *)description {

    NSString *statusDescription = [self descriptionForStatus];
    
    return [NSString stringWithFormat:@"%@: %ld errors, 0 warnings", statusDescription, self.numberOfErrors];
}

- (NSString *)descriptionForStatus {
    
    return FLTIntegrationReportStatusSuccess == self.status ? @"Success" : @"FAILURE";
}

@end
