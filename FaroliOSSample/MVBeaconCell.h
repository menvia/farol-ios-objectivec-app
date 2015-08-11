//
//  MVBeaconCell.h
//  FaroliOSSample
//
//  Created by Juliano Pacheco on 02/03/15.
//  Copyright (c) 2015 Menvia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MVBeacon;

@interface MVBeaconCell : UITableViewCell

@property (strong, nonatomic) MVBeacon *item;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;

@end
