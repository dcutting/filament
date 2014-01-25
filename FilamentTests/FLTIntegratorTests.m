//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <XCTest/XCTest.h>

#import <TRVSMonitor/TRVSMonitor.h>

#import "FLTIntegration.h"

static NSTimeInterval AsyncTimeout = 1.0f;

@interface FLTIntegratorTests : XCTestCase

@property (nonatomic, strong) FLTIntegrator *integrator;

@property (nonatomic, strong) TRVSMonitor *monitor;
@property (nonatomic, assign) BOOL didComplete;

@end

@implementation FLTIntegratorTests

- (void)setUp {
    
    self.integrator = [FLTIntegrator new];
    
    self.monitor = [TRVSMonitor monitor];
    self.didComplete = NO;
}

- (void)testIntegrateConfiguration_callsCompletionHandler {
    
    [self.integrator integrateConfiguration:nil completionHandler:^(FLTIntegrationReport *report) {
        
        [self signalCompletion];
    }];
    
    [self assertCompletion];
}

- (void)testIntegrateConfiguration_nilConfiguration_nilResult {
    
    [self.integrator integrateConfiguration:nil completionHandler:^(FLTIntegrationReport *report) {
        
        XCTAssertNil(report, @"");

        [self signalCompletion];
    }];

    [self assertCompletion];
}

- (void)signalCompletion {
    
    self.didComplete = YES;
    [self.monitor signal];
}

- (void)assertCompletion {
    
    [self.monitor waitWithTimeout:AsyncTimeout];
    XCTAssertTrue(self.didComplete, @"");
}

@end
