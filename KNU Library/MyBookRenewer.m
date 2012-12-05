//
//  MyBookRenewer.m
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 6. 2..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "MyBookRenewer.h"

@implementation MyBookRenewer

@synthesize cookie;
@synthesize receivedData;
@synthesize delegate;

- (id)init {
    if (self == [super init]) {
        // 초기화 
        self.receivedData = [NSMutableData data];
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
    
//    NSLog(@"%@", self.cookie);
    NSString *htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", htmlString);
    
    [self handleDataWithString:htmlString];
    [self.delegate MyBookRenwerDidFinishRenew:self];
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

// 결과 스트링 파싱해서 UIAlertView 출력
- (void)handleDataWithString:(NSString *)htmlString {
    NSArray *array1 = [htmlString componentsSeparatedByString:@"message\":\""];
    NSArray *array2 = [[array1 objectAtIndex:1] componentsSeparatedByString:@"\""];
    
//    NSLog(@"%@", [array2 objectAtIndex:0]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"경북대학교 도서관" message:[array2 objectAtIndex:0] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    
    [alertView show];
}

@end
