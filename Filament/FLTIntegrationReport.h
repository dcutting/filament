//  Copyright (c) 2014 Yellowbek Ltd. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FLTIntegrationReportStatus) {
    
    FLTIntegrationReportStatusSuccess,
    FLTIntegrationReportStatusFailureWarnings,
    FLTIntegrationReportStatusFailureErrors
};

@interface FLTIntegrationReport : NSObject

@property (nonatomic, assign) FLTIntegrationReportStatus status;
@property (nonatomic, assign) NSInteger numberOfErrors;
@property (nonatomic, assign) NSInteger numberOfWarnings;

@end
