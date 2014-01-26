//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegrationReportGenerator.h"

@implementation FLTIntegrationReportGenerator

- (FLTIntegrationReport *)reportWithBuildOutput:(NSString *)buildOutput {

    __block NSInteger numberOfErrors = 0;
    __block NSInteger numberOfWarnings = 0;
    
    NSArray *lines = [buildOutput componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {

        NSDictionary *jsonDictionary = [self jsonDictionaryForLine:line];
        numberOfErrors += [self errorsForJsonDictionary:jsonDictionary];
        numberOfWarnings += [self warningsForJsonDictionary:jsonDictionary];
    }];

    return [self reportForNumberOfWarnings:numberOfWarnings numberOfErrors:numberOfErrors];
}

- (NSDictionary *)jsonDictionaryForLine:(NSString *)line {

    NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];

    return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}

- (NSInteger)errorsForJsonDictionary:(NSDictionary *)jsonDictionary {
    
    return [jsonDictionary[@"totalNumberOfErrors"] integerValue];
}

- (NSInteger)warningsForJsonDictionary:(NSDictionary *)jsonDictionary {
    
    return [jsonDictionary[@"totalNumberOfWarnings"] integerValue];
}

- (FLTIntegrationReport *)reportForNumberOfWarnings:(NSInteger)numberOfWarnings numberOfErrors:(NSInteger)numberOfErrors {
    
    FLTIntegrationReport *report = [FLTIntegrationReport new];
    report.numberOfErrors = numberOfErrors;
    report.numberOfWarnings = numberOfWarnings;
    
    [self updateStatusForIntegrationReport:report];
    
    return report;
}

- (void)updateStatusForIntegrationReport:(FLTIntegrationReport *)report {

    FLTIntegrationReportStatus status = FLTIntegrationReportStatusSuccess;
    if (report.numberOfErrors > 0) {
        status = FLTIntegrationReportStatusFailureErrors;
    } else if (report.numberOfWarnings > 0) {
        status = FLTIntegrationReportStatusFailureWarnings;
    }
    
    report.status = status;
}

@end
