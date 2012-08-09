//
//  VSSingleListView.h
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSList.h"

@interface VSSingleListView : UIView

@property (nonatomic, assign) int index;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) VSList *theList;

- (void)initWithList:(VSList *)list;

@end
