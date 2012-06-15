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

@interface VSMainMenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *historyTable;
}

@property (nonatomic, retain) NSArray *historyLists;
@property (nonatomic, strong) UITableView *historyTable;


- (IBAction)recite:(id)sender;

- (IBAction)initData:(id)sender;


@end
