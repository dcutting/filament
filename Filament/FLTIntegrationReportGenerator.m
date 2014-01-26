//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegrationReportGenerator.h"

@implementation FLTIntegrationReportGenerator

- (FLTIntegrationReport *)reportWithBuildOutput:(NSString *)buildOutput {

    __block FLTIntegrationReportStatus status = FLTIntegrationReportStatusSuccess;
    
    NSArray *lines = [buildOutput componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {

        NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];

        NSDictionary *jsonLine = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

        NSNumber *errorNumber = jsonLine[@"totalNumberOfErrors"];
        NSInteger errors = [errorNumber integerValue];

        if (errors > 0) {
            status = FLTIntegrationReportStatusFailure;
        }
    }];
    
    FLTIntegrationReport *report = [FLTIntegrationReport new];
    report.status = status;
    
    return report;
}

@end
