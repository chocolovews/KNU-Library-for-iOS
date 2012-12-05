//
//  FirstViewController.m
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 3. 31..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [searchBar sizeToFit];
    [searchBar setKeyboardType:UIKeyboardTypeDefault];
    self.navigationItem.titleView = self.searchBar;
    // searchBar 색 기본과 같이 맞추고 싶다.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
