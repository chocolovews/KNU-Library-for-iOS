//
//  SearchBookResultController.m
//  KNU Library
//
//  Created by 용빈 배 on 12. 5. 21..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "SearchBookResultController.h"
#import "BookSearchDetailController.h"

@interface SearchBookResultController ()

@end

@implementation SearchBookResultController

@synthesize searchKeyword;

@synthesize receivedData;
@synthesize searchResultBookList;

@synthesize sizeOfBooksToSearch;
//@synthesize numberOfPageToSearch;
@synthesize spinner;
@synthesize delegate;
@synthesize isLoadingFinished;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (void)makeConnectionWithPageNumber(NSInteger)pageNumber {
    NSString *urlString = [NSString stringWithFormat:@"http://155.230.44.26/search/Search.Result.ax?sid=8&q=ALL:%@&mf=true&page=1&pageSize=%d", self.searchKeyword, pageSize];


    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];

    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    if (theConnection) {
        NSLog(@"BookInfo_connected");
    }else{
        NSLog(@"BookInfo_Connection failed");
    }
}
 */

- (void)makeConnectionWithPageSize:(NSInteger)pageSize {
    
    NSString *urlString = [NSString stringWithFormat:@"http://155.230.44.26/search/Search.Result.ax?sid=8&q=ALL:%@&mf=true&page=1&pageSize=%d", self.searchKeyword, pageSize];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (theConnection) {
//        NSLog(@"BookInfo_connected");
    }else{
        NSLog(@"BookInfo_Connection failed");
    }
}

- (void)initConnection {
    // 검색 결과 저장을 위한 가변 크기의 배열 선언
    searchResultBookList = [NSMutableArray array];
    
    // URLConnection 
    self.receivedData = nil;
    self.receivedData = [NSMutableData data];
    
    [self makeConnectionWithPageSize:sizeOfBooksToSearch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // String Percentage notation 변환 
    //    NSString *string = [NSString stringWithString:@"심 경 주"];
    //    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    
    //    NSLog(@"%@", string);
    
    self.isLoadingFinished = NO;
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.spinner setHidesWhenStopped:YES];
    //        [spinner setColor:[UIColor blackColor]];
    UIBarButtonItem * spinnerBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    [[self navigationItem] setRightBarButtonItem:spinnerBarItem];
    [self.spinner startAnimating];
    
    self.title = @"검색 중...";
    
    self.sizeOfBooksToSearch = 20;
//    self.numberOfPageToSearch = 1;
    [self initConnection];
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
    return [self.searchResultBookList count] + 1; // 나중에 +1해주기
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if( indexPath.row < [self.searchResultBookList count] ) {
        static NSString *CellIdentifier = @"bookSearchResultCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        SearchedBookInfo *bookInfo = [ self.searchResultBookList objectAtIndex:[indexPath row] ];
        if( cell == nil ){  
            cell = [ [UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier: CellIdentifier  ];
        } 
        
        // 책 정보 출력
        UILabel *bookNameLabel = (UILabel *) [cell viewWithTag:101];
        UILabel *authorPublisherYearLabel = (UILabel *) [cell viewWithTag:102];
        UILabel *bookCodeLabel = (UILabel *) [cell viewWithTag:103];
        
        bookNameLabel.text = [ NSString stringWithFormat:@"%@", bookInfo.bookName ];
        authorPublisherYearLabel.text = [ NSString stringWithFormat:@"%@ / %@ / %@"
                                         , bookInfo.bookAuthor
                                         , bookInfo.bookPublisher
                                         , bookInfo.bookPubYear ];
        bookCodeLabel.text = [ NSString stringWithFormat:@"%@ / %@", bookInfo.bookCode, bookInfo.bookStatus ];
    }
    
    else if( indexPath.row == [self.searchResultBookList count] ) {
        static NSString *CellIdentifier = @"moreBookSearchCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if( cell == nil ){  
            cell = [ [UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier: CellIdentifier  ];
        }
        
        UILabel *searchingStatusLabel = (UILabel *) [cell viewWithTag:200];
        
        if (isLoadingFinished == NO) {
            searchingStatusLabel.text = [NSString stringWithFormat:@"검색 중입니다...."];
        }else{
            if( 0 == [self.searchResultBookList count] )
            {
                searchingStatusLabel.text = [ NSString stringWithFormat:@"검색 결과가 없습니다." ];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setUserInteractionEnabled:NO];
            }
            
            else
            {
                searchingStatusLabel.text = [ NSString stringWithFormat:@"검색결과 더 보기...(20개)" ];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                [cell setUserInteractionEnabled:YES];
            }
        }        
    }   
    
    return cell;
}

