//
//  ViewController.m
//  Cathay
//
//  Created by Nic on 2018/11/14.
//  Copyright © 2018 Nic. All rights reserved.
//

#import "ViewController.h"
#import "CathayTableViewCell.h"
#import "CathayAnimal.h"
#import "CathayHTTPClient.h"

static NSString * const APIURL = @"https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613&limit=30&offset=%lu";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navBar;
@property (nonatomic) BOOL bottomRefresh;
@property (strong, nonatomic) NSMutableArray *animals;
@property (strong, nonatomic) NSCache *imageCache;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;

@end

@implementation ViewController{
  CGFloat fullBarHeight;
  CGFloat shyBarHeight;
  CGFloat snapHeight;
  NSUInteger *offset;
  BOOL snapToFull;
  BOOL snapToShy;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    self.animals = [NSMutableArray array];
    self.imageCache = [[NSCache alloc] init];
    snapHeight = shyBarHeight + ((128.0f - 64.0f)/2);
    fullBarHeight = 128.0f;
    shyBarHeight = 64.0f;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.bounces = NO;
  [self fetchAnimalsData:0];
}

- (void) fetchAnimalsData:(NSUInteger)offset{
  
  __block NSArray *animals = [NSArray array];
  NSString *dataUrl = [NSString stringWithFormat:APIURL, (unsigned long)offset];
  __weak ViewController *weakSelf = self;

  [[CathayHTTPClient sharedInstance] fetchAnimalData:dataUrl completion:^(BOOL success, id  _Nonnull responseObject) {
    if (success) {
       animals = (NSArray*) responseObject[@"result"][@"results"];
      [self.animals addObjectsFromArray:[CathayAnimal insertJsonIntoAnimals:animals]];
      [self.tableView reloadData];
      weakSelf.bottomRefresh = NO;
    } else {
      NSLog(@"error");
    }
  }];
}

