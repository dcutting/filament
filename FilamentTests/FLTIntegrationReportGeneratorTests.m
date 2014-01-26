//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import "FLTIntegrationReportGenerator.h"

@interface FLTIntegrationReportGeneratorTests : XCTestCase

@end

@implementation FLTIntegrationReportGeneratorTests

- (void)testReportWithBuildOutput_errors_failure {
    
    NSString *buildOutput = [self sampleBuildOutputWithName:@"BuildOutputWithErrorsAndWarnings.json"];
    
    FLTIntegrationReportGenerator *generator = [FLTIntegrationReportGenerator new];
    
    FLTIntegrationReport *report = [generator reportWithBuildOutput:buildOutput];
    
    [self assertReport:report hasStatus:FLTIntegrationReportStatusFailure];
}

- (void)testReportWithBuildOutput_normal_success {
    
    NSString *buildOutput = [self sampleBuildOutputWithName:@"BuildOutputNormal.json"];
    
    FLTIntegrationReportGenerator *generator = [FLTIntegrationReportGenerator new];
    
    FLTIntegrationReport *report = [generator reportWithBuildOutput:buildOutput];
    
    [self assertReport:report hasStatus:FLTIntegrationReportStatusSuccess];
}

- (NSString *)sampleBuildOutputWithName:(NSString *)buildOutputName {

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *path = [bundle pathForResource:buildOutputName ofType:nil];
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

- (void)assertReport:(FLTIntegrationReport *)report hasStatus:(FLTIntegrationReportStatus)status {
    
    XCTAssertNotNil(report, @"Expected non-nil report.");
    
    XCTAssertEqual(status, report.status, @"Expected %ld but got %ld for report status.", status, report.status);
}

@end
