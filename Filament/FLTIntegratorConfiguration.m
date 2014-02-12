//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import "FLTIntegratorConfiguration.h"

@implementation FLTIntegratorConfiguration

- (NSString *)description {
    
    return [NSString stringWithFormat:@"resultsPath=%@, rootPath=%@, workspace=%@, scheme=%@", self.resultsPath, self.rootPath, self.workspace, self.scheme];
    
}

@end
