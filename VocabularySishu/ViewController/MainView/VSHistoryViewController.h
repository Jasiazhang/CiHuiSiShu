//
//  VSMainMenuViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-8.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSDataUtil.h"
#import "VSContext.h"
#import "VSHisotryListCell.h"
#import "VSConfigurationViewController.h"
#import "VSMainViewController.h"
#import "VSContext.h"

@interface VSHistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {
    IBOutlet UITableView *historyTable;
    IBOutlet UIButton *startButton;
}

@property (nonatomic, retain) UIView *tableFooterView;
@property (nonatomic, retain) UIActivityIndicatorView *activator;
@property (nonatomic, retain) NSMutableArray *historyLists;
@property (nonatomic, strong) UITableView *historyTable;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, assign) BOOL loading;

- (IBAction)recite:(id)sender;

- (IBAction)initData:(id)sender;

- (IBAction)toRepoSelect:(id)sender;

- (void)reloadHistory;

- (IBAction)toConfigurationView:(id)sender;

@end
