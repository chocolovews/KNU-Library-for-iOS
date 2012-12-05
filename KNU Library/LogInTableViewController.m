//
//  LogInTableViewController.m
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 5. 16..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "LogInTableViewController.h"
#import "MyBookInfo.h"
#import "MyBookInfoParser.h"
#import "MyBookRenew.h"

@interface LogInTableViewController ()

@end

@implementation LogInTableViewController

@synthesize receivedData;
@synthesize idtext;
@synthesize pwtext;
@synthesize cookie;
@synthesize myBookInfoConnection;
@synthesize myBooksInfoList;
@synthesize spinner;
@synthesize logInButton;
@synthesize isAutoLogInOn;
@synthesize selectedMyBookInfo;
@synthesize pushedBookSearchDetailController;
//@synthesize myBookRenewConnection;
//@synthesize response;

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
    
    self.receivedData  = [NSMutableData data];
    self.myBooksInfoList = [NSMutableArray array];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.spinner setHidesWhenStopped:YES];
    //        [spinner setColor:[UIColor blackColor]];
    UIBarButtonItem * spinnerBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    [[self navigationItem] setLeftBarButtonItem:spinnerBarItem];
    [self.spinner stopAnimating];

    // 자동 로그인 체크 
    if ([self checkAutoLogin]) {
        [self doAutoLogin];
    }

}

- (void)viewDidUnload
{
    [self setLogInButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.myBooksInfoList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return LOGIN_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"loginInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    MyBookInfo *myBookInfo = [myBooksInfoList objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    
    // 윗줄
    UILabel *bookName = (UILabel *)[cell viewWithTag:101];
    bookName.text = [NSString stringWithFormat:@"%@", myBookInfo.bookNameInfo];
    
    UILabel *bookNum = (UILabel *)[cell viewWithTag:103];
    bookNum.text = [NSString stringWithFormat:@"%@", myBookInfo.bookNumInfo];
    
    UILabel *bookPeriod = (UILabel *)[cell viewWithTag:104];
    bookPeriod.text = [NSString stringWithFormat:@"%@", myBookInfo.bookPeriodInfo];
    
    UILabel *bookAddInfo = (UILabel *)[cell viewWithTag:105];
    if ([myBookInfo.bookAddInformation isEqualToString:@"2"]) {
        bookAddInfo.text = [NSString stringWithFormat:@"연장 %@회, 연장 불가", myBookInfo.bookAddInformation];
    }else{
        bookAddInfo.text = [NSString stringWithFormat:@"연장 %@회", myBookInfo.bookAddInformation];
    }

    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedMyBookInfo = [self.myBooksInfoList objectAtIndex:[indexPath row]];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"연장하기", @"상세정보", nil];

	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark - handlers

//- (void)logInWithIDPasswordArray:(NSArray *)IDPasswordArray {
//    NSString *ID = [IDPasswordArray objectAtIndex:0];
//    NSString *password = [IDPasswordArray objectAtIndex:1];
//    [self logInWithID:ID withPassword:password];
//}

- (void)logInWithID:(NSString *)ID withPassword:(NSString *)password {
    
    self.title = @"로그인 중...";
    // ConnectToServer
    idtext = ID;
    pwtext = password;
    
    //NSLog(@"%@, %@", idtext, pwtext);
    
    // ConnectToServer
    NSString *url = @"http://155.230.44.26/identity/Login.ax?";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]                                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0]; 
    
    NSString *post = [NSString stringWithFormat:@"LOGIN_MODE=%@&url=%@&userID=%@&password=%@&openID=", @"LOGIN",@"%2Fmylibrary%2FCirculation.ax",idtext, pwtext];
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"]; // POST로 선언하고
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];//데이터사이즈정의
	[request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData]; 
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    if (connection) { 
        //NSLog(@"LogIn_connected");
    }
    else{
        //NSLog(@"LogIn_connection Failed");
    }
}