//// set tabel cell's size
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ( [indexPath row] == [self.searchResultBookList count] ) {
//        return SEARCH_MSG_HEIGHT;
//    }
//    
//    else {
//        return SEARCH_RESULT_HEIGHT;
//    }
//}
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
    // 히스토리 정보 저장하기
    
    if( indexPath.row < [self.searchResultBookList count] ) {

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        BookSearchDetailController *bookDetailController = [storyBoard instantiateViewControllerWithIdentifier:@"bookSearchDetailController"];

        // 선택한 도서의 자세한 정보 넘기기
        bookDetailController.bookCNum = [ [searchResultBookList objectAtIndex:[indexPath row]] bookCNum ];
        bookDetailController.bookName = [ [searchResultBookList objectAtIndex:[indexPath row]] bookName ];
        bookDetailController.bookAuthor = [ [searchResultBookList objectAtIndex:[indexPath row]] bookAuthor ];
        bookDetailController.bookPublisher = [ [searchResultBookList objectAtIndex:[indexPath row]] bookPublisher ];
        bookDetailController.bookPubYear = [ [searchResultBookList objectAtIndex:[indexPath row]] bookPubYear ];
        bookDetailController.bookCodeForBookDetail = [ [searchResultBookList objectAtIndex:[indexPath row]] bookCode ];
    //    NSLog(@"%@", [ [searchResultBookList objectAtIndex:[indexPath row]] bookName]);
        

        // 히스토리에 저장
        [self.delegate SearchBookResultControllerDidShowBookSearchDetail:[self.searchResultBookList objectAtIndex:[indexPath row]]];
        
        // 도서 정보 보여주기(BookSearchDetailController으로 넘어가기)
        [self.navigationController pushViewController:bookDetailController animated:YES];
    } 
    
    else {
        //NSLog(@"More Pages");
        self.sizeOfBooksToSearch += 20;
        [self.spinner startAnimating];
        
        self.title = @"검색 중...";
        
        [self initConnection];
    }
}

