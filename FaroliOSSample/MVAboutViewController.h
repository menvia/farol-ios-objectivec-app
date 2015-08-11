//
//  MVAboutViewController.h
//  FaroliOSSample
//
//  Created by Hermann, Douglas on 6/29/15.
//  Copyright (c) 2015 Menvia, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVAboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *appnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITextView *informationTextView;

- (IBAction)close:(id)sender;

@end
