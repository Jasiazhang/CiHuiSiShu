//
//  VSHisotryListCell.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/7/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSHisotryListCell.h"
#import "VSListRecord.h"

@implementation VSHisotryListCell
@synthesize dateLabel;
@synthesize reciteLabel;
@synthesize notRememberWellLabel;
@synthesize detailImage;
@synthesize list;
@synthesize numberFormatter;
@synthesize backgroundImage ;
@synthesize viewSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        [self.numberFormatter setPositiveFormat:@"0.0%;0.0%-0.0%"];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 8, 120, 30)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = UITextAlignmentLeft;
        self.dateLabel.textColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.dateLabel.font = [UIFont boldSystemFontOfSize:20];
        self.dateLabel.shadowOffset = CGSizeMake(0, 1);
        self.dateLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.4];
    
        self.reciteLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 2, 160, 24)];
        self.reciteLabel.textColor = [UIColor colorWithHue:220.0 / 360.0 saturation:0.2 brightness:0.5 alpha:1];
        self.reciteLabel.backgroundColor = [UIColor clearColor];
        self.reciteLabel.textAlignment = UITextAlignmentRight;
        self.reciteLabel.font = [UIFont boldSystemFontOfSize:14];
        self.reciteLabel.shadowOffset = CGSizeMake(0, 1);
        self.reciteLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.4];

        self.notRememberWellLabel = [[UILabel alloc] initWithFrame:CGRectMake(101, 20, 160, 24)];
        self.notRememberWellLabel.backgroundColor = [UIColor clearColor];
        self.notRememberWellLabel.textAlignment = UITextAlignmentRight;
        self.notRememberWellLabel.font = [UIFont boldSystemFontOfSize:14];
        self.notRememberWellLabel.textColor = [UIColor colorWithHue:0 saturation:0.2 brightness:0.6 alpha:1];
        self.notRememberWellLabel.shadowOffset = CGSizeMake(0, 1);
        self.notRememberWellLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.4];

        UIImage *separator = [VSUtils fetchImg:@"SeparatorLine"];
        self.backgroundImage = [[UIImageView alloc] initWithImage:separator];
        self.backgroundImage.frame = CGRectMake(40, 43, 240, 1.5);
        [self.contentView addSubview:self.backgroundImage];
        
        self.detailImage = [[UIImageView alloc] initWithImage:[VSUtils fetchImg:@"CellAccessory"]];
        CGRect frame = self.detailImage.frame;
        frame.origin.x = 270;
        frame.origin.y = 14;
        self.detailImage.frame = frame;
        
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.reciteLabel];
        [self.contentView addSubview:self.notRememberWellLabel];
        [self.contentView addSubview:self.detailImage];
        
        self.viewSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIImage *selectedImage = [VSUtils fetchImg:@"MenuButtonHighLighted"];
        UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:selectedImage];
        selectedImageView.frame = CGRectMake(40, 0, 240, 42);
        [self.viewSelected addSubview:selectedImageView];
        self.selectedBackgroundView = self.viewSelected;
    }
    return self;
}

- (void)initWithList:(VSListRecord *)theList andRow:(int)row
{
    self.list = theList;
    self.dateLabel.text = self.list.name;
    self.reciteLabel.text = [NSString stringWithFormat:@"背诵%d个单词", [self.list.listVocabularies count]];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:1.0 - [self.list notWellRate]]];
    self.notRememberWellLabel.text = [NSString stringWithFormat:@"%@靠谱", formattedNumberString];
}

- (void)initWithLabel:(NSString *)title
{
    self.dateLabel.text = title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
