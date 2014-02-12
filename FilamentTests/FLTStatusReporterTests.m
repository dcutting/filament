//  Copyright (c) 2013 BSkyB. All rights reserved.

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "FLTStatusReporter.h"

@interface FLTStatusReporterTests : XCTestCase

@property (nonatomic, strong) FLTStatusReporter *reporter;

@end

@implementation FLTStatusReporterTests

- (void)setUp {
    
    self.reporter = [FLTStatusReporter new];
}

- (void)testNumberOfJobs_none_returns0 {
    
    NSUInteger expectedResult = 0;
    NSUInteger actualResult = [self.reporter numberOfJobs];
    
    XCTAssertEqual(expectedResult, actualResult, @"Expected %lud but got %lud for number of jobs.", expectedResult, actualResult);
}

- (void)testJobAtIndex_none_throws {
    
    XCTAssertThrows([self.reporter jobAtIndex:0], @"Expected exception when trying to access non-existent job.");
}

- (void)testAddJob_none_addsJob {
    
    id dummyJob = [OCMockObject niceMockForClass:[FLTJob class]];
    [self.reporter addJob:dummyJob];
    
    NSUInteger expectedNumberOfJobs = 1;
    NSUInteger actualNumberOfJobs = [self.reporter numberOfJobs];
    
    XCTAssertEqual(expectedNumberOfJobs, actualNumberOfJobs, @"Expected %ld but got %ld for number of jobs after adding a single job.", expectedNumberOfJobs, actualNumberOfJobs);
    
    FLTJob *actualJob = [self.reporter jobAtIndex:0];
    
    XCTAssertEqual(dummyJob, actualJob, @"Expected '%@' but got '%@' for job at index 0.", dummyJob, actualJob);
}

- (void)testJobAtIndex_beyondNumberOfJobs_throws {
    
    id dummyJob = [OCMockObject niceMockForClass:[FLTJob class]];
    [self.reporter addJob:dummyJob];

    XCTAssertThrows([self.reporter jobAtIndex:1], @"Expected exception when trying to access non-existent job.");
}

@end
