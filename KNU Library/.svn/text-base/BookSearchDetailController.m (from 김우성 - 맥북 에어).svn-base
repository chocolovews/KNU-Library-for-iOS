//
//  BookSearchDetailController.m
//  KNU Library
//
//  Created by SEONG HUN KIM on 12. 5. 23..
//  Copyright (c) 2012년 gsfs@naver.com. All rights reserved.
//

#import "BookSearchDetailController.h"
#import "SearchedBookPositionInfo.h"

@implementation BookSearchDetailController

@synthesize bookCNum;
@synthesize bookName;
@synthesize bookAuthor;
@synthesize bookPublisher;
@synthesize bookPubYear;
@synthesize bookCodeForBookDetail;

@synthesize receivedData;
@synthesize bookCodeStatusNPosi;
@synthesize spinner;

- (void)initConnectionForGetPosition {
    // 소장정보 저장을 위한 가변 크기의 배열 선언
    bookCodeStatusNPosi = [NSMutableArray array];
//    NSLog(@"%@", bookCNum);
    // URLConnection 
    self.receivedData = [NSMutableData data];
    
    NSString *urlString = [NSString stringWithFormat:@"http://155.230.44.26/search/ItemDetailSimple.axa?&cid=%@", bookCNum];    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (theConnection) {
//        NSLog(@"GetBookPosition_connected");
    }else{
        NSLog(@"GetBookPosition_Connection failed");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 /*   
    // for testing : 검색 결과에서 정보 넘어왔는지 테스트하기
    NSLog(@"%@", bookName);
    NSLog(@"%@", bookAuthor);
    NSLog(@"%@", bookPubYear);
    NSLog(@"%@", bookPublisher);*/
    
    // spinner
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.spinner setHidesWhenStopped:YES];
    UIBarButtonItem * spinnerBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    [[self navigationItem] setRightBarButtonItem:spinnerBarItem];
    [self.spinner startAnimating];
    
    [self initConnectionForGetPosition];
    
    // 테이블 셀이 선택 가능하게 만듦
    [self.tableView setAllowsSelection:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
}

#pragma mark - table contents
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"도서정보";
    }else{
        return @"소장자료";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else{
        return [bookCodeStatusNPosi count]; // 나중에 소장정보 받아오면 그만큼 추가하기.
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"bookDetailInfoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if( cell == nil ){  
            cell = [ [UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier: CellIdentifier  ];
        } 
        
        UILabel *bookNameForDetailInfo = (UILabel *) [cell viewWithTag:101];
        UILabel *bookAuthorForDetailInfo = (UILabel *) [cell viewWithTag:102];
        UILabel *bookPubYearForDetailInfo = (UILabel *) [cell viewWithTag:103];
        UILabel *bookPublisherForDetailInfo = (UILabel *) [cell viewWithTag:104];
        UILabel *bookCodeForDetailInfo = (UILabel *) [cell viewWithTag:105];
        
        bookNameForDetailInfo.text = [NSString stringWithFormat:bookName];
        bookAuthorForDetailInfo.text = [NSString stringWithFormat:@"저자: %@", bookAuthor];
        bookPubYearForDetailInfo.text = [NSString stringWithFormat:@"발행년도: %@년", bookPubYear];
        bookPublisherForDetailInfo.text = [NSString stringWithFormat:@"출판사: %@", bookPublisher];
        bookCodeForDetailInfo.text = [NSString stringWithFormat:@"청구 기호 : %@", bookCodeForBookDetail];
        
        // 인덱스0 셀은 선택안되도 괜찮음 - by 우성
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        static NSString *CellIdentifier = @"bookDetailIPosiCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if( cell == nil ){  
            cell = [ [UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier: CellIdentifier  ];
        } 
        
        SearchedBookPositionInfo *bookPositionInfoForDetail = [ self.bookCodeStatusNPosi objectAtIndex: [indexPath row]];
        
//        UILabel *bookNumForDetailInfo = (UILabel *) [cell viewWithTag:201];
        UILabel *bookCodeForDetailInfo = (UILabel *) [cell viewWithTag:202];
        UILabel *bookPosiForDetailInfo = (UILabel *) [cell viewWithTag:203];
        UILabel *bookStatusForDetailInfo = (UILabel *) [cell viewWithTag:204];
//        UILabel *bookReturnedDateForDetailInfo = (UILabel *) [cell viewWithTag:205];
        
        //        bookNumForDetailInfo.text = [ NSString stringWithFormat:@"등록 번호 : %@", bookPositionInfoForDetail.bookNumber ];
        bookCodeForDetailInfo.text = [ NSString stringWithFormat:@"청구기호: %@", bookPositionInfoForDetail.bookCode ];
        bookPosiForDetailInfo.text = [ NSString stringWithFormat:@"소장위치: %@", bookPositionInfoForDetail.bookPosition];
//        bookStatusForDetailInfo.text = [ NSString stringWithFormat:@"도서 상태 : %@, %@", bookPositionInfoForDetail.bookStatus,  bookPositionInfoForDetail.bookReturnedDate];
        
//        NSLog(@"%@", bookPositionInfoForDetail.bookStatus);
        NSRange lookingBookState = [bookPositionInfoForDetail.bookStatus rangeOfString : @"대출중"];
        if( lookingBookState.location != NSNotFound ) {             
            bookStatusForDetailInfo.text = [NSString stringWithFormat:@"도서상태: %@ (반납: %@)"
                                            , bookPositionInfoForDetail.bookStatus, bookPositionInfoForDetail.bookReturnedDate];
//            bookStatusForDetailInfo.text = [bookStatusForDetailInfo.text stringByAppendingFormat:@", %@ 까지", 
//                                            bookPositionInfoForDetail.bookReturnedDate];

        } else {
            bookStatusForDetailInfo.text = [ NSString stringWithFormat:@"도서상태: %@", bookPositionInfoForDetail.bookStatus];
        }
        
//        if ([bookPositionInfoForDetail.bookStatus isEqualToString:@"대출중"]) {
//            NSLog(@"DD");
//            bookStatusForDetailInfo.text = [bookStatusForDetailInfo.text stringByAppendingFormat:@", %@ 까지", bookPositionInfoForDetail.bookReturnedDate];
//        }
        
        //bookReturnedDateForDetailInfo.text = [ NSString stringWithFormat:@"반납 기한 : %@", bookPositionInfoForDetail.bookReturnedDate ];
        
        // 나머지는 선택이 될 수 있어야 함 - by 우성
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return BOOK_DETAIL_HEIGHT;
    }else{
        return BOOK_LISTS_HEIGHT;
    }
}

