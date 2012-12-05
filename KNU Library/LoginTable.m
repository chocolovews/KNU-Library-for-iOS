//
//  LoginTable.m
//  KNU Library
//
//  Created by apple04 on 12. 5. 16..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "LoginTable.h"
#import "bookInfo.h"


@implementation LoginTable

@synthesize loginbar;
@synthesize receivedData;
@synthesize cookie;
@synthesize htmlString;
@synthesize loginList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    receivedData  = [NSMutableData data];
    loginList = [NSMutableArray array];
    
    NSString *url = @"http://155.230.44.26/identity/Login.ax?";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]                                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0]; 
    NSString *post = [NSString stringWithFormat:@"LOGIN_MODE=%@&url=%@&userID=%@&password=%@&openID=", @"LOGIN",@"%2Fmylibrary%2FCirculation.ax",@"20070373002", @"1727214"];
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
        NSLog(@"LogIn_connected");
    }
    else{
        NSLog(@"LogIn_connection Failed");
    }
}

- (IBAction)loginbarClicked:(id)sender {
    NSString *myBookInfoURL = @"http://155.230.44.26/mylibrary/Circulation.ax";
    NSMutableURLRequest *myBookInforequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:myBookInfoURL]                                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0]; 
    NSLog(@"cookie: %@", self.cookie);
    [myBookInforequest addValue:self.cookie forHTTPHeaderField:@"Cookie"];
    NSURLConnection *myBookInfoConnection = [[NSURLConnection alloc] initWithRequest:myBookInforequest delegate:self];
    
    if (myBookInfoConnection) { 
        NSLog(@"myBook_connected");
    }
    else{
        NSLog(@"myBook_connection Failed");
    }
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
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
    return [self.loginList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"loginInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    bookInfo *bookInfo = [loginList objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    
    // 윗줄
    UILabel *bookName = (UILabel *)[cell viewWithTag:101];
    bookName.text = [NSString stringWithFormat:@"%@", bookInfo.bookNameInfo];
    
    UILabel *Info = (UILabel *)[cell viewWithTag:102];
    Info.text = [NSString stringWithFormat:@"%@", bookInfo.bookBelongInfo];
    
    UILabel *bookNum = (UILabel *)[cell viewWithTag:103];
    bookNum.text = [NSString stringWithFormat:@"%@", bookInfo.bookNumInfo];
    
    UILabel *bookPeriod = (UILabel *)[cell viewWithTag:104];
    bookPeriod.text = [NSString stringWithFormat:@"%@", bookInfo.bookPeriodInfo];
    
    UILabel *bookAddInfo = (UILabel *)[cell viewWithTag:105];
    bookAddInfo.text = [NSString stringWithFormat:@"%@", bookInfo.bookAddInformation];
    
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

#pragma mark - URLConnection Methods

- (void)handleDataWithString:(NSString *)htmlString {
    //    NSLog(@"%@", htmlString);
    
    
    //NSLog(@"%@", htmlString);
    NSArray *seatInfoArray1 = [htmlString componentsSeparatedByString:@"<a href=\"JavaScript:ExcelSave();\"><img src=\"./images/ExcelSave.gif\" border=0></a>&nbsp;"];
    
    //    NSLog(@"%d", [seatInfoArray1 count]);
    //NSLog(@"%@", [seatInfoArray objectAtIndex:0]);
    
    NSArray *seatInfoArray2 = [[seatInfoArray1 objectAtIndex:0] componentsSeparatedByString:@"<TD WIDTH=\"350\"><FONT SIZE=-1>이용율(%)</FONT></TD>"];
    
    //    NSLog(@"%d", [seatInfoArray2 count]); 
    //    NSLog(@"%@", [seatInfoArray2 objectAtIndex:1]);
    
    // 각 층별로 나누어진 Array
    NSArray *seatInfoSeperatedArray = [[seatInfoArray2 objectAtIndex:1] componentsSeparatedByString:@"</FONT></TD></TR><TR ALIGN=\"CENTER\" style=\"background-color:"];
    
    
    // SeatInfo 리스트 생성
    for(int i=0; i<[seatInfoSeperatedArray count]; i++) {
        
        // SeatInfo 인스턴스 생성
        SeatInfo *seatInfo = [[SeatInfo alloc] init];
        
        // 파싱 시작
        NSString *separeteTokenString = [NSString stringWithString:@"room_no="];
        NSString *indexString = [NSString stringWithFormat:@"%d", i+1];
        separeteTokenString = [separeteTokenString stringByAppendingString:indexString];
        separeteTokenString = [separeteTokenString stringByAppendingString:@"\">&nbsp;"];
        
        //NSLog(@"%@", separeteTokenString);
        
        // RoomName
        NSArray *parsedArray1 = [[seatInfoSeperatedArray objectAtIndex:i] componentsSeparatedByString:separeteTokenString];
        //NSLog(@"%@", [parsedArray1 objectAtIndex:1]);
        //NSLog(@"%d", [parsedArray1 count]);
        
        NSArray *parsedArray2 = [[parsedArray1 objectAtIndex:1] componentsSeparatedByString:@"</A></FONT></TD><TD ALIGN=\"CENTER\"><FONT SIZE=-1>&nbsp;"];
        //NSLog(@"%@", [parsedArray2 objectAtIndex:0]);
        
        seatInfo.roomName = [parsedArray2 objectAtIndex:0];
        
        //NSLog(@"%@", [parsedArray2 objectAtIndex:1]);
        
        //</FONT></TD><TD ALIGN="CENTER"><FONT SIZE=-1>&nbsp;
        
        // TotalSeat
        NSArray *parsedArray3 = [[parsedArray2 objectAtIndex:1] componentsSeparatedByString:@"</FONT></TD><TD ALIGN=\"CENTER\"><FONT SIZE=-1>&nbsp;"];
        //NSLog(@"%@", [parsedArray3 objectAtIndex:0]);
        seatInfo.totalNumbersOfSeats = [[parsedArray3 objectAtIndex:0] intValue];
        
        // CurrentUsedSeat
        //</FONT></TD><TD ALIGN="CENTER"><FONT SIZE=-1>&nbsp;
        NSArray *parsedArray4 = [[parsedArray3 objectAtIndex:1] componentsSeparatedByString:@"</FONT></TD><TD ALIGN=\"CENTER\"><FONT COLOR=\"blue\" SIZE=-1>&nbsp;"];
        //    NSLog(@"%@", [parsedArray4 objectAtIndex:0]);
        seatInfo.currentUsedNumbersOfSeats = [[parsedArray4 objectAtIndex:0] intValue];
        
        // CurrentAvailableSeat
        //</FONT></TD><TD ALIGN="LEFT">
        NSArray *parsedArray5 = [[parsedArray4 objectAtIndex:1] componentsSeparatedByString:@"</FONT></TD><TD ALIGN=\"LEFT\">"];
        //NSLog(@"%@", [parsedArray5 objectAtIndex:0]);
        seatInfo.currentAvailableNumbersOfSeats = [[parsedArray5 objectAtIndex:0] intValue];
        
        // UsagePercent
        //</FONT></TD><TD ALIGN="LEFT">&nbsp;&nbsp;&nbsp;<img src="./images/hbar_0.gif" width=174.25 height=13 border=0 alt="
        NSArray *parsedArray6 = [[parsedArray5 objectAtIndex:1] componentsSeparatedByString:@"border=0 alt=\""];
        NSArray *parsedArray7 = [[parsedArray6 objectAtIndex:1] componentsSeparatedByString:@"\">"];
        //    NSLog(@"%@", [parsedArray7 objectAtIndex:0]);
        seatInfo.usagePercentage = [parsedArray7 objectAtIndex:0];
        
        [seatInfoList addObject:seatInfo];
        
        // seatInfo Container 테스트
        /*
         NSLog(@"%@", seatInfo.roomName);
         NSLog(@"%d", seatInfo.totalNumbersOfSeats);
         NSLog(@"%d", seatInfo.currentUsedNumbersOfSeats);
         NSLog(@"%d", seatInfo.currentAvailableNumbersOfSeats);
         NSLog(@"%@", seatInfo.usagePercentage);
         */
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)Response {
    //[receivedData setLength:0]; 
    //self->response = aResponse;
    NSLog(@"didReceiveResponese");
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)Response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSString *string = [fields valueForKey:@"Set-Cookie"];
    if (string == nil) {
        NSLog(@"String is nil");
    }else{
        self.cookie = string;
        NSLog(@"Cookie in Response : %@", self.cookie);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)postData {
    //NSLog(@"didReceiveData");
    [receivedData appendData:postData];	//서버에서 보낸 값을 쌓는다.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    //NSLog(@"connectionDidFinishLoading");
    self.htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", self.htmlString);
    
    [self handleDataWithString:htmlString];
    [self.tableView reloadData];
}

@end
