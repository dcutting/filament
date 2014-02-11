//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTStatusReporter.h"

@interface FLTStatusReporter ()

@end

@implementation FLTStatusReporter

- (NSUInteger)numberOfJobs {
    
    return 0;
}

- (FLTJob *)jobAtIndex:(NSUInteger)index {
    
    [NSException raise:NSInvalidArgumentException format:@"No job at index %ld.", index];
    
    return nil;
}

- (void)addJob:(FLTJob *)job {
}

@end
