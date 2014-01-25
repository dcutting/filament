//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import "FLTJob.h"

@interface FLTJobTests : XCTestCase

@end

@implementation FLTJobTests

- (void)testConstruction_default_throws {
    
    XCTAssertThrows([FLTJob new], @"");
}

- (void)testConstruction_gitURLAndBranchName_OK {
    
    NSURL *gitURL = [NSURL URLWithString:@"https://github.com/AFNetworking/AFNetworking.git"];
    NSString *branchName = @"master";
    
    FLTJob *job = [[FLTJob alloc] initWithGitURL:gitURL branchName:branchName];
    
    XCTAssertNotNil(job, @"");
}

@end
