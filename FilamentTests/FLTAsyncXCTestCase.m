//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTAsyncXCTestCase.h"

static NSTimeInterval AsyncTimeout = 1.0f;

@interface FLTAsyncXCTestCase ()

@property (nonatomic, strong) TRVSMonitor *asyncMonitor;
@property (nonatomic, assign) BOOL didNotCompleteAsync;

@end

@implementation FLTAsyncXCTestCase

- (void)setUp {
    
    self.asyncMonitor = [TRVSMonitor monitor];
    self.didNotCompleteAsync = YES;
}

- (void)signalCompletion {
    
    self.didNotCompleteAsync = NO;
    [self.asyncMonitor signal];
}

- (void)assertCompletion {
    
    [self.asyncMonitor waitWithTimeout:AsyncTimeout];
    XCTAssertFalse(self.didNotCompleteAsync, @"");
}

- (void)assertNoCompletion {
    
    [self.asyncMonitor waitWithTimeout:AsyncTimeout];
    XCTAssertTrue(self.didNotCompleteAsync, @"");
}

@end
