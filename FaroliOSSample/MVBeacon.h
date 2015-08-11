//
//  MVBeacon.h
//  FaroliOSSample
//
//  Created by Douglas Hermann on 02/03/15.
//  Copyright (c) 2015 Menvia. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface MVBeacon : NSObject <NSCoding>

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSUUID *uuid;
@property (assign, nonatomic, readonly) CLBeaconMajorValue majorValue;
@property (assign, nonatomic, readonly) CLBeaconMinorValue minorValue;
@property (strong, nonatomic) CLBeacon *lastSeenBeacon;


- (instancetype)initWithName:(NSString *)name
                        uuid:(NSUUID *)uuid
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor;


- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;

@end