- (void)getMyBookInfoFromServer {
    
    MyBookInfoParser *myBookInfoParser = [[MyBookInfoParser alloc] init];
    myBookInfoParser.delegate = self;
    
    // 추가 - 우성 / 5월 13일 : 로그인 url 에 더해 내 도서 url을 추가.
    NSString *myBookInfoURL = @"http://155.230.44.26/mylibrary/Circulation.ax";
    NSMutableURLRequest *myBookInforequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:myBookInfoURL]                                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0]; 
    //NSLog(@"cookie: %@", self.cookie);
    [myBookInforequest addValue:self.cookie forHTTPHeaderField:@"Cookie"];
    self.myBookInfoConnection = [[NSURLConnection alloc] initWithRequest:myBookInforequest delegate:myBookInfoParser];
    
    if (self.myBookInfoConnection) { 
        //NSLog(@"LogIn_MyBookInfo_connected");
    }else{
        //NSLog(@"LogIn_MyBookInfo_Failed");
    }
}

#pragma mark - IBAction Mehtods

- (IBAction)logInButtonClicked:(id)sender {

    if ([self.logInButton.title isEqualToString:@"로그인"]) {
        
        if ([self checkAutoLogin]) {
            [self doAutoLogin];
        }else{
            // 로그인 할 때마다 새로운 데이터를 받아야함.
            self.receivedData = [NSMutableData data];
            
            UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:@"경북대학교 도서관" message:@"로그인" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"로그인", nil];
            
            [loginAlertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            
            UITextField *idTextField = [loginAlertView textFieldAtIndex:0];
            UITextField *passwordTextField = [loginAlertView textFieldAtIndex:1];
            
            idTextField.placeholder = @"도서관 아이디";
            passwordTextField.placeholder = @"비밀번호";
            
            // 로그인 부분이 완료되면 삭제해야함
//            idTextField.text = @"20070373002";
//            passwordTextField.text = @"1727214";
            
            [loginAlertView show];

        }
    }else if([self.logInButton.title isEqualToString:@"로그아웃"]){
        self.myBooksInfoList = nil;
        [self.tableView reloadData];
        self.logInButton.title = @"로그인";
    }
}



#pragma mark - URLConnection Methods

- (void)handleDataWithString:(NSString *)htmlString {
    
}

#pragma mark - URL Connection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)Response {
    //[receivedData setLength:0]; 
    
    //NSLog(@"LogIn_didReceiveResponese");
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)Response; 
    //NSInteger code = [HTTPResponse statusCode];
    //NSLog(@"status code: %d", code);
    //NSLog(@"%@", [[HTTPResponse URL] description]);
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    
    for (NSString *key in fields) {
        //NSLog(@"%@: %@", key, [fields valueForKey:key]);
    }
    
    NSString *string = [fields valueForKey:@"Set-Cookie"];
    
    if (string == nil) {
        //NSLog(@"Coockie String is nil");
    }else{
        self.cookie = string;
        //NSLog(@"Cookie in Response : %@", self.cookie);
    }
    
    if ([[[HTTPResponse URL] description] isEqualToString:@"http://155.230.44.26/identity/Login.ax?"]) {
        [self getMyBookInfoFromServer];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)postData {
    //NSLog(@"LogIn_didReceiveData");
    [receivedData appendData:postData];	//서버에서 보낸 값을 쌓는다.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    //NSLog(@"LogIn_connectionDidFinishLoading");
    //NSLog(@"%@", [conn description]);
    
    // 책 정보가 있는 HTML만 받아들임 
//    NSString *htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", htmlString);
    /*
    NSLog(@"conn: %@", [conn description]);
    NSLog(@"self.myBookInfoConnection: %@", [self.myBookInfoConnection description]);
    
    if ([conn isEqual:self.myBookInfoConnection]) {
        htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//        NSLog(@"htmlString Finished");
        NSLog(@"%@", htmlString);
        //[self handleDataWithString:htmlString];
        [self.tableView reloadData];
        if (self.cookie != nil) {
            //NSLog(@"%@", self.htmlString);
        }   
    }      
     */
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"경북대 도서관" message:@"네트워크를 사용할 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    
    [alertView show];
    
    self.title = @"나의 도서";
    [self.spinner stopAnimating];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 로그인 버튼을 클릭할 시
    if (buttonIndex == 1) {
        UITextField *idTextField = [alertView textFieldAtIndex:0];
        UITextField *passwordTextField = [alertView textFieldAtIndex:1];
        
        self.idtext = idTextField.text;
        self.pwtext = passwordTextField.text;
        
        [self.spinner startAnimating];
        [self logInWithID:self.idtext withPassword:self.pwtext];
    }
}

