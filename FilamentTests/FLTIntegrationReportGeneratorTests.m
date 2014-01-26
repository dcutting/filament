//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import "FLTIntegrationReportGenerator.h"

@interface FLTIntegrationReportGeneratorTests : XCTestCase

@end

@implementation FLTIntegrationReportGeneratorTests

- (void)testReportWithBuildOutput_validBuildOutput_nonNilReport {
    
    NSString *buildOutput = [self sampleBuildOutputWithName:@"BuildOutputNormal.json"];
    
    FLTIntegrationReportGenerator *generator = [FLTIntegrationReportGenerator new];
    
    FLTIntegrationReport *report = [generator reportWithBuildOutput:buildOutput];
    
    XCTAssertNotNil(report, @"Expected non-nil report.");
}

- (void)testReportWithBuildOutput_errors_failure {
    
    NSString *buildOutput = [self sampleBuildOutputWithName:@"BuildOutputWithErrorsAndWarnings.json"];
    
    FLTIntegrationReportGenerator *generator = [FLTIntegrationReportGenerator new];
    
    FLTIntegrationReport *report = [generator reportWithBuildOutput:buildOutput];
    
    FLTIntegrationReportStatus expectedStatus = FLTIntegrationReportStatusFailureErrors;
    
    XCTAssertEqual(expectedStatus, report.status, @"Expected %ld but got %ld for report status.", expectedStatus, report.status);
}

- (void)testReportWithBuildOutput_errors_reportContainsNumberOfErrors {
    
    NSString *buildOutput = [self sampleBuildOutputWithName:@"BuildOutputWithErrorsAndWarnings.json"];
    
    FLTIntegrationReportGenerator *generator = [FLTIntegrationReportGenerator new];
    
    FLTIntegrationReport *report = [generator reportWithBuildOutput:buildOutput];
    
    FLTIntegrationReportStatus expectedErrors = 2;
    
    XCTAssertEqual(expectedErrors, report.numberOfErrors, @"Expected %ld but got %ld for number of errors.", expectedErrors, (long)report.numberOfErrors);
}

- (void)testReportWithBuildOutput_warnings_failure {
    
    NSString *buildOutput = [self sampleBuildOutputWithName:@"BuildOutputWithWarnings.json"];
    
    FLTIntegrationReportGenerator *generator = [FLTIntegrationReportGenerator new];
    
    FLTIntegrationReport *report = [generator reportWithBuildOutput:buildOutput];
    
    FLTIntegrationReportStatus expectedStatus = FLTIntegrationReportStatusFailureWarnings;
    
    XCTAssertEqual(expectedStatus, report.status, @"Expected %ld but got %ld for report status.", expectedStatus, report.status);
}

- (void)testReportWithBuildOutput_normal_success {
    
    NSString *buildOutput = [self sampleBuildOutputWithName:@"BuildOutputNormal.json"];
    
    FLTIntegrationReportGenerator *generator = [FLTIntegrationReportGenerator new];
    
    FLTIntegrationReport *report = [generator reportWithBuildOutput:buildOutput];
    
    FLTIntegrationReportStatus expectedStatus = FLTIntegrationReportStatusSuccess;
    
    XCTAssertEqual(expectedStatus, report.status, @"Expected %ld but got %ld for report status.", expectedStatus, report.status);
}

- (NSString *)sampleBuildOutputWithName:(NSString *)buildOutputName {

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *path = [bundle pathForResource:buildOutputName ofType:nil];
    
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

@end
