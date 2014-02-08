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
@property (nonatomic, strong) id mockFileReader;
@property (nonatomic, strong) id mockJsonSerialiser;

@property (nonatomic, copy) NSURL *gitURL;

@end

/* To do:
 
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
    
    self.mockFileReader = [OCMockObject niceMockForClass:[FLTFileReader class]];
    self.mockJsonSerialiser = [OCMockObject niceMockForClass:[FLTJSONSerialiser class]];
    
    self.repository = [[FLTRepository alloc] initWithGitPath:GitPath taskFactory:self.mockTaskFactory fileReader:self.mockFileReader jsonSerialiser:self.mockJsonSerialiser];
    
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
    [[[self.mockFileReader stub] andReturn:configurationData] dataWithContentsOfFile:[OCMArg any]];

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

- (void)testCheckout_launchException_returnsToolFailureError {
    
    [[[self.mockTask stub] andThrow:[NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil]] launch];
        
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration, NSError *error) {

        XCTAssertNil(configuration, @"Expected nil configuration.");
        [self assertError:error hasDomain:FLTRepositoryErrorDomain code:FLTRepositoryErrorCodeToolFailure];
        
        [self signalCompletion];
    }];
    
    [self assertCompletion];
}

- (void)testCheckout_checkedOutBranch_returnsParsedConfigurationInCompletionHandler {

    NSString *resultsPath = [NSString pathWithComponents:@[ ClonePath, @"build.json" ]];
    NSString *rootPath = ClonePath;
    NSString *workspace = @"MyWorkspace.xcworkspace";
    NSString *scheme = @"MyScheme";
    
    [[[self.mockTask stub] andReturnValue:OCMOCK_VALUE(NSTaskTerminationReasonExit)] terminationReason];

    NSData *configurationData = [self sampleConfigurationData];
    NSString *configurationPath = [NSString pathWithComponents:@[ ClonePath, @".filament" ]];
    [[[self.mockFileReader stub] andReturn:configurationData] dataWithContentsOfFile:configurationPath];

    [[[self.mockJsonSerialiser stub] andReturn:[NSJSONSerialization JSONObjectWithData:configurationData options:0 error:NULL]]JSONObjectWithData:configurationData];

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

- (void)testCheckout_missingConfiguration_returnsMissingConfigurationError {
    
    [[[self.mockFileReader stub] andReturn:nil] dataWithContentsOfFile:[OCMArg any]];
    
    [[[self.mockTask stub] andReturnValue:OCMOCK_VALUE(NSTaskTerminationReasonExit)] terminationReason];

    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration, NSError *error) {
        
        XCTAssertNil(configuration, @"Expected nil configuration.");
        [self assertError:error hasDomain:FLTRepositoryErrorDomain code:FLTRepositoryErrorCodeMissingConfiguration];
        
        [self signalCompletion];
    }];
    
    gitTaskTerminationHandler(self.mockTask);
    
    [self assertCompletion];
}

- (void)testCheckout_corruptConfigurationJSON_returnsCorruptConfigurationError {
    
    [[[self.mockFileReader stub] andReturn:[NSData data]] dataWithContentsOfFile:[OCMArg any]];
    [[[self.mockJsonSerialiser stub] andReturn:nil] JSONObjectWithData:[OCMArg any]];
    
    [[[self.mockTask stub] andReturnValue:OCMOCK_VALUE(NSTaskTerminationReasonExit)] terminationReason];
    
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration, NSError *error) {
        
        XCTAssertNil(configuration, @"Expected nil configuration.");
        [self assertError:error hasDomain:FLTRepositoryErrorDomain code:FLTRepositoryErrorCodeCorruptConfiguration];
        
        [self signalCompletion];
    }];
    
    gitTaskTerminationHandler(self.mockTask);
    
    [self assertCompletion];
}

- (void)testCheckout_uncaughtSignalTerminationReason_returnsToolFailureError {
    
    [[[self.mockTask stub] andReturnValue:OCMOCK_VALUE(NSTaskTerminationReasonUncaughtSignal)] terminationReason];
    
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration, NSError *error) {
        
        XCTAssertNil(configuration, @"Expected nil configuration.");
        [self assertError:error hasDomain:FLTRepositoryErrorDomain code:FLTRepositoryErrorCodeToolFailure];
        
        [self signalCompletion];
    }];
    
    gitTaskTerminationHandler(self.mockTask);
    
    [self assertCompletion];
}

- (void)testCheckout_errorTerminationStatus_returnsBadExitCodeError {
    
    [[[self.mockFileReader stub] andReturn:[NSData data]] dataWithContentsOfFile:[OCMArg any]];

    [[[self.mockTask stub] andReturnValue:OCMOCK_VALUE(NSTaskTerminationReasonExit)] terminationReason];
    [[[self.mockTask stub] andReturnValue:OCMOCK_VALUE(128)] terminationStatus];
    
    [self.repository checkoutGitURL:self.gitURL branchName:BranchName toPath:ClonePath completionHandler:^(FLTIntegratorConfiguration *configuration, NSError *error) {
        
        XCTAssertNil(configuration, @"Expected nil configuration.");
        [self assertError:error hasDomain:FLTRepositoryErrorDomain code:FLTRepositoryErrorCodeBadExitCode];
        
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