#pragma mark - MyBookInfoParserDelegate methods 

- (void)MyBookInfoParserDidFinishParsing:(MyBookInfoParser *)myBookInfoParser_ {
    // myBookInfoParser가 파싱을 다 끝내고 BookInfoList를 가지고 있을 때 가지고 오기
//    NSLog(@"MyBookInfoParserDidFinishParsing");
    self.myBooksInfoList = myBookInfoParser_.myBooksInfoList;
    
    [NSTimer scheduledTimerWithTimeInterval:LOGIN_ANIMATION_DELAY_TIME target:self selector:@selector(applyChange) userInfo:nil repeats:NO];    
}

- (void)applyChange {
    [self.tableView reloadData];
    [self.spinner stopAnimating];
    self.logInButton.title = @"로그아웃";
    self.title = @"나의 도서";
    
    if (self.isAutoLogInOn) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:self.idtext forKey:@"StudentID"];
        [userDefaults setValue:self.pwtext forKey:@"Password"];
    }
}

#pragma mark - MyBookDetailParserDelegate methods 

- (void)MyBookDetailParserDidFinishParsing:(SearchedBookInfo *)myBookDetailInfo {
    
    // 선택한 도서의 자세한 정보 넘기기 - 파싱이 완료되면 아래를 주석 처리후 여기 주석을 풀면 됨.
    
    self.pushedBookSearchDetailController.bookCNum = myBookDetailInfo.bookCNum;
    self.pushedBookSearchDetailController.bookName = myBookDetailInfo.bookName;
    self.pushedBookSearchDetailController.bookAuthor = myBookDetailInfo.bookAuthor;
    self.pushedBookSearchDetailController.bookPublisher = myBookDetailInfo.bookPublisher;
    self.pushedBookSearchDetailController.bookPubYear = myBookDetailInfo.bookPubYear;
    self.pushedBookSearchDetailController.bookCodeForBookDetail = myBookDetailInfo.bookCode;
     
     [self.pushedBookSearchDetailController.tableView reloadData];
     
}

#pragma mark - Auto Login

- (BOOL)checkAutoLogin {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.isAutoLogInOn = [(NSNumber *)[userDefaults valueForKey:@"isAutoLogInOn"] boolValue];
    
    if (self.isAutoLogInOn) {
        return YES;
    }else{
        return NO;
    }
}

- (void)doAutoLogin {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *studentID = [userDefaults valueForKey:@"StudentID"];
    NSString *password = [userDefaults valueForKey:@"Password"];
    
    [self.spinner startAnimating];
    [self logInWithID:studentID withPassword:password];
}

#pragma mark - UIActionSheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self renewMyBookWithBookInfo:self.selectedMyBookInfo];
            
            /*
             //            NSLog(@"연장하기");
             //NSLog(@"%@",selectedMyBookInfo.bookID);
             MyBookRenew *myBookRenew = [[MyBookRenew alloc] init];
             //myBookRenew.delegate = self;
             
             NSString *renewurl = [NSString stringWithFormat:@"http://155.230.44.26/​mylibrary/Renew.json?​branchCode=%@&idid=%@&​chargeKey=%@",@"01",selectedMyBookInfo.bookID,@"0"];
             NSMutableURLRequest *myBookRenewrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:renewurl]                                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0]; 
             
             NSURLConnection *myBookRenewConnection = [[NSURLConnection alloc] initWithRequest:myBookRenewrequest delegate:myBookRenew];
             
             if (myBookRenewConnection) { 
             NSLog(@"연장완료");
             }
             else{
             NSLog(@"연장실패");
             }
             */
            break;
        } 
        case 1:
        {
            //            NSLog(@"상세정보");
            [self seeBookDetailInfo];
            break;
        }
        case 2:
