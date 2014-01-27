//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "FLTIntegration.h"

static NSString *BranchName = @"myBranch";
static NSString *ToPath = @"/path/to/clone";

@interface FLTIntegrationTests : XCTestCase

@property (nonatomic, strong) FLTIntegration *integration;

@property (nonatomic, strong) id mockRepository;
@property (nonatomic, strong) id mockIntegrator;

@property (nonatomic, strong) NSURL *gitURL;

@end

@implementation FLTIntegrationTests

- (void)setUp {
    
    self.mockRepository = [OCMockObject niceMockForClass:[FLTRepository class]];
    
    self.mockIntegrator = [OCMockObject niceMockForClass:[FLTIntegrator class]];
    
    self.integration = [[FLTIntegration alloc] initWithIntegrator:self.mockIntegrator];

    self.gitURL = [NSURL URLWithString:@"/path/to/git/repo"];
}

- (void)testIntegrate_checksOutRepository {
    
    [[self.mockRepository expect] checkoutGitURL:self.gitURL branchName:BranchName toPath:ToPath completionHandler:[OCMArg any]];
    
    [self.integration integrateGitURL:self.gitURL branchName:BranchName toPath:ToPath repository:self.mockRepository completionHandler:nil];
    
    [self.mockRepository verify];
}

- (void)testIntegrate_afterCheckout_integratesWithConfiguration {
    
    __block FLTRepositoryCompletionHandler completionHandler;
    [[[self.mockRepository stub] andDo:^(NSInvocation *invocation) {
        FLTRepositoryCompletionHandler block;
        [invocation getArgument:&block atIndex:5];
        completionHandler = block;
    }] checkoutGitURL:self.gitURL branchName:BranchName toPath:ToPath completionHandler:[OCMArg any]];
    
    [self.integration integrateGitURL:self.gitURL branchName:BranchName toPath:ToPath repository:self.mockRepository completionHandler:nil];
    
    FLTIntegratorConfiguration *configuration = [FLTIntegratorConfiguration new];

    [[self.mockIntegrator expect] integrateConfiguration:configuration completionHandler:nil];
    
    completionHandler(configuration);
    
    [self.mockIntegrator verify];
}

@end
