//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "FLTIntegration.h"

@interface FLTIntegrationTests : XCTestCase

@end

@implementation FLTIntegrationTests

- (void)testIntegrate_checksOutRepository {
    
    id mockIntegrator = [OCMockObject niceMockForClass:[FLTIntegrator class]];
    
    FLTIntegration *integration = [[FLTIntegration alloc] initWithIntegrator:mockIntegrator];
    
    id mockRepository = [OCMockObject niceMockForClass:[FLTRepository class]];
    
    NSURL *gitURL = [NSURL URLWithString:@"/path/to/git/repo"];
    NSString *branchName = @"myBranch";
    NSString *toPath = @"/path/to/clone";
    
    [[mockRepository expect] checkoutGitURL:gitURL branchName:branchName toPath:toPath completionHandler:[OCMArg any]];
    
    [integration integrateGitURL:gitURL branchName:branchName toPath:toPath repository:mockRepository completionHandler:nil];
    
    [mockRepository verify];
}

@end
