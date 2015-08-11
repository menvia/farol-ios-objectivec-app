//
//  MVBeaconCell.m
//  FaroliOSSample
//
//  Created by Juliano Pacheco on 02/03/15.
//  Copyright (c) 2015 Menvia. All rights reserved.
//

#import "MVBeaconCell.h"
#import "MVBeacon.h"
#import "MVLocationManager.h"

@implementation MVBeaconCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.item = nil;
}

- (void)setItem:(MVBeacon *)item {
    if(_item){
        [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
    }
    _item = item;
    
    [_item addObserver:self
            forKeyPath:@"lastSeenBeacon"
            options:NSKeyValueObservingOptionNew
               context:NULL];
    self.nameLabel.text = _item.name;
}

- (void)dealloc{
    [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
}

- (NSString *)nameForProximity:(CLProximity)proximity{
    switch (proximity) {
        case CLProximityUnknown:
            return NSLocalizedString(@"UNKNOWN", nil);
            break;
        case CLProximityImmediate:
            return NSLocalizedString(@"IMMEDIATE", nil);
            break;
        case CLProximityNear:
            return NSLocalizedString(@"NEAR", nil);
            break;
        case CLProximityFar:
            return NSLocalizedString(@"FAR", nil);
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.item] && [keyPath isEqualToString:@"lastSeenBeacon"]) {
        self.proximityLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"PROXIMITY", nil), [self nameForProximity:self.item.lastSeenBeacon.proximity]];
        self.accuracyLabel.text = [NSString stringWithFormat:@"%@: %.2f", NSLocalizedString(@"ACCURACY", nil), self.item.lastSeenBeacon.accuracy];
        self.rssiLabel.text = [NSString stringWithFormat:@"RSSI: %li", (long)self.item.lastSeenBeacon.rssi];
    }
}

@end