//            NSLog(@"취소");
            break;
    }
}

- (void)seeBookDetailInfo {
    
    // 우성 추가
    
    // http://155.230.44.26/search/DetailView.ax?sid=8&cid=3046629 여기로 접근하면 도서 상세정보가 있는 페이지가 나오는데,
    
    // MyBookDetailParser에 그 일을 시킨다. 이 클래스는 파싱이 완료되면 이 컨트롤러로 다시 호출된다(델리게이트)
    
    MyBookDetailParser *myBookDetailParser = [[MyBookDetailParser alloc] init];
    myBookDetailParser.delegate = self;
    
    NSString *myBookDetailURL = [NSString stringWithFormat:@"http://155.230.44.26/search/DetailView.ax?sid=8&cid=%@", self.selectedMyBookInfo.bookID];
    
    //            NSLog(@"%@", myBookDetailURL);
    
    NSMutableURLRequest *myBookDetailrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:myBookDetailURL]                                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0]; 
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:myBookDetailrequest delegate:myBookDetailParser];
    
    if (connection) { 
        //NSLog(@"LogIn_MyBookInfo_connected");
    }else{
        //NSLog(@"LogIn_MyBookInfo_Failed");
    }
    
    // BookSearchDetailController 생성
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.pushedBookSearchDetailController = [storyBoard instantiateViewControllerWithIdentifier:@"bookSearchDetailController"];
    
    // 파싱이 완료되면 만들어진 컨트롤러에 관련 정보를 마저 넣도록 한다.
    self.pushedBookSearchDetailController.bookCNum = self.selectedMyBookInfo.bookID;
    self.pushedBookSearchDetailController.bookName = self.selectedMyBookInfo.bookNameInfo;
    self.pushedBookSearchDetailController.bookAuthor = @"----";
    self.pushedBookSearchDetailController.bookPublisher = @"----";
    self.pushedBookSearchDetailController.bookPubYear = @"----";
    //    NSLog(@"%@", [ [searchResultBookList objectAtIndex:[indexPath row]] bookName]);
    
    // 도서 정보 보여주기(BookSearchDetailController으로 넘어가기)
    [self.navigationController pushViewController:self.pushedBookSearchDetailController animated:YES];
}

- (void)renewMyBookWithBookInfo:(MyBookInfo *)myBookInfo {
    
    if ([self.selectedMyBookInfo.bookIDForReNew isEqualToString:@"연장회수 초과"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"경북대학교 도서관" message:@"연장회수 초과입니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }else{
        MyBookRenewer *myBookRenewer = [[MyBookRenewer alloc] init];
        myBookRenewer.delegate = self;
        myBookRenewer.cookie = self.cookie;
        
        // ConnectToServer
        NSString *url = @"http://155.230.44.26/mylibrary/Renew.json";
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]                                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0]; 
        
        NSString *post = [NSString stringWithFormat:@"branchCode=01&idid=%@&chargeKey=0", self.selectedMyBookInfo.bookIDForReNew];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"]; // POST로 선언하고
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];//데이터사이즈정의
        [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData]; 
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:myBookRenewer];
        
        if (connection) { 
            //NSLog(@"LogIn_connected");
        }
        else{
            //NSLog(@"LogIn_connection Failed");
        }
    }    
}

#pragma mark - MyBookRenewer Delegate Method

- (void)MyBookRenwerDidFinishRenew:(MyBookRenewer *)myBookRenewer {
    // 연장처리가 되었다면, 내 책정보 다시 읽어오기
    [self getMyBookInfoFromServer];
}

@end