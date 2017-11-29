//
//  MasterViewController.m
//  GitClientTest
//
//  Created by kristyna on 11/29/17.
//  Copyright © 2017 kristyna. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "RepoTableViewCell.h"

#import "GTDataRequest.h"
#import "RepositoryMO+CoreDataClass.h"
#import "GCDataController.h"
#import "RepositoryModel.h"
#import "Reachability.h"

#define kCellIdent @"repoCell"
#define kSegueIdent @"showDetail"
#define alertTitle @"No network connection"
#define alertMessage  @"You must be connected to the internet to use this app."

static const NSUInteger kCellsCountBeforeReq = 5;

@interface MasterViewController ()

@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) GCDataController *dataController;
@property (strong, nonatomic) GTDataRequest *request;
@property (strong, nonatomic) UIRefreshControl *customRefreshControl;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.results = [[NSMutableArray alloc] init];
    self.request = [[GTDataRequest alloc] init];
    self.dataController = [GCDataController new];
    
    if ([self.dataController getAllRepos].count == 0) {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        
        if (networkStatus != NotReachable) {
            [self getElementsFromBorder:0];
            
        }
    }
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.activityView.center = self.view.center;
    [self.view addSubview:self.activityView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:alertTitle
                                              message:alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                      
                                   }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    } else if ([self.dataController getAllRepos].count == 0 && networkStatus != NotReachable) {
        
        [self.activityView startAnimating];
    }
    
    if (networkStatus == NotReachable && [self.dataController getAllRepos].count == 0) {
        self.customRefreshControl = [[UIRefreshControl alloc] init];
        [self.customRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
//        [self.customRefreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.05];
        [self.view addSubview:self.customRefreshControl];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kSegueIdent]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RepositoryMO *model = [[self.dataController getAllRepos] objectAtIndex:indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:model];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataController getAllRepos].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdent forIndexPath:indexPath];
    RepositoryMO *repoModel = [[self.dataController getAllRepos] objectAtIndex:indexPath.row];
    
    cell.repoName.text = repoModel.fullName;
    [cell.userImage sd_setImageWithURL: [NSURL URLWithString:repoModel.avatarURL] placeholderImage:nil];
    
    if (indexPath.row == [self.dataController  getAllRepos].count - kCellsCountBeforeReq) {
        RepositoryMO *model = [self.dataController getAllRepos].lastObject;
        
        [self getElementsFromBorder:model.repoId];
    }
    
    return cell;
}

- (void) getElementsFromBorder:(int)border {
    
    [self.request getElementsFromBorder:border completition:^(NSData *data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            
            [self.results addObjectsFromArray:[RepositoryModel arrayOfModelsFromData:data error:nil]];
            [self.dataController saveRepos:self.results];
            
            [self.tableView reloadData];
            
        });
    }];
    
}

- (void)refresh:(id)sender {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:alertTitle
                                              message:alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self.customRefreshControl endRefreshing];
                                   }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    
    } else if ([self.dataController getAllRepos].count == 0 && networkStatus != NotReachable) {
        [self getElementsFromBorder:0];
        [self.customRefreshControl endRefreshing];
        [self.activityView startAnimating];
    }

}

@end