#pragma mark - Parse html strings
- (void)handleDataWithString:(NSString *)htmlString {
    // start parsing
    // get book information : 1. parsing <div class="body"> 
    // NSArray : 배열 내의 내용들 수정, 삭제가 안 됨->NSMutableArray 형으로 수정해서 할 것.
    NSArray *arrForbookInfo = [htmlString componentsSeparatedByString:@"<div class=\"body\""];
    NSMutableArray *mutableArrForbookInfo = [NSMutableArray arrayWithArray:arrForbookInfo];
//    NSLog(@"book count = %d", [arrForbookInfo count]);
    // 검색 결과가 존재할 때
    if( 1 != [arrForbookInfo count] )
    {
        // 2. 마지막 배열 내의 string값을 <p class="cluster"> 키워드로 파싱하기 -> 0번 배열 사용
        NSArray *clipUselessString = [[arrForbookInfo objectAtIndex:[arrForbookInfo count]-1] componentsSeparatedByString:@"<p class=\"cluster\">"];
        NSString *tempString = [mutableArrForbookInfo objectAtIndex:[mutableArrForbookInfo count] - 1]; //포인터로 간접 접근해서 수정해야 하는 듯.
        tempString = 
        [[mutableArrForbookInfo objectAtIndex:[mutableArrForbookInfo count] - 1] stringByReplacingOccurrencesOfString:
         [mutableArrForbookInfo objectAtIndex:[mutableArrForbookInfo count] - 1] withString:[clipUselessString objectAtIndex:0]];
        
        [mutableArrForbookInfo replaceObjectAtIndex:([mutableArrForbookInfo count] - 1) withObject:tempString];
        //       NSLog(@"%@", [mutableArrForbookInfo objectAtIndex:[mutableArrForbookInfo count] -1 ]);
        // *** 도서 정보들 얻는 부분.
        // ** 오류 수정(12.05.19) : arrForbookInfo - 0번째 배열은 버려야 하는 자료였음 -_-
        for( int bookInfoIndex = 1 ; bookInfoIndex < [arrForbookInfo count] ; bookInfoIndex++ )
        {
            // 검색 결과 저장을 위해 instance 생성
            SearchedBookInfo *searchedBookInfo = [[SearchedBookInfo alloc] init];
            
            // 여기에 넣을 값들은 별도의 처리를 거친 후, 나중에 클래스 변수값으로 대입.
            NSString *bookCNum;
            NSString *bookPosi;
            NSString *bookStat;
            NSString *bookCode;
            NSString *bookPubYear;
            NSString *bookPublisher;
            NSString *bookName;
            NSString *bookAuthor;
            ///////////////////////////////////////////
            
            // 3. <div id="idid_ 키워드로 파싱
            NSArray *arrForGetBookNum = [ [mutableArrForbookInfo objectAtIndex: bookInfoIndex] componentsSeparatedByString:@"<div id=\"idid_" ];
            //NSLog(@"%d", [arrForGetBookNum count]);
            
            // 연속 간행물의 경우
            if( 1 == [ arrForGetBookNum count ] ) {
                NSArray *arrForGetBookNumForRel = [ [mutableArrForbookInfo objectAtIndex: bookInfoIndex] componentsSeparatedByString:@"<div id=\"rel_" ];
                NSArray *arrForGetBookNum1 = [ [arrForGetBookNumForRel objectAtIndex:1] componentsSeparatedByString:@"\" class=\"previewListViewHolder\"" ];
                bookCNum = [arrForGetBookNum1 objectAtIndex:0];
                
                // 9. 5번 단계에서의 0번째 배열을 &nbsp; 키워드로 파싱하기
                NSArray *arrForGetPub = [ [arrForGetBookNumForRel objectAtIndex:0]
                                         componentsSeparatedByString:@"&nbsp;" ];
                // 10. 9번 단계에서의 0번째 배열을 <!--test--> 키워드로 파싱하기
                NSArray *arrForGetPub1 = [ [arrForGetPub objectAtIndex:0]
                                          componentsSeparatedByString:@"<!--test-->" ];
                // 11. 10번 단계에서의 1번째 배열을 , 키워드로 파싱하기
                NSArray *arrForGetPub2 = [ [arrForGetPub1 objectAtIndex:1]
                                          componentsSeparatedByString:@"," ];
                // 12. 11번 단계에서의 1번째 배열을 . 키워드로 파싱하기
                //      -> 발행년도 얻기(0번 배열)
                //      -> 출판사 얻기(1번 배열)
                NSArray *arrForGetPub3 = [ [arrForGetPub2 objectAtIndex:1]
                                          componentsSeparatedByString:@"." ];
                
                bookPubYear = [arrForGetPub3 objectAtIndex:0];
                bookPublisher = [arrForGetPub3 objectAtIndex:1];
                
                
                // 13. 10번 단계에서의 0번째 배열을 </a><a href="javascript:search.goDetail( 키워드로 파싱하기
                NSArray *arrForGetName = [ [arrForGetPub1 objectAtIndex:0]
                                          componentsSeparatedByString:@"</a><a href=\"javascript:search.goDetail(" ];
                // 14. 13번 단계에서의 0번째 배열을 class="title"> 키워드로 파싱하기
                NSArray *arrForGetName1 = [ [arrForGetName objectAtIndex:0]
                                           componentsSeparatedByString:@"class=\"title\">" ];
                
                // 15. 14번 단계에서의 1번째 배열을 / 키워드로 파싱하기
                //      -> 책 이름 얻기(0번 배열)
                NSArray *arrForGetName2 = [ [arrForGetName1 objectAtIndex:1]
                                           componentsSeparatedByString:@"/ " ];
                
                // 저자 정보가 없는 경우
                if( 1 == [ arrForGetName2 count ] )
                {
                    NSArray *arrForGetAuthor = [ [arrForGetName2 objectAtIndex:0]
                                                componentsSeparatedByString:@"<" ];
                    bookName = [arrForGetAuthor objectAtIndex:0];
                    bookAuthor = @"정보없음";                
                }
                
                else
                {
                    // 16. 15번 단계에서의 1번째 배열을 < 키워드로 파싱하기
                    //      -> 저자 얻기(0번 배열)
                    NSArray *arrForGetAuthor = [ [arrForGetName2 objectAtIndex:1]
                                                componentsSeparatedByString:@"<" ];
                    
                    bookName = [arrForGetName2 objectAtIndex:0];
                    bookAuthor = [arrForGetAuthor objectAtIndex:0];
                }                
            }
            
            // 일반 도서의 경우
            else
            {
                // 4. 3번 단계에서의 1번째 배열을 " class="previewListViewHolder" 키워드로 파싱 
                //    -> 도서 번호 얻기(0번 배열)
                NSArray *arrForGetBookNum1 = [ [arrForGetBookNum objectAtIndex:1] componentsSeparatedByString:@"\" class=\"previewListViewHolder\"" ];
                bookCNum = [arrForGetBookNum1 objectAtIndex:0];
                
                
                // 5. 3번 단계에서의 0번째 배열을 );" class="underline"> 키워드로 파싱
                NSArray *arrForGetPosi1 = [ [arrForGetBookNum objectAtIndex:0]
                                           componentsSeparatedByString:@");\" class=\"underline\">" ];
                // 6. 5번 단계에서의 1번째 배열을 <br/></p> 키워드로 파싱하기
                NSArray *arrForGetPosi2 = [ [arrForGetPosi1 objectAtIndex:1]
                                           componentsSeparatedByString:@"<br/></p>" ];
                // 7. 6번 단계에서의 0번째 배열을 > 키워드로 파싱하기
                NSArray *arrForGetPosi3 = [ [arrForGetPosi2 objectAtIndex:0]
                                           componentsSeparatedByString:@">" ];
                // 8. 7번 단계에서의 0번째 배열을 </a 키워드로 파싱하기
                //      -> 소장 위치 얻기(0번 배열)
                //    7번 단계에서의 1번째 배열을 <br/ 키워드로 파싱하기
                //      -> 도서 코드+상태 얻기(0번 배열)
                NSArray *arrForGetPosi4 = [ [arrForGetPosi3 objectAtIndex:0]
                                           componentsSeparatedByString:@"</a" ];
                NSArray *arrForGetStat = [ [arrForGetPosi3 objectAtIndex:1]
                                          componentsSeparatedByString:@"<br/" ];
                
                bookPosi = [arrForGetPosi4 objectAtIndex:0];
                
                // 도서 코드랑 도서 상태 분리하기 -> 1. arrForGetStat을 [ 으로 파싱하기
                //                          -> 2. 1번 단계의 1번 배열을 ] 으로 파싱하기
                //      -> 도서 코드(0번 배열) / 도서 상태(1번 배열)
                NSArray *arrForGetCode = [ [arrForGetStat objectAtIndex:0]
                                          componentsSeparatedByString:@"[" ];
                NSArray *arrForGetCode1 = [ [arrForGetCode objectAtIndex:1]
                                           componentsSeparatedByString:@"]" ];
                
                bookCode = [arrForGetCode1 objectAtIndex:0];
                bookStat = [arrForGetCode1 objectAtIndex:1];    
                
                
                // 9. 5번 단계에서의 0번째 배열을 &nbsp; 키워드로 파싱하기
                NSArray *arrForGetPub = [ [arrForGetPosi1 objectAtIndex:0]
                                         componentsSeparatedByString:@"&nbsp;" ];
                // 10. 9번 단계에서의 0번째 배열을 <!--test--> 키워드로 파싱하기
                NSArray *arrForGetPub1 = [ [arrForGetPub objectAtIndex:0]
                                          componentsSeparatedByString:@"<!--test-->" ];
                // 11. 10번 단계에서의 1번째 배열을 , 키워드로 파싱하기
                NSArray *arrForGetPub2 = [ [arrForGetPub1 objectAtIndex:1]
                                          componentsSeparatedByString:@"," ];
                // 12. 11번 단계에서의 1번째 배열을 . 키워드로 파싱하기
                //      -> 발행년도 얻기(0번 배열)
                //      -> 출판사 얻기(1번 배열)
                NSArray *arrForGetPub3 = [ [arrForGetPub2 objectAtIndex:1]
                                          componentsSeparatedByString:@"." ];
                
                bookPubYear = [arrForGetPub3 objectAtIndex:0];
                bookPublisher = [arrForGetPub3 objectAtIndex:1];
                
                
                // 13. 10번 단계에서의 0번째 배열을 </a><a href="javascript:search.goDetail( 키워드로 파싱하기
                NSArray *arrForGetName = [ [arrForGetPub1 objectAtIndex:0]
                                          componentsSeparatedByString:@"</a><a href=\"javascript:search.goDetail(" ];
                // 14. 13번 단계에서의 0번째 배열을 class="title"> 키워드로 파싱하기
                NSArray *arrForGetName1 = [ [arrForGetName objectAtIndex:0]
                                           componentsSeparatedByString:@"class=\"title\">" ];
                
                // 15. 14번 단계에서의 1번째 배열을 / 키워드로 파싱하기
                //      -> 책 이름 얻기(0번 배열)
                NSArray *arrForGetName2 = [ [arrForGetName1 objectAtIndex:1]
                                           componentsSeparatedByString:@"/ " ];
                
                // 저자 정보가 없는 경우
                if( 1 == [ arrForGetName2 count ] )
                {
                    NSArray *arrForGetAuthor = [ [arrForGetName2 objectAtIndex:0]
                                                componentsSeparatedByString:@"<" ];
                    bookName = [arrForGetAuthor objectAtIndex:0];
                    bookAuthor = @"정보없음";                
                }
                
                else
                {
                    // 16. 15번 단계에서의 1번째 배열을 < 키워드로 파싱하기
                    //      -> 저자 얻기(0번 배열)
                    NSArray *arrForGetAuthor = [ [arrForGetName2 objectAtIndex:1]
                                                componentsSeparatedByString:@"<" ];
                    
                    bookName = [arrForGetName2 objectAtIndex:0];
                    bookAuthor = [arrForGetAuthor objectAtIndex:0];
                }
            }
            
            // ** 대입할 도서 정보들 다듬기 
            // 1. bookName 내의 빈 공간 모두 제거하기
            bookName = [ bookName stringByReplacingOccurrencesOfString:@"\t" withString: @"" ];
            bookName = [ bookName stringByReplacingOccurrencesOfString:@"\n " withString: @"" ];
            
            // 2. bookAuthor 내의 빈 공간 제거 & ; -> , 으로 바꾸기
            bookAuthor = [ bookAuthor stringByReplacingOccurrencesOfString:@"\t" withString: @"" ];
            bookAuthor = [ bookAuthor stringByReplacingOccurrencesOfString:@" ; " withString: @", "];
            //            bookAuthor = [ bookAuthor substringFromIndex:1 ];
            
            // 3. bookPublisher, bookPubYear 내의 빈 공간 모두 제거하기
            bookPublisher = [ bookPublisher stringByReplacingOccurrencesOfString:@"\t " withString: @"" ];
            bookPublisher = [ bookPublisher stringByReplacingOccurrencesOfString:@"\t" withString: @"" ];
            bookPublisher = [ bookPublisher substringFromIndex:1 ];
            bookPubYear = [ bookPubYear stringByReplacingOccurrencesOfString:@" " withString: @"" ];
            
            // 4. bookStat 내의 빈 공간 모두 제거하기
            bookStat = [ bookStat stringByReplacingOccurrencesOfString:@"\t" withString: @"" ];
            bookStat = [ bookStat stringByReplacingOccurrencesOfString:@" " withString: @"" ];
            
            
            // SearchedBookInfo클래스 내의 각 속성들 내에 해당 값들 대입
            [searchedBookInfo setBookCNum: bookCNum];
            [searchedBookInfo setBookName: bookName];
            [searchedBookInfo setBookAuthor: bookAuthor];
            [searchedBookInfo setBookPublisher: bookPublisher];
            [searchedBookInfo setBookPubYear: bookPubYear];
            [searchedBookInfo setBookPosition: bookPosi];
            [searchedBookInfo setBookCode: bookCode];
            [searchedBookInfo setBookStatus: bookStat];
            
            // for test
//            NSLog(@"Contents Num : %@", [searchedBookInfo bookCNum]);
//            NSLog(@"%d) Name : %@", bookInfoIndex, [searchedBookInfo bookName]);
            //             NSLog(@"Author : %@", [searchedBookInfo bookAuthor]);
            //             NSLog(@"Publisher : %@", [searchedBookInfo bookPublisher]);
            //             NSLog(@"Year : %@", [searchedBookInfo bookPubYear]);
            //             NSLog(@"Position : %@", [searchedBookInfo bookPosition]);
            //             NSLog(@"Code : %@", [searchedBookInfo bookCode]);
            //             NSLog(@"Status : %@\n", [searchedBookInfo bookStatus]);
            
            [searchResultBookList addObject:searchedBookInfo];
        }
    }
}

#pragma mark - URLConnection methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"경북대 도서관" message:@"네트워크를 사용할 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    
    [alertView show];
    
    self.title = @"검색 결과";
    [self.spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"didReceiveData\n");
    
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {     
//    NSLog(@"BookInfo_connectionDidFinishLoading ");  
    
    isLoadingFinished = YES;
    
    searchResultBookList = nil;
    searchResultBookList = [NSMutableArray array];
//    NSLog(@"count : %d", [searchResultBookList count]);
    // EUC-KR - 0x80000940는 EUC-KR에 해당하는 인코딩 코드.
    NSString *htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
//    NSLog(@"%@", htmlString);
    
    // Parsing html string
    self.searchResultBookList = nil;
    self.searchResultBookList = [NSMutableArray array];
    
//    NSLog(@"count : %d", [self.searchResultBookList count]);
    
    [self handleDataWithString:htmlString];
    [self.tableView reloadData];
    //NSLog(@"%@", htmlString);
//    NSLog(@"count1 : %d", [searchResultBookList count]);
    self.title = @"검색 결과";
    [self.spinner stopAnimating];
}  

@end
