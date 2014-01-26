//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import "FLTIntegration.h"

@interface FLTIntegrationReportTests : XCTestCase

@end

@implementation FLTIntegrationReportTests

- (void)testDescription_success {
    
    FLTIntegrationReport *report = [FLTIntegrationReport new];
    report.status = FLTIntegrationReportStatusSuccess;
    report.numberOfErrors = 0;
    report.numberOfWarnings = 0;

    NSString *expectedDescription = @"Success: 0 errors, 0 warnings";
    NSString *actualDescription = [report description];

    XCTAssertEqualObjects(expectedDescription, actualDescription, @"Expected '%@' but got '%@' for description.", expectedDescription, actualDescription);
}

- (void)testDescription_failureWithErrors {
    
    FLTIntegrationReport *report = [FLTIntegrationReport new];
    report.status = FLTIntegrationReportStatusFailureErrors;
    report.numberOfErrors = 4;
    report.numberOfWarnings = 0;
    
    NSString *expectedDescription = @"FAILURE: 4 errors, 0 warnings";
    NSString *actualDescription = [report description];
    
    XCTAssertEqualObjects(expectedDescription, actualDescription, @"Expected '%@' but got '%@' for description.", expectedDescription, actualDescription);
}

@end
