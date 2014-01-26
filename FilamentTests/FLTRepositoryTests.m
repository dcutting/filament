//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import "FLTRepository.h"

@interface FLTRepositoryTests : XCTestCase

@end

@implementation FLTRepositoryTests

- (void)testCheckout_doesComplete {
    
    NSURL *gitURL = [NSURL URLWithString:@"/path/to/git/repo"];
    NSString *branchName = @"mybranch";
    
    FLTRepository *repository = [[FLTRepository alloc] initWithGitURL:gitURL branchName:branchName];
    
    __block BOOL didComplete = NO;

    [repository checkoutWithCompletionHandler:^(FLTIntegratorConfiguration *configuration) {
        
        didComplete = YES;
    }];
    
    XCTAssertTrue(didComplete, @"Expected checkout to complete.");
}

@end
