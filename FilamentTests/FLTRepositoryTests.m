//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <OCMock/OCMock.h>

#import "FLTAsyncXCTestCase.h"
#import "FLTRepository.h"

static NSString *GitPath = @"/path/to/git";
static NSString *GitURLString = @"/path/to/git/repo";
static NSString *ClonePath = @"/path/to/cloned/repo";

static NSString *BranchName = @"mybranch";

@interface FLTRepositoryTests : FLTAsyncXCTestCase

@property (nonatomic, strong) FLTRepository *repository;

@property (nonatomic, strong) id mockTaskFactory;
@property (nonatomic, strong) id mockTask;

@property (nonatomic, copy) NSURL *gitURL;

@end

@implementation FLTRepositoryTests

- (void)setUp {

    [super setUp];
    
    self.mockTaskFactory = [OCMockObject niceMockForClass:[NSTaskFactory class]];
    self.mockTask = [OCMockObject niceMockForClass:[NSTask class]];
    [[[self.mockTaskFactory stub] andReturn:self.mockTask] task];
    
    self.repository = [[FLTRepository alloc] initWithGitPath:GitPath taskFactory:self.mockTaskFactory];
    
    self.gitURL = [NSURL URLWithString:GitURLString];
}

- (void)testCheckout_doesComplete {
    
    __block void (^terminationHandler)(NSTask *);
    [[[self.mockTask stub] andDo:^(NSInvocation *invocation) {
        void (^block)(NSTask *);
        [invocation getArgument:&block atIndex:2];
        terminationHandler = block;
    }] setTerminationHandler:[OCMArg any]];
    
    NSData *configurationData = [self sampleConfigurationData];
    id mockData = [OCMockObject niceMockForClass:[NSData class]];
    [[[[mockData stub] andReturn:configurationData] classMethod] dataWithContentsOfFile:[OCMArg any]];

    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration) {
        
        [self signalCompletion];
    }];
    
    terminationHandler(self.mockTask);
    
    [self assertCompletion];
}

- (void)testCheckout_launchesGitCloneTask {
    
    [[self.mockTask expect] setLaunchPath:GitPath];
    [[self.mockTask expect] setArguments:@[ @"clone", @"--branch", BranchName, GitURLString, ClonePath ]];
    [[self.mockTask expect] launch];
    
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:nil];
    
    [self.mockTask verify];
}

- (void)testCheckout_checkedOutBranch_returnsParsedConfigurationInCompletionHandler {

    NSString *resultsPath = [NSString pathWithComponents:@[ ClonePath, @"build.json" ]];
    NSString *rootPath = ClonePath;
    NSString *workspace = @"MyWorkspace.xcworkspace";
    NSString *scheme = @"MyScheme";
    
    NSString *configurationPath = [NSString pathWithComponents:@[ ClonePath, @".filament" ]];
    
    __block void (^terminationHandler)(NSTask *);
    [[[self.mockTask stub] andDo:^(NSInvocation *invocation) {
        void (^block)(NSTask *);
        [invocation getArgument:&block atIndex:2];
        terminationHandler = block;
    }] setTerminationHandler:[OCMArg any]];
    
    NSData *configurationData = [self sampleConfigurationData];
    id mockData = [OCMockObject niceMockForClass:[NSData class]];
    [[[[mockData stub] andReturn:configurationData] classMethod] dataWithContentsOfFile:configurationPath];

    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration) {
        
        XCTAssertEqualObjects(resultsPath, configuration.resultsPath, @"Expected '%@' but got '%@' for results path.", resultsPath, configuration.resultsPath);
        XCTAssertEqualObjects(rootPath, configuration.rootPath, @"Expected '%@' but got '%@' for root path.", rootPath, configuration.rootPath);
        XCTAssertEqualObjects(workspace, configuration.workspace, @"Expected '%@' but got '%@' for workspace.", workspace, configuration.workspace);
        XCTAssertEqualObjects(scheme, configuration.scheme, @"Expected '%@' but got '%@' for scheme.", scheme, configuration.scheme);

        [self signalCompletion];
    }];
    
    terminationHandler(self.mockTask);
    
    [self.mockTask verify];
    
    [self assertCompletion];
}

- (NSData *)sampleConfigurationData {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *path = [bundle pathForResource:@"ConfigurationFile.json" ofType:nil];
    
    return [NSData dataWithContentsOfFile:path];
}

@end
