//
//  VSRepoViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSRepoViewController.h"

@interface VSRepoViewController ()

@end

@implementation VSRepoViewController
@synthesize repo;
@synthesize repoButton;
@synthesize infoLabel;
@synthesize repoNameLabel;
@synthesize indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGPoint center = self.view.center;
    
    UIImage *repoImage = nil;
    if (self.repo) {
        repoImage = [repo repoImage];
    }
    else {
        repoImage = [VSUtils fetchImg:@"BookPromo"];
    }
    self.repoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, repoImage.size.width, repoImage.size.height)];
    center.y = 155;
    [self.repoButton setBackgroundImage:repoImage forState:UIControlStateNormal];
    self.repoButton.center = center;
    [self.repoButton addTarget:self action:@selector(clickRepos) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.repoButton];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.frame = CGRectMake(0, 0, 24, 24);
    CGPoint indicatorCenter = self.view.center;
    indicatorCenter.y = 145;
    indicatorCenter.x += 5;
    self.indicator.center = indicatorCenter;
    [self.view addSubview:self.indicator];
    [self.view bringSubviewToFront:self.indicator];
    
    self.repoNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(128, 102, 80, 80)];
    self.repoNameLabel.numberOfLines = 0;
    self.repoNameLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.repoNameLabel.font = [UIFont boldSystemFontOfSize:20];
    if (self.repo) {
        self.repoNameLabel.text = [self.repo displayName];
        self.repoNameLabel.textColor = [self.repo repoNameColor];
    }
    self.repoNameLabel.backgroundColor = [UIColor clearColor];
    self.repoNameLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.repoNameLabel.shadowOffset = CGSizeMake(0, -1);
    self.repoNameLabel.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview:self.repoNameLabel];
    [self.view bringSubviewToFront:self.repoNameLabel];

    if (self.repo) {
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
        self.infoLabel.text = [NSString stringWithFormat:@"共%@个单词\n%d个单词列表", self.repo.wordsTotal, [self.repo.lists count]];
    }
    else {
        //For trial version
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 155, 80)];
        self.infoLabel.text = @"攻克GRE,\n早日踏上北美留学之路!\n马上去 App Store\n下载私塾词汇完整版!";
    }

    self.infoLabel.font = [UIFont boldSystemFontOfSize:14];
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.infoLabel.textColor = [UIColor colorWithHue:48.0/360.0 saturation:0.4 brightness:1 alpha:0.9];
    self.infoLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.infoLabel.textAlignment = UITextAlignmentCenter;
    self.infoLabel.shadowOffset = CGSizeMake(0, 1.5);
    self.infoLabel.center = CGPointMake(self.view.center.x, 280);
    [self.view addSubview:self.infoLabel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.repoButton = nil;
    self.infoLabel = nil;
    self.repoNameLabel = nil;
    self.indicator = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)clickRepos
{
    if (self.repo) {
        [self.indicator startAnimating];
        [self performSelector:@selector(enterRepos) withObject:self afterDelay:0.2];
    }
    else {
        [VSUtils openSeries];
    }
}

- (void)enterRepos
{
    VSRepoListViewController *controller = [[VSRepoListViewController alloc] initWithNibName:@"VSRepoListViewController" bundle:nil];
    [controller initWithRepo:repo];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    [navigationController pushViewController:controller animated:YES];
    [self.indicator stopAnimating];
}

- (void)initWithCurrentRepo:(VSRepository *)current
{
    self.repo = current;
}

@end
