//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "FLTRepository.h"

static NSString *GitPath = @"/path/to/git";
static NSString *GitURLString = @"/path/to/git/repo";
static NSString *ClonePath = @"/path/to/cloned/repo";

static NSString *BranchName = @"mybranch";

@interface FLTRepositoryTests : XCTestCase

@property (nonatomic, strong) FLTRepository *repository;

@property (nonatomic, strong) id mockTaskFactory;
@property (nonatomic, strong) id mockTask;

@property (nonatomic, copy) NSURL *gitURL;

@end

@implementation FLTRepositoryTests

- (void)setUp {

    self.mockTaskFactory = [OCMockObject niceMockForClass:[NSTaskFactory class]];
    self.mockTask = [OCMockObject niceMockForClass:[NSTask class]];
    [[[self.mockTaskFactory stub] andReturn:self.mockTask] task];
    
    self.repository = [[FLTRepository alloc] initWithGitPath:GitPath taskFactory:self.mockTaskFactory];
    
    self.gitURL = [NSURL URLWithString:GitURLString];
}

- (void)testCheckout_doesComplete {
    
    __block BOOL didComplete = NO;
    
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration) {
        
        didComplete = YES;
    }];
    
    XCTAssertTrue(didComplete, @"Expected checkout to complete.");
}

- (void)testCheckout_launchesGitCloneTask {
    
    NSArray *arguments = @[ @"clone", GitURLString, ClonePath ];
    
    [[self.mockTask expect] setLaunchPath:GitPath];
    [[self.mockTask expect] setArguments:arguments];
    [[self.mockTask expect] launch];
    
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:nil];
    
    [self.mockTask verify];
}

@end
