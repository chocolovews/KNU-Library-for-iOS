//
//  SeatInforTableViewController.m
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 5. 10..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "SeatInforTableViewController.h"
#import "SeatInfo.h"
#import "SeatInfoDetailViewController.h"

@interface SeatInforTableViewController ()

@end

@implementation SeatInforTableViewController

@synthesize isReceivedData;
@synthesize receivedData;
@synthesize seatInfoList;
@synthesize spinner;
@synthesize isAnimationDone;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initConnection {
    
    self.receivedData = nil;
    self.receivedData = [NSMutableData data];
    self.seatInfoList = nil;
    self.seatInfoList = [NSMutableArray array];
    
    [self.tableView reloadData];
    
//    [NSThread sleepForTimeInterval:0.5];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://libseat.knu.ac.kr/domian5.asp"]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (theConnection) {
        NSLog(@"connected");
    }else{
        NSLog(@"Connection failed");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // spinner
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.spinner setHidesWhenStopped:YES];
    //        [spinner setColor:[UIColor blackColor]];
    UIBarButtonItem * spinnerBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    [[self navigationItem] setLeftBarButtonItem:spinnerBarItem];
    [self.spinner startAnimating];
    
    self.title = @"로딩 중...";
    
//    [NSThread sleepForTimeInterval:0.5];
    
    [NSTimer scheduledTimerWithTimeInterval:SEAT_ANIMATION_DELAY_TIME target:self selector:@selector(initConnection) userInfo:nil repeats:NO];
//    [self initConnection];
}

- (void)viewDidUnload
{
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
    return [self.seatInfoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"seatInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    SeatInfo *seatInfo = [seatInfoList objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:CellIdentifier];
    }
    
    // 윗줄
    UILabel *label1 = (UILabel *)[cell viewWithTag:101];
    label1.text = [NSString stringWithFormat:@"%@(%d좌석 남음) - %@", seatInfo.roomName, seatInfo.currentAvailableNumbersOfSeats, seatInfo.usagePercentage];
    
    
    /*
     NSLog(@"%@", seatInfo.roomName);
     NSLog(@"%d", seatInfo.totalNumbersOfSeats);
     NSLog(@"%d", seatInfo.currentUsedNumbersOfSeats);
     NSLog(@"%d", seatInfo.currentAvailableNumbersOfSeats);
     NSLog(@"%@", seatInfo.usagePercentage);
     */
    
    // 아랫줄 
    UILabel *label2 = (UILabel *)[cell viewWithTag:102];
    label2.text = seatInfo.usagePercentage;
    label2.text = [NSString stringWithFormat:@"총 %d좌석 중 %d좌석 사용", seatInfo.totalNumbersOfSeats, seatInfo.currentUsedNumbersOfSeats];
  
    
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
    // [indexPath row] 의 방정보를 가지고 쿼리할  urlString 을 조립
    
    
    SeatInfoDetailViewController *sitc = [[SeatInfoDetailViewController alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://libseat.knu.ac.kr/roomview5.asp?room_no=%d", [indexPath row] + 1];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.navigationController pushViewController:sitc animated:YES];
    
    [sitc.webView loadRequest:request];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

#pragma mark - URLConnection Methods

- (void)handleDataWithString:(NSString *)htmlString {
    //    NSLog(@"%@", htmlString);
    
    // 전체 HTML String에서 각 열람실 별 String으로 분리하기 
    
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"경북대 도서관" message:@"네트워크를 사용할 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    
    [alertView show];
    
    self.title = @"좌석 현황";
    [self.spinner stopAnimating];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"didReceiveData\n");
    
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {     
    NSLog(@"connectionDidFinishLoading ");  
    
    // EUC-KR - 0x80000940는 EUC-KR에 해당하는 인코딩 코드.
    NSString *htmlString = [[NSString alloc] initWithData:receivedData encoding:0x80000940];
    
    //NSLog(@"%@", htmlString);
    
    [self handleDataWithString:htmlString];
    [self.tableView reloadData];
    [self.spinner stopAnimating];
    self.title = @"좌석 현황";
}  

#pragma mark - IBAction 

- (IBAction)reloadButtonClicked:(id)sender {
    [self.spinner startAnimating];
    
    self.title = @"로딩 중...";
    self.seatInfoList = nil;
    [self.tableView reloadData];
//    [self performSelectorInBackground:@selector(initConnection) withObject:nil];
//    self.isAnimationDone = NO;
//    [self performSelectorInBackground:@selector(wait) withObject:nil];

    [NSTimer scheduledTimerWithTimeInterval:SEAT_ANIMATION_DELAY_TIME target:self selector:@selector(initConnection) userInfo:nil repeats:NO];
//        [self initConnection];
}

- (void)wait {
    [NSThread sleepForTimeInterval:0.5];
    
    isAnimationDone = YES;
}

@end