- (void)viewDidLayoutSubviews {
  [self.tableView setContentInset:UIEdgeInsetsMake(fullBarHeight, 0, 0, 0)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  // calcu alpha
  CGFloat totalScroll = fullBarHeight - shyBarHeight;
  CGFloat range = self.tableView.contentOffset.y + shyBarHeight; // set - 128
  CGFloat alpha = -range/totalScroll;
  self.navTitle.alpha = alpha;
  
  // limit upward scroll range and resize nav bar
  CGFloat offset = self.tableView.contentOffset.y;
  if (offset > -shyBarHeight) {
     [self setNavBarHeight:shyBarHeight];
     return;
  }
  [self setNavBarHeight:-offset];
  
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

}

- (void) setNavBarHeight: (CGFloat)height {
  
  self.navBar.frame = CGRectMake(self.navBar.frame.origin.x,
                                 self.navBar.frame.origin.y,
                                 self.navBar.frame.size.width,
                                 height);
  
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

  static NSString *cellIdentifier = @"CathayCell";

  CathayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
  CathayAnimal *animal = self.animals[indexPath.row];
  cell.aniNameLabel.text = animal.name;
  cell.aniBehavior.text = animal.behavior;
  cell.aniLocation.text = animal.location;
  [self loadImage:animal.imageURL cell:cell];

  return cell;
}

- (void) loadImage:(nonnull NSString *)imageUrl cell:(CathayTableViewCell *)cell {

  // two exceptions 1: no pic url 2. url with empty pic
  if ([imageUrl isEqualToString:@""]) {
    return;
  }
  
  if ([self.imageCache objectForKey:imageUrl] != nil) {
    NSLog(@"loadfromCache");
    cell.aniImageView.image = [self.imageCache objectForKey:imageUrl];
    return;
  }
  
  [[CathayHTTPClient sharedInstance] fetchImage:imageUrl completion:^(BOOL success, id  responseObject) {
    if (success) {
      UIImage *image = [UIImage imageWithData:responseObject];
      if (image != nil){
        [self.imageCache setObject:image forKey:imageUrl];
      }
      cell.aniImageView.image =image;
    }
  }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.animals.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == self.animals.count - 1 && self.bottomRefresh == NO) {
    self.bottomRefresh = YES;
    [self fetchAnimalsData:self.animals.count];
  }
}

/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
   if (scrollView == self.tableView) {
   CGFloat offset = self.tableView.contentOffset.y;
   
   if (offset > -snapHeight) {
   [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
   }else if (offset < -snapHeight) {
   [self.tableView setContentInset:UIEdgeInsetsMake(128, 0, 0, 0)];
   }
 
}
*/
/*
 - (void)retrieveAnimalData:(NSUInteger)offset  {
 
 NSString *dataUrl = [NSString stringWithFormat:APIURL, (unsigned long)offset];
 NSURL *url = [NSURL URLWithString:dataUrl];
 
 
 
 __block NSArray *animals = [NSArray array];
 
 __weak ViewController *weakSelf = self;
 NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
 dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
 
 if (!error) {
 // Success
 if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
 NSError *jsonError;
 NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
 if (jsonError) {
 
 } else {
 
 animals = (NSArray*) responseObject[@"result"][@"results"];
 [self.animals addObjectsFromArray:[CathayAnimal insertJsonIntoAnimals:animals]];
 dispatch_async(dispatch_get_main_queue(), ^{
 [self.tableView reloadData];
 weakSelf.bottomRefresh = NO;
 });
 }
 }  else {
 //Web server is returning an error
 }
 } else {
 // Fail
 NSLog(@"error : %@", error.description);
 }
 }];
 [downloadTask resume];
 }
 
 - (void) loadImage:(nonnull NSString *)imageUrl cell:(CathayTableViewCell *)cell {
 NSLog(@"%@", imageUrl);
 if ([self.imageCache objectForKey:imageUrl] != nil) {
 NSLog(@"loadfromCache");
 cell.aniImageView.image = [self.imageCache objectForKey:imageUrl];
 return;
 }
 
 [[CathayHTTPClient sharedInstance]  fetchImage:imageUrl completion:^(BOOL success, id  _Nonnull responseObject) {
 if (success) {
 UIImage *image = [UIImage imageWithData:responseObject];
 if (image != nil){
 [self.imageCache setObject:image forKey:imageUrl];
 }
 cell.aniImageView.image =image;
 }
 }];
 }
 
 
 - (void) loadImage:(nonnull NSString *)imageUrl cell:(CathayTableViewCell *)cell {
 NSLog(@"%@", imageUrl);
 if ([self.imageCache objectForKey:imageUrl] != nil) {
 NSLog(@"loadfromCache");
 cell.aniImageView.image = [self.imageCache objectForKey:imageUrl];
 return;
 }
 
 NSURL *url = [NSURL URLWithString:imageUrl];
 NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 if (data) {
 UIImage *image = [UIImage imageWithData:data];
 if (image) {
 dispatch_async(dispatch_get_main_queue(), ^{
 if (image == nil ) {
 NSLog(@"image nil");
 } else {
 [self.imageCache setObject:image forKey:imageUrl];
 cell.aniImageView.image =image;
 }
 });
 }
 }
 }];
 [task resume];
 
 
 
 // when bar pin to fullHeight
 //  if (scrollView == self.tableView) {
 //
 //    // pull under BarHeight // < -128
 //    if (offset < -fullBarHeight) {
 //       [self setNavBarHeight:fullBarHeight];
 //      return;
 //    }
 // push over shyBarHeight // > -64     -128 < x < -64
 
 
 //  } else {
 //
 //   // when bar pin to shtHeight
 //    // push over shyBarHeight //
 //    if (offset < -shyBarHeight) {
 //      [self setNavBarHeight:shyBarHeight];
 //      return;
 //    }
 //
 
 
 
 //   }
 
 
 
 }*/
 



@end
