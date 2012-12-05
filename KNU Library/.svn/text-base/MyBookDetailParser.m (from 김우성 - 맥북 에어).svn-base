//
//  MyBookDetailParser.m
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 5. 31..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "MyBookDetailParser.h"

@implementation MyBookDetailParser

@synthesize myBookDetailInfo;
@synthesize receivedData;
@synthesize delegate;

- (id)init {
    if (self == [super init]) {
        // 초기화 
        self.receivedData = [NSMutableData data];
        self.myBookDetailInfo = [[SearchedBookInfo alloc] init];
    }
    return self;
}

#pragma mark - URL Connection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)Response {
 
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)postData {
    //NSLog(@"LogIn_didReceiveData");
    [receivedData appendData:postData];	//서버에서 보낸 값을 쌓는다.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    //NSLog(@"MyBookInfoParser_connectionDidFinishLoading");
    
    NSString *htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", htmlString);
    
    [self handleDataWithString:htmlString];
    [self.delegate MyBookDetailParserDidFinishParsing:self.myBookDetailInfo];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    // receivedData is declared as a method instance elsewhere
    
    // inform the user
    NSLog(@"MyBookInfoParser_Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

#pragma mark - parsing

// 파싱하는 로직을 작성해서 loginInfoList에 넣음.
- (void)handleDataWithString:(NSString *)htmlString {

    // 원하는 스트링의 첫부분을 얻음
    NSArray *array1 = [htmlString componentsSeparatedByString:@"<td class=\"detailBody\"> 국내서단행본 </td>"];
//    NSLog(@"%@", [myBookDeatailArray1 objectAtIndex:1]);
    
    // 원하는 스트링의 마지막 부분을 얻음
    NSArray *array2 = [[array1 objectAtIndex:1] componentsSeparatedByString:@"</tbody>"];
//    NSLog(@"%@", [myBookDetailArray2 objectAtIndex:0]);
    NSString *wholeStringToParsing = [array2 objectAtIndex:0];
//    NSLog(@"%@", wholeStringToParsing);
    
    // 서명 / 저자 : </td><td class="detailBody">
    NSArray *array3 = [[array2 objectAtIndex:0] componentsSeparatedByString:@"서명 / 저자 : </td><td class=\"detailBody\">"];
//    NSLog(@"%@", [array3 objectAtIndex:1]);
    
    // 도서명 파싱
    NSArray *array4 = [[array3 objectAtIndex:1] componentsSeparatedByString:@" / "];
//    NSLog(@"%@", [array4 objectAtIndex:0]);
    
    // 저자 파싱
    NSArray *array5 = [[array4 objectAtIndex:1] componentsSeparatedByString:@"</td>"];
//    NSLog(@"%@", [array5 objectAtIndex:0]);
    
    // 발행사항 더미 파싱 : <td class="detailHead">발행사항 : </td><td class="detailBody">
    NSArray *array6 = [wholeStringToParsing componentsSeparatedByString:@"<td class=\"detailHead\">발행사항 : </td><td class=\"detailBody\">"];
//    NSLog(@"%@", [array6 objectAtIndex:1]);
    
    // 출판년도 파싱
    NSArray *array7 = [[array6 objectAtIndex:1] componentsSeparatedByString:@" </td>"];
    NSArray *array8 = [[array7 objectAtIndex:0] componentsSeparatedByString:@", "];
//    NSLog(@"publisher: %@", [array8 objectAtIndex:0]);
//    NSLog(@"year: %@", [array8 objectAtIndex:1]);

    
    // 출판사 파싱
    NSArray *array9 = [[array8 objectAtIndex:0] componentsSeparatedByString:@" : "];
//    NSLog(@"publisher: %@", [array9 objectAtIndex:[array9 count]-1]);
    
    // 청구기호 더미 파싱
    NSArray *array10 = [wholeStringToParsing componentsSeparatedByString:@"<td class=\"detailHead\">청구기호 : </td><td class=\"detailBody\">"];
    NSArray *array11 = [[array10 objectAtIndex:1] componentsSeparatedByString:@" </td>"];
//    NSLog(@"%@", [array11 objectAtIndex:0]);
    
    self.myBookDetailInfo.bookName = [array4 objectAtIndex:0];
    self.myBookDetailInfo.bookAuthor = [array5 objectAtIndex:0];
    self.myBookDetailInfo.bookPublisher = [array9 objectAtIndex:[array9 count]-1];
    self.myBookDetailInfo.bookPubYear = [array8 objectAtIndex:1];
    self.myBookDetailInfo.bookPosition = @"null";
    self.myBookDetailInfo.bookCode = [array11 objectAtIndex:0];
    self.myBookDetailInfo.bookStatus = @"";
    
    // for test
    /*
    NSLog(@"%@", self.myBookDetailInfo.bookName);
    NSLog(@"%@", self.myBookDetailInfo.bookAuthor);
    NSLog(@"%@", self.myBookDetailInfo.bookPublisher);
    NSLog(@"%@", self.myBookDetailInfo.bookPubYear);
    NSLog(@"%@", self.myBookDetailInfo.bookPosition);
    NSLog(@"%@", self.myBookDetailInfo.bookCode);
    NSLog(@"%@", self.myBookDetailInfo.bookStatus);
    */
}


@end
