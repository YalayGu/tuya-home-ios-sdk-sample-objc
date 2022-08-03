//
//  DeviceListTableViewController.m
//  TuyaAppSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "DeviceListTableViewController.h"
#import "Home.h"
#import "Alert.h"
#import "DeviceControlTableViewController.h"
#import "TuyaLinkDeviceControlController.h"

@interface DeviceListTableViewController () <TuyaSmartHomeDelegate>
@property (strong, nonatomic) TuyaSmartHome *home;
@end

@implementation DeviceListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([Home getCurrentHome]) {
        self.home = [TuyaSmartHome homeWithHomeId:[Home getCurrentHome].homeId];
        self.home.delegate = self;
        [self updateHomeDetail];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.home?self.home.deviceList.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"device-list-cell" forIndexPath:indexPath];
    TuyaSmartDeviceModel *deviceModel = self.home.deviceList[indexPath.row];
    cell.textLabel.text = deviceModel.name;
    cell.detailTextLabel.text = deviceModel.isOnline ? NSLocalizedString(@"Online", @"") : NSLocalizedString(@"Offline", @"");
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *deviceID = self.home.deviceList[indexPath.row].devId;
    TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:deviceID];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DeviceList" bundle:nil];
    NSString *identifier = [device.deviceModel isSupportThingModelDevice] ? @"TuyaLinkDeviceControlController" : @"DeviceControlTableViewController";
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:identifier];
    
    if ([device.deviceModel isSupportThingModelDevice]) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Fetching Thing Model", @"")];
        [device getThingModelWithSuccess:^(TuyaSmartThingModel * _Nullable thingModel) {
            [SVProgressHUD dismiss];
            ((TuyaLinkDeviceControlController *)vc).device = device;
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed to Fetch Thing Model", @"")];
        }];
    } else {
        ((DeviceControlTableViewController *)vc).device = device;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)updateHomeDetail {
    [self.home getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Alert showBasicAlertOnVC:self withTitle:NSLocalizedString(@"Failed to Fetch Home", @"") message:error.localizedDescription];
    }];
}

- (void)homeDidUpdateInfo:(TuyaSmartHome *)home {
    [self.tableView reloadData];
}

-(void)home:(TuyaSmartHome *)home didAddDeivice:(TuyaSmartDeviceModel *)device {
    [self.tableView reloadData];
}

-(void)home:(TuyaSmartHome *)home didRemoveDeivice:(NSString *)devId {
    [self.tableView reloadData];
}

-(void)home:(TuyaSmartHome *)home deviceInfoUpdate:(TuyaSmartDeviceModel *)device {
    [self.tableView reloadData];
}

-(void)home:(TuyaSmartHome *)home device:(TuyaSmartDeviceModel *)device dpsUpdate:(NSDictionary *)dps {
    [self.tableView reloadData];
}
@end
