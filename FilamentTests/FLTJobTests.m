//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import "FLTJob.h"

@interface FLTJobTests : XCTestCase

@end

@implementation FLTJobTests

- (void)testConstruction {
    
    FLTJob *job = [FLTJob new];
    
    XCTAssertNotNil(job, @"");
}

@end
