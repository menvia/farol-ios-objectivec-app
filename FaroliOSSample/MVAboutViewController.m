//
//  MVAboutViewController.m
//  FaroliOSSample
//
//  Created by Hermann, Douglas on 6/29/15.
//  Copyright (c) 2015 Menvia, Inc. All rights reserved.
//

#import "MVAboutViewController.h"

@interface MVAboutViewController ()

@end

@implementation MVAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"ABOUT", nil);
    
    self.appnameLabel.text = (NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    self.versionLabel.text = [NSString stringWithFormat:@"v %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    self.informationTextView.text = NSLocalizedString(@"MENVIA_INFO", nil);

}

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
