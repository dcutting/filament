//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import <TRVSMonitor/TRVSMonitor.h>

#import "FLTIntegration.h"

static NSTimeInterval AsyncTimeout = 5.0f;

@interface FLTIntegratorTests : XCTestCase

@end

@implementation FLTIntegratorTests

- (void)testIntegrateConfiguration_callsCompletionHandler {
    
    FLTIntegrator *integrator = [FLTIntegrator new];
    
    __block BOOL didComplete = NO;
    TRVSMonitor *monitor = [TRVSMonitor monitor];

    [integrator integrateConfiguration:nil completionHandler:^(FLTIntegrationReport *report) {
        
        didComplete = YES;
        [monitor signal];
    }];
    
    [monitor waitWithTimeout:AsyncTimeout];
    
    XCTAssertTrue(didComplete, @"");
}

- (void)testIntegrateConfiguration_nilConfiguration_nilResult {
    
    FLTIntegrator *integrator = [FLTIntegrator new];
    
    TRVSMonitor *monitor = [TRVSMonitor monitor];
    __block BOOL didComplete = NO;

    [integrator integrateConfiguration:nil completionHandler:^(FLTIntegrationReport *report) {
        
        XCTAssertNil(report, @"");
        didComplete = YES;
        [monitor signal];
    }];

    [monitor waitWithTimeout:AsyncTimeout];

    XCTAssertTrue(didComplete, @"");
}

@end
