//
//  MVLocationManager.m
//  FaroliOSSample
//
//  Created by Hermann, Douglas on 5/11/15.
//  Copyright (c) 2015 Menvia, Inc. All rights reserved.
//

#import "MVLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface MVLocationManager () <CLLocationManagerDelegate, CBCentralManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CBCentralManager* bluetoothManager;

@end

@implementation MVLocationManager

+(instancetype)sharedManager{
    static dispatch_once_t oncetoken;
    static MVLocationManager *sharedManager;
    dispatch_once(&oncetoken, ^{ sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupLocationManager];
    }
    return self;
}

#pragma mark - Location Manager

- (void)setupLocationManager
{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.beaconsToMonitor = [[NSMutableArray alloc] init];
    [self detectBluetooth];
    
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]] == NO){
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }else{
        
        if(![CLLocationManager locationServicesEnabled])
        {
            NSLog(NSLocalizedString(@"LOCATION_SERVICES_DISABLED", nil));
            
            NSString *message = NSLocalizedString(@"LOCATION_SERVICES_DISABLED", nil);
            [self raiseBluetoothAlert:message];
        }
        if(![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
        {
            NSLog(NSLocalizedString(@"REGION_NOT_AVAILABLE", nil));
            
            NSString *message = NSLocalizedString(@"BEACONS_FEATURE_NOT_AVAILABLE", nil);
            [self raiseBluetoothAlert:message];
        }
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
        {
            NSLog(NSLocalizedString(@"NOT_AUTHORIZED_LOCATION_SERVICES", nil));
            
            NSString *message = NSLocalizedString(@"NOT_AUTHORIZED_LOCATION_SERVICES", nil);
            [self raiseBluetoothAlert:message];
        }
    }
}

- (CLBeaconRegion *)getBeaconRegion:(MVBeacon *)beacon{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beacon.uuid
                                                                           major:beacon.majorValue
                                                                           minor:beacon.minorValue
                                                                      identifier:beacon.name];
    return beaconRegion;
}

- (void)startMonitoringBeacon:(MVBeacon *)beacon {
    
    CLBeaconRegion *beaconRegion = [self getBeaconRegion:beacon];
    [self.beaconsToMonitor addObject:beacon];
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    
}

- (void)stopMonitoringBeacon:(MVBeacon *)beacon {

    CLBeaconRegion *beaconRegion = [self getBeaconRegion:beacon];
    [self.beaconsToMonitor removeObject:beacon];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
    
}

- (void)raiseBluetoothAlert:(NSString*)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR_LOCATION_SERVICES", nil)
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(NSLocalizedString(@"FAIL_MONITORING_REGION", nil), error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(NSLocalizedString(@"LOCATION_FAILED", nil), error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    for(CLBeacon *beacon in beacons){
        
        for(MVBeacon *beaconToMonitor in self.beaconsToMonitor){
            
            if([beaconToMonitor isEqualToCLBeacon:beacon]){
                beaconToMonitor.lastSeenBeacon = beacon;
            }
            
        }
    }
}

#pragma mark - Bluetooth

- (void)detectBluetooth
{
    if(!self.bluetoothManager)
    {
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    
    [self centralManagerDidUpdateState:self.bluetoothManager];
}

#pragma mark - Bluetooth Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *status = nil;
    switch(_bluetoothManager.state)
    {
        case CBCentralManagerStateResetting:
            status = NSLocalizedString(@"BLUETOOTH_CONNECTION_LOST", nil);
            break;
        case CBCentralManagerStateUnsupported:
            status = NSLocalizedString(@"BLE_NOT_SUPPORTED", nil);
            break;
        case CBCentralManagerStateUnauthorized:
            status = NSLocalizedString(@"APP_NOT_AUTHORIZED_BLE", nil);
            break;
        case CBCentralManagerStatePoweredOff:
            status = NSLocalizedString(@"BLUETOOTH_NOT_ACTIVE", nil);
            break;
        case CBCentralManagerStatePoweredOn:
            status = NSLocalizedString(@"BLUETOOTH_ACTIVE_AVAILABLE", nil);
            break;
        default:
            status = NSLocalizedString(@"BLUETOOTH_START_UNKNOWN", nil);
            break;
    }
    
    if ( self.bluetoothManager.state == CBCentralManagerStateUnauthorized || self.bluetoothManager.state == CBCentralManagerStateUnsupported || self.bluetoothManager.state == CBCentralManagerStatePoweredOff){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth"
                                                        message:status
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