#pragma Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if( indexPath.section == 1 ) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"예약하기", @"위치보기", nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}

#pragma mark - Parse html strings
- (void)parseStringForGettingBookPosi:(NSString *)htmlString {
    // 파싱한 정보 다듬기용 변수
    NSString *regiNum; // 등록 번호
    NSString *bookPosition; // 소장 위치
    NSString *bookCode; // 청구 기호
    NSString *bookStatus; // 도서 상태
    NSString *bookReturnedDate; // 반납 기한
    
    // start parsing
    // 1. <tr class="tbRecord 으로 파싱하기
    NSArray *arrForGettingBookPosi = [ htmlString componentsSeparatedByString:@"<tr class=\"tbRecord" ];
    
    // 2. 1번 배열 ~ 마지막 배열까지 <td 로 파싱하기 - 0번 배열 버리기.
    for( int numOfPosiInfo = 1 ; numOfPosiInfo < [arrForGettingBookPosi count] ; numOfPosiInfo++ ){
        NSArray *arrForGettingBookPosi1 = [ [arrForGettingBookPosi objectAtIndex : numOfPosiInfo]
                                           componentsSeparatedByString:@"<td" ];
          
        for( int infoNum = 1 ; infoNum < [arrForGettingBookPosi1 count ] - 1 ; infoNum++ ){
            //0번, 6번 배열 버리기
            //1, 2, 3, 4, 5번 배열은 >으로 파싱하기 -> 0번 배열 버리기
            NSArray *arrForGettingBookPosi2 = [ [arrForGettingBookPosi1 objectAtIndex:infoNum]
                                               componentsSeparatedByString:@">" ];
//            NSLog(@"%@", [arrForGettingBookPosi2 objectAtIndex:1]);
            
            // </td로 파싱하기 -> 1번 배열 버리기
            NSArray *arrForGettingBookPosi3 = [ [arrForGettingBookPosi2 objectAtIndex:1]
                                               componentsSeparatedByString:@"</td" ];
//            NSLog(@"%d : %d - %@", numOfPosiInfo, infoNum, [arrForGettingBookPosi3 objectAtIndex:0]);
            switch ( infoNum ) {
                case 1 :
                    regiNum = [arrForGettingBookPosi3 objectAtIndex:0];
                    break;
                case 2 :
                    bookPosition = [arrForGettingBookPosi3 objectAtIndex:0];
                    break;
                case 3 :
                    bookCode = [arrForGettingBookPosi3 objectAtIndex:0];
                    break;
                case 4 :
                    bookStatus = [arrForGettingBookPosi3 objectAtIndex:0];
                    break;
                case 5 :
                    bookReturnedDate = [arrForGettingBookPosi3 objectAtIndex:0];
                    break;                    
            }
        }
        
        // 각 도서 정보들 다듬기(빈칸 제거)
        bookStatus = [bookStatus stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        bookStatus = [bookStatus stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        bookStatus = [bookStatus stringByReplacingOccurrencesOfString:@" " withString:@""];
        bookReturnedDate = [bookReturnedDate stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        bookReturnedDate = [bookReturnedDate stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        // 소장 정보 저장을 위해 instance 생성
        SearchedBookPositionInfo *bookPositionInfo = [[SearchedBookPositionInfo alloc] init];
        
        // 클래스 내에 정보 넣기
        [bookPositionInfo setBookNumber : regiNum];
        [bookPositionInfo setBookPosition: bookPosition];
        [bookPositionInfo setBookCode : bookCode];
        [bookPositionInfo setBookStatus : bookStatus];
        [bookPositionInfo setBookReturnedDate : bookReturnedDate];        
        
//        // for test
//        NSLog(@"book Num : %@", bookPositionInfo.bookNumber);
//        NSLog(@"book Position : %@", bookPositionInfo.bookPosition);
//        NSLog(@"book code : %@", bookPositionInfo.bookCode);
//        NSLog(@"Status : %@", bookPositionInfo.bookStatus);
//        NSLog(@"Returned date : %@", bookPositionInfo.bookReturnedDate);
        
        // 도서 소장 정보 목록에 추가
        [bookCodeStatusNPosi addObject:bookPositionInfo];
    }
}

#pragma mark - URLConnection methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"경북대 도서관" message:@"네트워크를 사용할 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    
    [alertView show];
    
    self.title = @"도서 정보";
    [self.spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"didReceiveData\n");
    
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {     
//    NSLog(@"BookPosition_connectionDidFinishLoading ");  
    
    // EUC-KR - 0x80000940는 EUC-KR에 해당하는 인코딩 코드.
    NSString *htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    // Parsing html string
    [self parseStringForGettingBookPosi:htmlString];
    [self.tableView reloadData];
    [self.spinner stopAnimating];
}  

#pragma mark - UIActionSheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
//            NSLog(@"예약하기");
            UIAlertView *notReadyAlertView = [[UIAlertView alloc] initWithTitle:@"경북대학교 도서관" message:@"죄송합니다. 구현중입니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles: nil];
              [notReadyAlertView show];
            break;
        }   
        case 1: {
//            NSLog(@"위치보기");
            UIAlertView *notReadyAlertView = [[UIAlertView alloc] initWithTitle:@"경북대학교 도서관" message:@"죄송합니다. 구현중입니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles: nil];
              [notReadyAlertView show];
            break;
        } 
        case 2:
            NSLog(@"취소");
            break;
    }
     
}

@end
