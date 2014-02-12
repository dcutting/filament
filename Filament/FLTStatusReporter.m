//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTStatusReporter.h"

@interface FLTStatusReporter ()

@property (nonatomic, strong) NSMutableArray *jobs;

@end

@implementation FLTStatusReporter

- (id)init {
    
    self = [super init];
    if (self) {
        
        _jobs = [NSMutableArray new];
    }
    return self;
}

- (NSUInteger)numberOfJobs {
    
    return [self.jobs count];
}

- (FLTJob *)jobAtIndex:(NSUInteger)index {
    
    return self.jobs[index];
}

- (void)addJob:(FLTJob *)job {
    
    [self.jobs addObject:job];
}

@end
