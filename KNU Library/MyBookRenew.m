//
//  MyBookRenew.m
//  KNU Library
//
//  Created by apple10 on 12. 5. 30..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "MyBookRenew.h"
#import "MyBookInfo.h"
#import "MyBookInfoParser.h"

@implementation MyBookRenew
@synthesize cookie;
@synthesize receivedData;
@synthesize delegate;
@synthesize myBookInfoConnection1;

#pragma mark - URL Connection Delegate Methods

- (id)init {
    if (self == [super init]) {
        // 초기화 
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)Response {
    //[receivedData setLength:0]; 
    
    NSLog(@"MyBookInfoParser_didReceiveResponese");
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)Response; 
    NSInteger code = [HTTPResponse statusCode];
    NSLog(@"status code: %d", code);
    NSLog(@"%@", [[HTTPResponse URL] description]);
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    
    for (NSString *key in fields) {
        NSLog(@"%@: %@", key, [fields valueForKey:key]);
    }
    
    NSString *string = [fields valueForKey:@"Set-Cookie"];
    
    if (string == nil) {
        NSLog(@"Coockie String is nil");
    }else{
        //        self.cookie = string;
        NSLog(@"Cookie in Response : %@", string);
    }
    
    if ([[[HTTPResponse URL] description] isEqualToString:@"http://155.230.44.26/​mylibrary/Renew.json?"]) {
        [self getMyBookInfoFromServer];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)postData {
    //NSLog(@"LogIn_didReceiveData");
    [receivedData appendData:postData];	//서버에서 보낸 값을 쌓는다.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    NSLog(@"MyBookInfoParser_connectionDidFinishLoading");
    
    NSString *htmlString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", htmlString);    
    
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

- (void)getMyBookInfoFromServer {
    
    MyBookInfoParser *myBookInfoParser1 = [[MyBookInfoParser alloc] init];
    myBookInfoParser1.delegate = self;
    
    NSString *myBookInfoURL = @"http://155.230.44.26/mylibrary/Circulation.ax";
    NSMutableURLRequest *myBookInforequest1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:myBookInfoURL]                                                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0]; 
    NSLog(@"cookie: %@", self.cookie);
    [myBookInforequest1 addValue:self.cookie forHTTPHeaderField:@"Cookie"];
    self.myBookInfoConnection1 = [[NSURLConnection alloc] initWithRequest:myBookInforequest1 delegate:myBookInfoParser1];
    
    if (self.myBookInfoConnection1) { 
        NSLog(@"LogIn_MyBookInfo_connected");
    }else{
        NSLog(@"LogIn_MyBookInfo_Failed");
    }
}

@end
