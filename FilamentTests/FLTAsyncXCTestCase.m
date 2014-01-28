//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTAsyncXCTestCase.h"

static NSTimeInterval AsyncTimeout = 1.0f;

@interface FLTAsyncXCTestCase ()

@property (nonatomic, strong) TRVSMonitor *asyncMonitor;
@property (nonatomic, assign) BOOL didCompleteAsync;

@end

@implementation FLTAsyncXCTestCase

- (void)setUp {
    
    self.asyncMonitor = [TRVSMonitor monitor];
    self.didCompleteAsync = NO;
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
