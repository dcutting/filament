//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegrationReportGenerator.h"

@implementation FLTIntegrationReportGenerator

- (FLTIntegrationReport *)reportWithBuildOutput:(NSString *)buildOutput {

    __block FLTIntegrationReportStatus status = FLTIntegrationReportStatusSuccess;
    
    __block NSInteger numberOfWarnings = 0;
    
    __block NSInteger numberOfErrors = 0;
    
    NSArray *lines = [buildOutput componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {

        NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];

        NSDictionary *jsonLine = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

        NSNumber *errorNumber = jsonLine[@"totalNumberOfErrors"];
        NSInteger errors = [errorNumber integerValue];
        numberOfErrors += errors;
        
        NSNumber *warningsNumber = jsonLine[@"totalNumberOfWarnings"];
        NSInteger warnings = [warningsNumber integerValue];
        numberOfWarnings += warnings;

    }];

    if (numberOfErrors > 0) {
        status = FLTIntegrationReportStatusFailureErrors;
    } else if (numberOfWarnings > 0) {
        status = FLTIntegrationReportStatusFailureWarnings;
    }

    FLTIntegrationReport *report = [FLTIntegrationReport new];
    report.status = status;
    
    return report;
}

@end
