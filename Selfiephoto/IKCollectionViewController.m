//
//    Copyright (c) 2013 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "IKCollectionViewController.h"
#import "InstagramKit.h"
#import "UIImageView+AFNetworking.h"
#import "IKCell.h"
#import "IKActivityCell.h"
#import "InstagramMedia.h"
#import "InstagramUser.h"
#import "IKLoginViewController.h"
#import "IKMediaViewController.h"

#define ITEMS_PAGE_SIZE 33
#define ITEM_CELL_IDENTIFIER @"ItemCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"

@interface IKCollectionViewController ()
{
    NSMutableArray *mediaArray;
    __weak IBOutlet UITextField *textField;
}
@property (nonatomic, strong) InstagramPaginationInfo *currentPaginationInfo;
@end

@implementation IKCollectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        mediaArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMedia];
}

- (void)loadMedia
{
    [textField resignFirstResponder];
    textField.text = @"";

    InstagramEngine *sharedEngine = [InstagramEngine sharedEngine];
    
    if (sharedEngine.accessToken)
    {
        [self testLoadSelfFeed];
    }
}

- (IBAction)searchMedia
{
    self.currentPaginationInfo = nil;
    if (mediaArray) {
        [mediaArray removeAllObjects];
    }
    [textField resignFirstResponder];

    if ([textField.text length]) {
        [self testGetMediaFromTag:textField.text];
    }
}



- (void)getSelfUserDetails
{
    [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:^(InstagramUser *userDetail) {
        NSLog(@"%@",userDetail);
    } failure:^(NSError *error) {
        
    }];
}


- (void)testLoadSelfFeed
{
    textField.text = @"selfie";
    [self searchMedia];
}

- (void)testSearchUsersWithString:(NSString *)string
{
    [[InstagramEngine sharedEngine] searchUsersWithString:string withSuccess:^(NSArray *users, InstagramPaginationInfo *paginationInfo) {
        NSLog(@"%ld users found", (long)users.count);
    } failure:^(NSError *error) {
        NSLog(@"user search failed");
    }];
}

- (void)testGetMediaFromTag:(NSString *)tag
{
    [[InstagramEngine sharedEngine] getMediaWithTagName:tag count:33 maxId:self.currentPaginationInfo.nextMaxId withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        self.currentPaginationInfo = paginationInfo;
        [mediaArray addObjectsFromArray:media];
        [self reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"Search Media Failed");
    }];
}

- (void)testPaginationRequest:(InstagramPaginationInfo *)pInfo
{
    [[InstagramEngine sharedEngine] getPaginatedItemsForInfo:self.currentPaginationInfo withSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
        NSLog(@"%ld more media in Pagination",(unsigned long)media.count);
        self.currentPaginationInfo = paginationInfo;
        [mediaArray addObjectsFromArray:media];
        [self reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"Pagination Failed");
    }];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue.media.detail"]) {
        IKMediaViewController *mvc = (IKMediaViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathsForSelectedItems][0];
        InstagramMedia *media = mediaArray[selectedIndexPath.item];
        mvc.media = media;
    }
    if ([segue.identifier isEqualToString:@"segue.login"]) {
        UINavigationController *loginNavigationVC = (UINavigationController *)segue.destinationViewController;
        IKLoginViewController *loginVc = loginNavigationVC.viewControllers[0];
        loginVc.collectionViewController = self;
    }
}

#pragma mark - UICollectionViewDelegate -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mediaArray.count+1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item < mediaArray.count) {
        return [self itemCellForIndexPath:indexPath andCollectionView:collectionView];
    } else {
        if (self.currentPaginationInfo)
        {
            [self fetchMoreItems];
            return [self loadingCellForIndexPath:indexPath andCollectionView:collectionView];
        }
        else{
        IKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPCELL" forIndexPath:indexPath];
        [cell.imageView setImage:nil];
        return cell;
        }

    }
}

- (UICollectionViewCell *)itemCellForIndexPath:(NSIndexPath *)indexPath andCollectionView:(UICollectionView *)collectionView{
    
    IKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPCELL" forIndexPath:indexPath];
    
    if (mediaArray.count >= indexPath.row+1) {
        InstagramMedia *media = mediaArray[indexPath.row];
        [cell.imageView setImageWithURL:media.thumbnailURL];
    }
    else
        [cell.imageView setImage:nil];
    return cell;

}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath andCollectionView:(UICollectionView *)collectionView{
    
    IKActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ACTIVITYCELL" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


- (void)fetchMoreItems {
    
[self testPaginationRequest:self.currentPaginationInfo];

}
#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)tField
{
    if (tField.text.length) {
        [self searchMedia];
    }
    [tField resignFirstResponder];

    return YES;
}

@end
