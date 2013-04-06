//
//  BKMenuViewController.m
//  Blink
//
//  Created by Wei Ping on 13/2/7.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKMenuViewController.h"
#import "BKShopDetailViewController.h"
#import "BKMenuItem.h"
#import "UIViewController+BKBaseViewController.h"
#import "UIImage+Resize.h"

@interface BKMenuViewController ()

- (NSString *)stringForPriceFromMenuItem:(BKMenuItem *)item;
- (NSString *)currencyStringForPrice:(NSNumber *)price;

- (UIImage *)defaultPicture;

@property (strong, nonatomic) NSMutableArray *picImageArray; // Retain strong pointer to keep image alive

@end

@implementation BKMenuViewController

@synthesize menu = _menu;

- (NSMutableArray *)picImageArray {
    if (_picImageArray == nil) {
        _picImageArray = [NSMutableArray array];
    }
    return _picImageArray;
}

- (UIImage *)defaultPicture {
    static UIImage *pic;
    if (pic == nil) {
        pic = [UIImage imageNamed:@"picture"];
    }
    return pic;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = ((BKShopDetailViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2]).homeButton;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_small"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableview:%@",tableView);
    static NSString *CellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BKMenuItem *item = [self.menu objectAtIndex:indexPath.row];
    
    UILabel *itemNameLabel = (UILabel *)[cell viewWithTag:1];
    itemNameLabel.text = item.name;
    
    //NSLog(@"cell.imageView.contentMode = %d", cell.imageView.contentMode);
    cell.imageView.image = [self defaultPicture];
    
    if (item.picImage == nil) {
        NSLog(@"Downloading pic image");
        NSURLRequest *request = [NSURLRequest requestWithURL:item.picURL];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            UIImage *itemPic = [UIImage imageWithData:data];
            if (itemPic != nil) {                
                itemPic = [UIImage imageWithImage:itemPic scaledToSize:cell.imageView.frame.size];
                NSLog(@"item pic = %@, size = %@", itemPic, NSStringFromCGSize(itemPic.size));
                [self.picImageArray addObject:itemPic];
                item.picImage = itemPic;
                UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
                theCell.imageView.image = itemPic;
            }            
        }];
    }
    else {
        cell.imageView.image = item.picImage;
    }
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:2];
    priceLabel.text = [self stringForPriceFromMenuItem:item];
    
    return cell;
}

- (NSString *)stringForPriceFromMenuItem:(BKMenuItem *)item {
//    NSString *result = @"";
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString *size in item.sizeLevels) {
        [result addObject:[NSString stringWithFormat:@"%@%@", size, [self currencyStringForPrice:[item priceForSize:size]]]];
//        result = [result stringByAppendingFormat:@"%@%@ ", size, [self currencyStringForPrice:[item priceForSize:size]]];
    }
    return [result componentsJoinedByString:@", "];
}

- (NSString *)currencyStringForPrice:(NSNumber *)price {
    static NSNumberFormatter *currencyFormatter;
    
    if (currencyFormatter == nil) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setPositiveFormat:@"¤#,###"];
        NSLocale *twLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hant_TW"];
        [currencyFormatter setLocale:twLocale];
        [currencyFormatter setCurrencySymbol:@"$"];
        //        NSLog(@"positive format: %@", [currencyFormatter positiveFormat]);
    }
    
    return [currencyFormatter stringFromNumber:price];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
