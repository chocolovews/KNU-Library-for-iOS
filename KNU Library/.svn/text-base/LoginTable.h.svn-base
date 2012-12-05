//
//  LoginTable.h
//  KNU Library
//
//  Created by apple04 on 12. 5. 16..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTable : UITableViewController
{
    UIBarButtonItem *loginbar;
    NSMutableData *receivedData;
}

- (IBAction)loginbarClicked:(id)sender;

@property (nonatomic, retain) IBOutlet UIBarButtonItem* loginbar;
@property (nonatomic, retain) NSMutableData* receivedData;
@property (nonatomic, strong) NSString *cookie;
@property (nonatomic, strong) NSString *htmlString;
@property (strong, nonatomic) NSMutableArray *loginList;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)Response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)postData;
- (void)connectionDidFinishLoading:(NSURLConnection *)conn;
@end
