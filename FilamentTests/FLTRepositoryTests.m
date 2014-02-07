//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <OCMock/OCMock.h>

#import "FLTAsyncXCTestCase.h"
#import "FLTRepository.h"

static NSString *GitPath = @"/path/to/git";
static NSString *GitURLString = @"/path/to/git/repo";
static NSString *ClonePath = @"/path/to/cloned/repo";
static NSString *BranchName = @"mybranch";

void (^gitTaskTerminationHandler)(NSTask *);

@interface FLTRepositoryTests : FLTAsyncXCTestCase

@property (nonatomic, strong) FLTRepository *repository;

@property (nonatomic, strong) id mockTaskFactory;
@property (nonatomic, strong) id mockTask;
@property (nonatomic, strong) id mockData;

@property (nonatomic, copy) NSURL *gitURL;

@end

/* To do:
 
 * Catch NSInvalidArgumentException on task launch when path is invalid or cannot create task.
 * Handle tasks terminated by uncaught signals.
 * Could not decode JSON.
 * Handle unexpected JSON.
 * Should this class also pull down git submodules?
 * Rework to accept git URL, branch name and clone path as constructor arguments. This will make handling of different sorts of repositories easier.
 
 */

@implementation FLTRepositoryTests

- (void)setUp {

    [super setUp];
    
    self.mockTaskFactory = [OCMockObject niceMockForClass:[NSTaskFactory class]];
    self.mockTask = [OCMockObject niceMockForClass:[NSTask class]];
    [[[self.mockTaskFactory stub] andReturn:self.mockTask] task];
    
    self.mockData = [OCMockObject niceMockForClass:[NSData class]];
    
    self.repository = [[FLTRepository alloc] initWithGitPath:GitPath taskFactory:self.mockTaskFactory];
    
    self.gitURL = [NSURL URLWithString:GitURLString];

    [self captureTerminationHandler:&gitTaskTerminationHandler];
}

- (void)captureTerminationHandler:(void (^ __strong *)(NSTask *))terminationHandler {
    
    [[[self.mockTask stub] andDo:^(NSInvocation *invocation) {
        void (^block)(NSTask *);
        [invocation getArgument:&block atIndex:2];
        *terminationHandler = block;
    }] setTerminationHandler:[OCMArg any]];
}

- (void)testCheckout_doesComplete {
    
    NSData *configurationData = [self sampleConfigurationData];
    [[[[self.mockData stub] andReturn:configurationData] classMethod] dataWithContentsOfFile:[OCMArg any]];

    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration, NSError *error) {
        
        [self signalCompletion];
    }];
    
    gitTaskTerminationHandler(self.mockTask);
    
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
    
    NSData *configurationData = [self sampleConfigurationData];
    [[[[self.mockData stub] andReturn:configurationData] classMethod] dataWithContentsOfFile:configurationPath];

    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration, NSError *error) {
        
        XCTAssertEqualObjects(resultsPath, configuration.resultsPath, @"Expected '%@' but got '%@' for results path.", resultsPath, configuration.resultsPath);
        XCTAssertEqualObjects(rootPath, configuration.rootPath, @"Expected '%@' but got '%@' for root path.", rootPath, configuration.rootPath);
        XCTAssertEqualObjects(workspace, configuration.workspace, @"Expected '%@' but got '%@' for workspace.", workspace, configuration.workspace);
        XCTAssertEqualObjects(scheme, configuration.scheme, @"Expected '%@' but got '%@' for scheme.", scheme, configuration.scheme);

        [self signalCompletion];
    }];
    
    gitTaskTerminationHandler(self.mockTask);
    
    [self assertCompletion];
}

- (void)testCheckout_missingConfiguration_returnsNilConfigurationInCompletionHandler {
    
    [[[[self.mockData stub] andReturn:nil] classMethod] dataWithContentsOfFile:[OCMArg any]];
    
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration, NSError *error) {
        
        XCTAssertNil(configuration, @"Expected nil configuration.");
        [self assertError:error hasDomain:FLTRepositoryErrorDomain code:FLTRepositoryErrorCodeMissingConfiguration];
        
        [self signalCompletion];
    }];
    
    gitTaskTerminationHandler(self.mockTask);
    
    [self assertCompletion];
}

- (void)testCheckout_errorExitStatus_returnsNilConfigurationInCompletionHandler {
    
    [[[[self.mockData stub] andReturn:[NSData data]] classMethod] dataWithContentsOfFile:[OCMArg any]];

    [[[self.mockTask stub] andReturnValue:OCMOCK_VALUE(128)] terminationStatus];
    
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration, NSError *error) {
        
        XCTAssertNil(configuration, @"Expected nil configuration but got '%@'.", configuration);
        
        [self signalCompletion];
    }];
    
    gitTaskTerminationHandler(self.mockTask);

    [self assertCompletion];
}

- (NSData *)sampleConfigurationData {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *path = [bundle pathForResource:@"ConfigurationFile.json" ofType:nil];
    
    return [NSData dataWithContentsOfFile:path];
}

- (void)assertError:(NSError *)error hasDomain:(NSString *)domain code:(NSInteger)code {
    
    XCTAssertEqualObjects(domain, error.domain, @"Expected error domain '%@' but got '%@'.", domain, error.domain);
    XCTAssertEqual(code, error.code, @"Expected error code %ld but got %ld.", code, error.code);
}

@end
