//
//  MVLocationManager.h
//  FaroliOSSample
//
//  Created by Hermann, Douglas on 5/11/15.
//  Copyright (c) 2015 Menvia, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVBeacon.h"

@import CoreLocation;

@interface MVLocationManager : NSObject

@property (strong, nonatomic) NSMutableArray *beaconsToMonitor;

+(instancetype)sharedManager;
- (void)setupLocationManager;

- (CLBeaconRegion *)getBeaconRegion:(MVBeacon *)beacon;
- (void)startMonitoringBeacon:(MVBeacon *)beacon;
- (void)stopMonitoringBeacon:(MVBeacon *)beacon;

@end
