//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>
#import <TRVSMonitor/TRVSMonitor.h>

#import "FLTRepository.h"

static NSTimeInterval AsyncTimeout = 1.0f;

static NSString *GitPath = @"/path/to/git";
static NSString *GitURLString = @"/path/to/git/repo";
static NSString *ClonePath = @"/path/to/cloned/repo";

static NSString *BranchName = @"mybranch";

@interface FLTRepositoryTests : XCTestCase

@property (nonatomic, strong) FLTRepository *repository;

@property (nonatomic, strong) id mockTaskFactory;
@property (nonatomic, strong) id mockTask;

@property (nonatomic, copy) NSURL *gitURL;

@property (nonatomic, strong) TRVSMonitor *asyncMonitor;
@property (nonatomic, assign) BOOL didCompleteAsync;

@end

@implementation FLTRepositoryTests

- (void)setUp {

    self.mockTaskFactory = [OCMockObject niceMockForClass:[NSTaskFactory class]];
    self.mockTask = [OCMockObject niceMockForClass:[NSTask class]];
    [[[self.mockTaskFactory stub] andReturn:self.mockTask] task];
    
    self.repository = [[FLTRepository alloc] initWithGitPath:GitPath taskFactory:self.mockTaskFactory];
    
    self.gitURL = [NSURL URLWithString:GitURLString];

    self.asyncMonitor = [TRVSMonitor monitor];
    self.didCompleteAsync = NO;
}

- (void)testCheckout_doesComplete {
    
    __block void (^terminationHandler)(NSTask *);
    [[[self.mockTask stub] andDo:^(NSInvocation *invocation) {
        void (^block)(NSTask *);
        [invocation getArgument:&block atIndex:2];
        terminationHandler = block;
    }] setTerminationHandler:[OCMArg any]];
    
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration) {
        
        [self signalCompletion];
    }];
    
    terminationHandler(self.mockTask);
    
    [self assertCompletion];
}

- (void)testCheckout_launchesGitCloneTask {
    
    [[self.mockTask expect] setLaunchPath:GitPath];
    [[self.mockTask expect] setArguments:@[ @"clone", GitURLString, ClonePath ]];
    [[self.mockTask expect] launch];
    
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:nil];
    
    [self.mockTask verify];
}

- (void)testCheckout_checksOutSpecifiedBranch {
    
    __block void (^terminationHandler)(NSTask *);
    [[[self.mockTask stub] andDo:^(NSInvocation *invocation) {
        void (^block)(NSTask *);
        [invocation getArgument:&block atIndex:2];
        terminationHandler = block;
    }] setTerminationHandler:[OCMArg any]];

    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:nil];
    
    [[self.mockTask expect] setLaunchPath:GitPath];
    [[self.mockTask expect] setCurrentDirectoryPath:ClonePath];
    [[self.mockTask expect] setArguments:@[ @"checkout", BranchName ]];
    [[self.mockTask expect] launch];
    
    terminationHandler(self.mockTask);
    
    [self.mockTask verify];
}

- (void)signalCompletion {
    
    self.didCompleteAsync = YES;
    [self.asyncMonitor signal];
}

- (void)assertCompletion {
    
    [self.asyncMonitor waitWithTimeout:AsyncTimeout];
    XCTAssertTrue(self.didCompleteAsync, @"");
}

- (void)assertNoCompletion {
    
    [self.asyncMonitor waitWithTimeout:AsyncTimeout];
    XCTAssertFalse(self.didCompleteAsync, @"");
}

@end
