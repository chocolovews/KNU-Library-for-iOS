//
//  Created by KIM WOOSUNG on 12. 5. 16..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBookInfoParser.h"
#import "MyBookInfo.h"
#import "MyBookDetailParser.h"
#import "BookSearchDetailController.h"
#import "MyBookRenewer.h"

#define LOGIN_ANIMATION_DELAY_TIME 0.4
#define LOGIN_CELL_HEIGHT 93

@interface LogInTableViewController : UITableViewController <UIAlertViewDelegate, NSURLConnectionDelegate, MyBookInfoParserDelegate, UIActionSheetDelegate, MyBookDetailParserDelegate, MyBookRenewerDelegate>
{
    UIButton *loginbutton;
}
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, retain) NSString* idtext;
@property (nonatomic, retain) NSString* pwtext;
@property (nonatomic, strong) NSString *cookie;
//@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) NSURLConnection *myBookInfoConnection;
@property (strong, nonatomic) NSMutableArray *myBooksInfoList;
//@property (strong, nonatomic) NSURLResponse *response;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logInButton;
@property (nonatomic) BOOL isAutoLogInOn;
@property (strong, nonatomic) MyBookInfo *selectedMyBookInfo;
@property (strong, nonatomic) BookSearchDetailController *pushedBookSearchDetailController;
//@property (nonatomic, strong) NSURLConnection *myBookRenewConnection;

- (IBAction)logInButtonClicked:(id)sender;
- (void)handleDataWithString:(NSString *)htmlString;
- (BOOL)checkAutoLogin;
- (void)doAutoLogin;
@end