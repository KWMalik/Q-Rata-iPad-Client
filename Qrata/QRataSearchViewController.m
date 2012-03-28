//
//  QRataTableViewController.m
//  Qrata
//
//  Created by Samuel Joseph on 3/27/12.
//  Copyright (c) 2012 NeuroGrid Ltd. All rights reserved.
//

#import "QRataSearchViewController.h"
#import "QRataFetcher.h"
#import "QRataResultViewController.h"

@implementation QRataSearchViewController

@synthesize results = _results;
@synthesize tableView = _tableView;
@synthesize searchDisplayController;
@synthesize delegate = _delegate;

-(QRataResultViewController *)splitViewQRataResultViewController{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if(![gvc isKindOfClass:[QRataResultViewController class]]){
        gvc = nil;
    }
    return gvc;
}

-(void)setResults:(NSArray *)results
{
    if(_results != results) {
        _results = results;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
   // UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  //  [spinner startAnimating];
  //  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("qrata downloader", NULL);
    dispatch_async(downloadQueue, ^(void){
        NSArray *results = [QRataFetcher search:searchBar.text];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //self.navigationItem.rightBarButtonItem = nil;
            self.results = results;
            [self.searchDisplayController setActive:NO];
        });
    });
    dispatch_release(downloadQueue);
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("qrata downloader", NULL);
    dispatch_async(downloadQueue, ^(void){
        NSArray *results = [QRataFetcher search:@"test"];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //self.navigationItem.rightBarButtonItem = nil;
            self.results = results;
        });
    });
    dispatch_release(downloadQueue);


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
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
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QRata Result";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *result = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = [result objectForKey:QRATA_NAME];
    cell.detailTextLabel.text = [result objectForKey:QRATA_URL];
   // cell.detailTextLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //CGRect shiftedFrame = cell.detailTextLabel.frame;
    //shiftedFrame.origin.x += 20;
    //shiftedFrame.origin.y += 100;
    //cell.detailTextLabel.frame = shiftedFrame;
    
    
    UILabel *score = (UILabel*)[cell viewWithTag:123];
    if (!score) {
        score = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
        score.tag = 123;
    }
    score.text = [[result objectForKey:QRATA_SCORE] stringValue];
    score.backgroundColor = [UIColor yellowColor];
    score.font = [UIFont fontWithName:@"Cochin" size: 14.0];
    //score.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    score.textAlignment = UITextAlignmentCenter;
    NSString* imagePath = [ [ NSBundle mainBundle] pathForResource:@"dummy" ofType:@"png"];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile: imagePath];
    [cell.imageView addSubview:score];

    return cell;
}

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
    NSDictionary *result = [self.results objectAtIndex:indexPath.row];
    
    NSString *urlString = [@"http://" stringByAppendingString:[result objectForKey:QRATA_URL]];
    //Load the request in the UIWebView.
    QRataResultViewController* q = [self splitViewQRataResultViewController];
    [q loadUrl:urlString];
}

@end
