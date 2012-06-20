//
//  VSVocabularyListViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 5/21/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSVocabulary.h"
#import "VSMeaningView.h"
#import "VSVocabularyListHeaderView.h"
#import "VSConstant.h"
#import "VSList.h"
#import "VSAlertDelegate.h"

@class VSAlertDelegate;

@interface VSVocabularyListViewController : UITableViewController<UIGestureRecognizerDelegate>

@property (nonatomic, retain) NSMutableArray *vocabulariesToRecite;
@property (nonatomic, strong) VSVocabularyListHeaderView *headerView;
@property (nonatomic, retain) VSList *listToday;
@property (nonatomic, retain) VSList *currentList;
@property (nonatomic, assign) CGFloat meaningCellHeight;
@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, assign) int draggedIndex;
@property (nonatomic, assign) int countInList;
@property (nonatomic, assign) int rememberCount;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, strong) UITableViewCell *draggedCell;
@property (nonatomic, strong) UIView *rememberView;
@property (nonatomic, strong) UIView *forgetView;
@property (nonatomic, strong) VSMeaningView *meaningView;
@property (nonatomic, strong) UIAlertView *alertWhenFinish;
@property (nonatomic, retain) VSAlertDelegate *alertDelegate;

@end
