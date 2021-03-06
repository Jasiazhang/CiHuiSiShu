//
//  VSMainViewController.m
//  VocabularySishu
//
//  Created by xiao xiao on 8/9/12.
//  Copyright (c) 2012 douban. All rights reserved.
//

#import "VSMainViewController.h"
#import "VSConfigurationViewController.h"
#import "VSClipView.h"
#import "VSUIUtils.h"

@interface VSMainViewController ()

@end

@implementation VSMainViewController
@synthesize scrollView, pageControl, allRepos, pageIndex, pageControlUsed, controllers;
@synthesize firstEnter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择词库";

    self.firstEnter = YES;
    self.controllers = [[NSMutableArray alloc] init];
    self.view.clipsToBounds = YES;

    [self.navigationItem setLeftBarButtonItem:[VSUIUtils makeBackButton:self selector:@selector(goBack)]];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[VSUtils fetchImgByScreen:@"ListBG"]];
    [backgroundImageView setFrame:self.view.frame];
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];

    self.allRepos = [VSRepository allRepos];
    int count = [self.allRepos count];
    #ifdef TRIAL
        count++;
    #endif

    scrollView.frame = CGRectMake(0, 0, scrollView.frame.size.width, [[UIScreen mainScreen] bounds].size.height - 89);
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(205 * count, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.clipsToBounds = NO;
    
    VSClipView *clipView = [[VSClipView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width, 0, 320 - self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    clipView.scrollView = scrollView;
    [self.view addSubview:clipView];

    int selected = -1;
    VSRepository *repo = [VSContext getContext].currentRepository;

    CGFloat bookYOffset = 0;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height > 480.0f) {
        bookYOffset = 78;
    }
    else {
        bookYOffset = 108;
    }
    
    for (int i = 0; i < [allRepos count]; i++) {
        CGRect frame = CGRectMake(i * 205, bookYOffset, 205, [[UIScreen mainScreen] bounds].size.height - 64);
        VSRepoViewController *controller = [[VSRepoViewController alloc] initWithNibName:nil bundle:nil];
        [controllers addObject:controller];
        VSRepository *currentRepo = [allRepos objectAtIndex:i];
        if ([currentRepo.wordsTotal intValue] == 0) {
            [VSDataUtil fixData];
        }
        [controller initWithCurrentRepo:currentRepo];
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
        if ([repo isEqual:currentRepo]) {
            selected = i;
        }
    }
    
    #ifdef TRIAL
        CGRect moreFrame = CGRectMake([allRepos count] * 205, bookYOffset, 205, [[UIScreen mainScreen] bounds].size.height - 64);
        VSRepoViewController *controller = [[VSRepoViewController alloc] initWithNibName:nil bundle:nil];
        [controllers addObject:controller];
        VSRepository *currentRepo = nil;
        [controller initWithCurrentRepo:currentRepo];
        controller.view.frame = moreFrame;
        [self.scrollView addSubview:controller.view];
    #endif

    CGRect pageControlFrame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 89, 320, 20);
    pageControl.frame = pageControlFrame;
    pageControl.numberOfPages = count;
    pageControl.currentPage = 0;
    
    if (selected != -1) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * selected;
        frame.origin.y = 0;
        [scrollView scrollRectToVisible:frame animated:NO];
        pageControl.currentPage = selected;
    }

}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView = nil;
    self.pageControl = nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (pageControlUsed) {
        return;
    }

    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}


@end
