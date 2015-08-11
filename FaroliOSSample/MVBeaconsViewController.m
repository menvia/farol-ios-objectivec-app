//
//  MVBeaconsViewController.m
//  FaroliOSSample
//
//  Created by Juliano Pacheco on 02/03/15.
//  Copyright (c) 2015 Menvia. All rights reserved.
//

#import "MVBeaconsViewController.h"
#import "MVAddBeaconViewController.h"
#import "MVBeacon.h"
#import "MVBeaconCell.h"
#import "MVLocationManager.h"
#import "UIScrollView+EmptyDataSet.h"

static NSString * const kRWTStoredItemsKey = @"storedItems";

@interface MVBeaconsViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation MVBeaconsViewController 

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self customizeDZNEmptyDataSet];
    
    self.itemsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.itemsTableView.tableHeaderView.layer.borderWidth = 0;
    
    [self loadItems];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Add"]) {
        UINavigationController *navController = segue.destinationViewController;
        MVAddBeaconViewController *addItemViewController = (MVAddBeaconViewController *)navController.topViewController;
        [addItemViewController setBeaconAddedCompletion:^(MVBeacon *newItem) {
            [self.items addObject:newItem];
            [self.itemsTableView beginUpdates];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.items.count-1 inSection:0];
            [self.itemsTableView insertRowsAtIndexPaths:@[newIndexPath]
                                       withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.itemsTableView endUpdates];
            // método invocado para disparar o monitoramento do beacon
            [[MVLocationManager sharedManager] startMonitoringBeacon:newItem];
            [self persistItems];
        }];
    }
}

- (void)loadItems {
    NSArray *storedItems = [[NSUserDefaults standardUserDefaults] arrayForKey:kRWTStoredItemsKey];
    self.items = [NSMutableArray array];
    
    if (storedItems) {
        for (NSData *itemData in storedItems) {
            MVBeacon *item = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
            [self.items addObject:item];
            // disparando o monitoramento de beacons em memória
            [[MVLocationManager sharedManager] startMonitoringBeacon:item];
        }
    }
}

- (void)persistItems {
    NSMutableArray *itemsDataArray = [NSMutableArray array];
    for (MVBeacon *item in self.items) {
        NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
        [itemsDataArray addObject:itemData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:itemsDataArray forKey:kRWTStoredItemsKey];
}


#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MVBeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
    MVBeacon *item = self.items[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MVBeacon *itemToRemove = [self.items objectAtIndex:indexPath.row];
        [[MVLocationManager sharedManager] stopMonitoringBeacon:itemToRemove];
        [tableView beginUpdates];
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        [self persistItems];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MVBeacon *item = [self.items objectAtIndex:indexPath.row];
    NSString *detailMessage = [NSString stringWithFormat:@"UUID: %@\nMajor: %d\nMinor: %d", item.uuid.UUIDString, item.majorValue, item.minorValue];
    UIAlertView *detailAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DETAILS", nil) message:detailMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"CLOSE", nil) otherButtonTitles:nil];
    [detailAlert show];
}

#pragma mark - Custom methods
- (void)customizeDZNEmptyDataSet
{
    
    self.itemsTableView.tableFooterView = [UIView new];
    self.itemsTableView.emptyDataSetSource = self;
    self.itemsTableView.emptyDataSetDelegate = self;
    self.itemsTableView.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedString(@"NO_BEACONS_ADDED", nil);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"QuicksandBook-Regular" size:17.0f] range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedString(@"EMPTY_BEACONS", nil);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"QuicksandLight-Regular" size:12.0f] range:NSMakeRange(0, attributedString.length)];
    
    
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"No_Beacon"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CGPointZero;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldShow:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

@end
