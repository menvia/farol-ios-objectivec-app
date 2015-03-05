//
//  MVAddBeaconViewController.h
//  FaroliOSSample
//
//  Created by Juliano Pacheco on 02/03/15.
//  Copyright (c) 2015 Menvia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MVBeacon;

typedef void(^MVBeaconAddedCompletion)(MVBeacon *newBeacon);

@interface MVAddBeaconViewController : UITableViewController

@property (nonatomic, copy) MVBeaconAddedCompletion beaconAddedCompletion;

@end
