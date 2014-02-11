//  Copyright (c) 2013 BSkyB. All rights reserved.

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "FLTStatusReporter.h"

@interface FLTStatusReporterTests : XCTestCase

@end

@implementation FLTStatusReporterTests

- (void)testNumberOfJobs_none_returns0 {
    
    FLTStatusReporter *reporter = [FLTStatusReporter new];
    
    NSUInteger expectedResult = 0;
    NSUInteger actualResult = [reporter numberOfJobs];
    
    XCTAssertEqual(expectedResult, actualResult, @"Expected %lud but got %lud for number of jobs.", expectedResult, actualResult);
}

- (void)testJobAtIndex_none_throws {
    
    FLTStatusReporter *reporter = [FLTStatusReporter new];
    
    XCTAssertThrows([reporter jobAtIndex:0], @"Expected exception when trying to access non-existent job.");
}

@end
