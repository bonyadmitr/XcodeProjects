//
//  TableViewController.m
//  NetworkingObjC
//
//  Created by Bondar Yaroslav on 12.11.16.
//  Copyright © 2016 Bondar Yaroslav. All rights reserved.
//

#import "TableViewController.h"
#import "Post.h"
#import "PostClient.h"
#import "PostsStorage.h"
#import "PostCell.h"
#import "UITableView+Extensions.h"
#import "ViewController.h"

#warning rename to PostsController
@interface TableViewController ()
@property (strong, nonatomic) NSArray<Post *> *posts;
@end

@implementation TableViewController

static NSString * const postSegueId = @"post";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPosts];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:postSegueId]) {
        ViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        vc.post = self.posts[indexPath.row];
    }
}

- (void)loadPosts {
    [[PostsStorage sharedInstance] getAll].then(^(NSArray *posts){
        self.posts = posts;
        [self.tableView reloadData];
        return [[PostClient sharedInstance] getAll];
    }).then(^(NSArray *array){
        return [[PostsStorage sharedInstance] createOrUpdateFrom:array];
    }).then(^(NSArray *posts){
        self.posts = posts;
        [self.tableView reloadData];
    }).catch(^(NSError *error){
        NSLog(@"Error: %@", error);
    });
}

// we can get out code of table view to another class
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusable:[PostCell class] forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    [cell fillWith:post];
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:postSegueId sender:indexPath];
}

@end
