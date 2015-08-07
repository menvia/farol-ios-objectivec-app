//
//  MVBeaconCell.m
//  FaroliOSSample
//
//  Created by Juliano Pacheco on 02/03/15.
//  Copyright (c) 2015 Menvia. All rights reserved.
//

#import "MVBeaconCell.h"
#import "MVBeacon.h"

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
    self.textLabel.text = _item.name;
}

- (void)dealloc{
    [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
}

- (NSString *)nameForProximity:(CLProximity)proximity{
    switch (proximity) {
        case CLProximityUnknown:
            return @"Desconhecido";
            break;
        case CLProximityImmediate:
            return @"Imediata";
            break;
        case CLProximityNear:
            return @"Próximo";
            break;
        case CLProximityFar:
            return @"Longe";
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.item] && [keyPath isEqualToString:@"lastSeenBeacon"]) {
        self.detailTextLabel.text = [NSString stringWithFormat:@"Localização: %@", [self nameForProximity:self.item.lastSeenBeacon.proximity]];
    }
}

@end
