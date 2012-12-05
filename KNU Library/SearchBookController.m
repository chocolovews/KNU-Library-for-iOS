//
//  FirstViewController.m
//  KNU Library
//
//  Created by KIM WOOSUNG on 12. 3. 31..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//
// ** update log
// (12. 05. 17) html 문자열 파싱 함수 작성 시작.
#import "SearchBookController.h"
#import "SearchedBookInfo.h"
#import "BookSearchDetailController.h"

@interface SearchBookController ()

@end

@implementation SearchBookController

@synthesize bookHistoryList;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
   
	// Do any additional setup after loading the view, typically from a nib.
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
//    [searchBar sizeToFit];
//    [searchBar setKeyboardType:UIKeyboardTypeDefault];
//    self.navigationItem.titleView = self.searchBar;
    // searchBar 색 기본과 같이 맞추고 싶다.

    // 검색 결과 저장을 위한 가변 크기의 배열 선언
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 편집 버튼 만들기
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = @"편집";
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    // 영구 저장된 도서 히스토리 불러오기
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *bookHistoryData = [userDefaults valueForKey:@BOOK_HISTORY_FILENAME];
    if (bookHistoryData) {
        self.bookHistoryList = [NSKeyedUnarchiver unarchiveObjectWithData:bookHistoryData];
    }else{
        self.bookHistoryList = [NSMutableArray array];
    }
    [self.tableView reloadData];
    
//    UINavigationBar *bar = [self.navigationController navigationBar];
//    [bar setTintColor: [UIColor colorWithRed:219/255.0 green:35/255.0 blue:38/255.0 alpha:1]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    return [self.bookHistoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"historyBookCell";
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    SearchedBookInfo *bookInfo = [self.bookHistoryList objectAtIndex:[indexPath row]];
    
    if( cell == nil ){  
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: CellIdentifier];
    }
    
    cell.textLabel.text = bookInfo.bookName;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"도서 검색 히스토리";
    }    
    return nil;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
 


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.bookHistoryList removeObjectAtIndex:indexPath.row];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *bookHistoryData = [NSKeyedArchiver archivedDataWithRootObject:self.bookHistoryList];
        [userDefaults setValue:bookHistoryData forKey:@BOOK_HISTORY_FILENAME];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    BookSearchDetailController *bookDetailController = [storyBoard instantiateViewControllerWithIdentifier:@"bookSearchDetailController"];
    
    // 선택한 도서의 자세한 정보 넘기기
    bookDetailController.bookCNum = [ [self.bookHistoryList objectAtIndex:[indexPath row]] bookCNum ];
    bookDetailController.bookName = [ [self.bookHistoryList objectAtIndex:[indexPath row]] bookName ];
    bookDetailController.bookAuthor = [ [self.bookHistoryList objectAtIndex:[indexPath row]] bookAuthor ];
    bookDetailController.bookPublisher = [ [self.bookHistoryList objectAtIndex:[indexPath row]] bookPublisher ];
    bookDetailController.bookPubYear = [ [self.bookHistoryList objectAtIndex:[indexPath row]] bookPubYear ];
    bookDetailController.bookCodeForBookDetail = [ [self.bookHistoryList objectAtIndex:[indexPath row]] bookCode ];
    //    NSLog(@"%@", [ [searchResultBookList objectAtIndex:[indexPath row]] bookName]);
    
    // 도서 정보 보여주기(BookSearchDetailController으로 넘어가기)
    [self.navigationController pushViewController:bookDetailController animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	[self.tableView setEditing:editing animated:animated];
}

#pragma mark - UISearchBar Delegate Methods 

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    //    SearchBookResultController *sbrc = [[SearchBookResultController alloc] init];
    SearchBookResultController *sbrc = [storyBoard instantiateViewControllerWithIdentifier:@"searchBookResultController"];
    sbrc.delegate = self;

    NSString *rawSearchKeywordString = [NSString stringWithString:searchBar.text];
    sbrc.searchKeyword = [rawSearchKeywordString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSLog(@"%@", sbrc.searchKeyword);
    
    [self.navigationController pushViewController:sbrc animated:YES];
}

	

#pragma mark - SearchBookResultController Delegate

- (void)SearchBookResultControllerDidShowBookSearchDetail:(SearchedBookInfo *)searchedBookInfo {
    
    // 기존에 방금 입력한 책이 없을 때만 넣어주자.
    BOOL isThereASearchedBook = NO;
    
    // 기존 책들을 검사
    for (SearchedBookInfo *historyBookInfo in self.bookHistoryList) {
        if ([historyBookInfo.bookName isEqualToString:searchedBookInfo.bookName]) {
            isThereASearchedBook = YES;
        }
    }
    
    if (isThereASearchedBook == NO) {
        [self.bookHistoryList insertObject:searchedBookInfo atIndex:0];
//        [self.bookHistoryList addObject:searchedBookInfo];
        [self.tableView reloadData];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *bookHistoryData = [NSKeyedArchiver archivedDataWithRootObject:self.bookHistoryList];
        [userDefaults setValue:bookHistoryData forKey:@BOOK_HISTORY_FILENAME];
    }
}

@end