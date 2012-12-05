//
//  MyBookInfoParser.m
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 5. 18..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "MyBookInfoParser.h"
#import "MyBookInfo.h"

@implementation MyBookInfoParser

@synthesize receivedData;
@synthesize myBooksInfoList;
@synthesize delegate;

- (id)init {
    if (self == [super init]) {
        // 초기화 
        self.receivedData = [NSMutableData data];
        self.myBooksInfoList = [NSMutableArray array];
        
    }
    return self;
}

#pragma mark - URL Connection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)Response {
    //[receivedData setLength:0]; 
    
    //NSLog(@"MyBookInfoParser_didReceiveResponese");
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
//        self.cookie = string;
        //NSLog(@"Cookie in Response : %@", string);
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)postData {
    //NSLog(@"LogIn_didReceiveData");
    [receivedData appendData:postData];	//서버에서 보낸 값을 쌓는다.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    //NSLog(@"MyBookInfoParser_connectionDidFinishLoading");
    
    // 책 정보가 있는 HTML만 받아들임 
    NSString *htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", htmlString);    
    
    [self handleDataWithString:htmlString];
    [self.delegate MyBookInfoParserDidFinishParsing:self];
    
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
    //NSLog(@"htmlString = %@", htmlString);
    
    NSArray *loginInfoArray1 = [htmlString componentsSeparatedByString:@"</form>"];
    
    //NSLog(@"%d", [loginInfoArray1 count]);
//    NSLog(@"%@", [loginInfoArray1 objectAtIndex:1]);
    
    NSArray *loginInfoArray2 = [[loginInfoArray1 objectAtIndex:1] componentsSeparatedByString:@"<img src=\".."];
    //NSLog(@"%d", [loginInfoArray2 count]); 
//    NSLog(@"%@", [loginInfoArray2 objectAtIndex:1]);
    
    // 각 층별로 나누어진 Array
    //NSArray *loginInfoSeperatedArray = [[loginInfoArray2 objectAtIndex:1] componentsSeparatedByString:@"<span>연장</span></a></span></span>"];
    
    
    // SeatInfo 리스트 생성
    for(int i=1;i<[loginInfoArray2 count]; i++) {
        
        // SeatInfo 인스턴스 생성
        MyBookInfo *myBookInfo = [[MyBookInfo alloc] init];
        
        // 파싱 시작
        NSString *separeteTokenString = [NSString stringWithString:@"\">"];
        //NSLog(@"%@", separeteTokenString);
        
        // bookName
        NSArray *parsedArray1 = [[loginInfoArray2 objectAtIndex:i] componentsSeparatedByString:separeteTokenString];
        //NSLog(@"%@", [parsedArray1 objectAtIndex:0]);
        //NSLog(@"%d", [parsedArray1 count]);
        
        NSArray *parsedArray2 = [[parsedArray1 objectAtIndex:0] componentsSeparatedByString:@"title=\""];
        //NSLog(@"%@", [parsedArray2 objectAtIndex:1]);
        
        // bookID
        NSArray *parsedArrayid = [[parsedArray1 objectAtIndex:0] componentsSeparatedByString:@"cid="];
        NSArray *parsedArrayid1 = [[parsedArrayid objectAtIndex:1] componentsSeparatedByString:@"\" title"];
//        NSLog(@"%@", [parsedArrayid1 objectAtIndex:0]);
        
        // bookNumInfo
        NSArray *parsedArray3 = [[parsedArray1 objectAtIndex:1] componentsSeparatedByString:@"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"];
        NSString *parsedArray3string = [[[parsedArray3 objectAtIndex:1] substringFromIndex:0] substringToIndex:22];
        //NSLog(@"%@", parsedArray3string);//[parsedArray3 objectAtIndex:1]);
        
        // bookPeriodInfo
        NSArray *parsedArray4 = [[parsedArray1 objectAtIndex:1] componentsSeparatedByString:@"<td>"];
        NSString *parsedArray4string = [[[parsedArray4 objectAtIndex:2] substringFromIndex:8] substringToIndex:10];
        NSString *parsedArray5string = [[[parsedArray4 objectAtIndex:3] substringFromIndex:8] substringToIndex:10];
        //NSLog(@"%@", parsedArray5string);
        
        // bookAddInformation
        NSString *parsedArray6string = [[[parsedArray4 objectAtIndex:4] substringFromIndex:5] substringToIndex:5];
        NSArray *parsedArray5 = [parsedArray6string componentsSeparatedByString:@"/"];
        //NSLog(@"%@", [parsedArray4 objectAtIndex:5]);
        
        // bookIDForReNew
//        NSLog(@"%@", [parsedArray1 objectAtIndex:3]);
        NSArray *parsedArray6 = [[parsedArray1 objectAtIndex:3] componentsSeparatedByString:@"\""];
//        NSLog(@"%@", [parsedArray6 objectAtIndex:3]);
        
        
        myBookInfo.bookNameInfo = [parsedArray2 objectAtIndex:1];
        myBookInfo.bookNumInfo = parsedArray3string;
        myBookInfo.bookPeriodInfo = [NSString stringWithFormat:@"%@ ~ %@", parsedArray4string, parsedArray5string];
        myBookInfo.bookAddInformation = [parsedArray5 objectAtIndex:0];
        myBookInfo.bookID = [parsedArrayid1 objectAtIndex:0];
        myBookInfo.bookIDForReNew = [parsedArray6 objectAtIndex:3];
        
        /*
        NSLog(@"1. %@", myBookInfo.bookNameInfo);
        NSLog(@"2. %@", myBookInfo.bookNumInfo);
        NSLog(@"3. %@", myBookInfo.bookPeriodInfo);
        NSLog(@"4. %@", myBookInfo.bookAddInformation);
        NSLog(@"5. %@", myBookInfo.bookID);
        */
        
        [myBooksInfoList addObject:myBookInfo];
    }
}

@end
