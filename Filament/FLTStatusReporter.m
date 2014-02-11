//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTStatusReporter.h"

@implementation FLTStatusReporter

- (NSUInteger)numberOfJobs {
    
    return 0;
}

- (id)jobAtIndex:(NSUInteger)index {
    
    [NSException raise:NSInvalidArgumentException format:@"No job at index %ld.", index];
    
    return nil;
}

@end
