//
//  SettingControllerViewController.m
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 5. 21..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "SettingController.h"

@interface SettingController ()

@end

@implementation SettingController

@synthesize autoLogInSwitch;
@synthesize IDLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.autoLogInSwitch addTarget:self action:@selector(switchDidChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    // 자동 로그인이 켜져 있는지를 검사
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isAutoLogInOn = [(NSNumber *)[userDefaults valueForKey:@"isAutoLogInOn"] boolValue];
    
//    NSLog(@"%d", isAutoLogInOn);
    
    if (isAutoLogInOn) {
        self.autoLogInSwitch.on = YES;
        self.IDLabel.text = [userDefaults valueForKey:@"StudentID"];
    }else{
        self.autoLogInSwitch.on = NO;
        self.IDLabel.text = @"정보 없음";
    }

}

- (void)viewDidUnload
{
    [self setIDLabel:nil];
    [self setIDLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - handle switch
- (void)switchDidChanged:(id)sender {
//    NSLog(@"%d", self.autoLogInSwitch.on);
    
    if (self.autoLogInSwitch.on) {
        UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:@"경북대학교 도서관" message:@"자동 로그인 설정" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"저장", nil];
        
        [loginAlertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        
        UITextField *idTextField = [loginAlertView textFieldAtIndex:0];
        UITextField *passwordTextField = [loginAlertView textFieldAtIndex:1];
        
        idTextField.placeholder = @"도서관 아이디";
        passwordTextField.placeholder = @"비밀번호";
        
        // 로그인 부분이 완료되면 삭제해야함
        //    idTextField.text = @"20070373002";
        //    passwordTextField.text = @"1727214";
        
        [loginAlertView show];
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSLog(@"%d", self.autoLogInSwitch.on);
        [userDefaults setValue:[NSNumber numberWithBool:self.autoLogInSwitch.on] forKey:@"isAutoLogInOn"];
        self.IDLabel.text = @"정보 없음";
    }
}

#pragma UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 로그인 버튼을 클릭할 시
    if (buttonIndex == 1) {
        UITextField *idTextField = [alertView textFieldAtIndex:0];
        UITextField *passwordTextField = [alertView textFieldAtIndex:1];
        
        NSString *idString = idTextField.text;
        NSString *passwordString = passwordTextField.text;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:idString forKey:@"StudentID"];
        [userDefaults setValue:passwordString forKey:@"Password"];
        
        self.autoLogInSwitch.on = YES;
        self.IDLabel.text = idString;
        
    // 취소 시    
    }else{
        self.autoLogInSwitch.on = NO;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSNumber numberWithBool:self.autoLogInSwitch.on] forKey:@"isAutoLogInOn"];
}

@end
