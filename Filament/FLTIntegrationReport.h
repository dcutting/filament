//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FLTIntegrationReportStatus) {
    
    FLTIntegrationReportStatusSuccess,
    FLTIntegrationReportStatusFailure
};

@interface FLTIntegrationReport : NSObject

@property (nonatomic, assign) FLTIntegrationReportStatus status;

@end
