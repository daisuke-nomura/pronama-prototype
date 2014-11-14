//
//  WallpaperViewController.m
//  pronama
//
//  Created by 野村 大翼 on 12/07/04.
//
//

#import "WallpaperViewController.h"

@interface WallpaperViewController ()

@end

@implementation WallpaperViewController
//@synthesize WallBottomBar;
@synthesize WallNavItem;
@synthesize downloadBtn;
@synthesize scrollView;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 5, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    
    selectedIndex = 0;
    //pageControl.numberOfPages = 0;
    //pageControl.currentPage = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    feedArray = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(global_queue, ^{
        NSURL *url = [[NSURL alloc] initWithString:PRONAMA_WALLPAPER_URL];
        NSError *error;
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url options:NSDataReadingMapped error:&error];
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
        
        if (error) {
            dispatch_async(main_queue, ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }
        
        for (GDataXMLNode *item in [document nodesForXPath:@"//items" error:&error]) {
            for (GDataXMLNode *child in [item children]) {
                [feedArray addObject:[child stringValue]];
            }
        }
        
        
        dispatch_async(main_queue, ^{
            [WallNavItem setTitle:[[NSString alloc] initWithFormat:@"壁紙 (%d/%d)", selectedIndex + 1, [feedArray count]]];;
            
            //スクロールの総範囲
            [scrollView setContentSize:CGSizeMake(([feedArray count] * 320), 460)];
        });
        
        __block CGFloat xOffset = 0;
        
        for (int i = 0; i < [feedArray count]; i++) {
            UIImageView *imageView = NULL;
            NSString *str = [feedArray objectAtIndex:i];
            NSURL *url = [NSURL URLWithString:str];
            UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:url]];
            imageView = [[UIImageView alloc] initWithImage:image];
            
            //ScrollWallpaperViewController *swvc = [[ScrollWallpaperViewController alloc] init];
            
            CGRect rect = imageView.frame;
            rect.size.height = 460;
            rect.size.width = 320;
            imageView.frame = rect;
            imageView.tag = i + 1;
            
            dispatch_async(main_queue, ^{
                [scrollView addSubview:imageView];
                
                CGRect frame = imageView.frame;
                frame.origin = CGPointMake(xOffset, 0);
                imageView.frame = frame;
                
                xOffset += 320;
            });
        }
        
        dispatch_async(main_queue, ^{
//            UIImageView *view = nil;
//            NSArray *subviews = [scrollView subviews];
//            
//            CGFloat curXLoc = 0;
//            for (view in subviews)
//            {
//                if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
//                {
//                    CGRect frame = view.frame;
//                    frame.origin = CGPointMake(curXLoc, 0);
//                    view.frame = frame;
//                    
//                    curXLoc += (320);
//                }
//            }
            
            //pageControl.numberOfPages = [feedArray count];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //[pageControl setNumberOfPages:[feedArray count]];
            //[self.view addSubview:pageControl];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setPageControl:nil];
    [self setScrollView:nil];
    [self setWallNavItem:nil];
    [self setDownloadBtn:nil];
//    [self setWallBottomBar:nil];
    [super viewDidUnload];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    if (fmod(scrollView.contentOffset.x , pageWidth) == 0.0) {
        //pageControl.currentPage = scrollView.contentOffset.x / pageWidth;
        //selectedIndex = pageControl.currentPage;
        
        CGFloat pageWidth = scrollView.frame.size.width;
        selectedIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [WallNavItem setTitle:[[NSString alloc] initWithFormat:@"壁紙 (%d/%d)", selectedIndex + 1, [feedArray count]]];
    }
}
- (IBAction)changePage:(id)sender {
    CGFloat pageWidth = scrollView.frame.size.width;
    pageControl.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    selectedIndex = pageControl.currentPage;
}

- (IBAction)downloadWallpaper:(id)sender {
    UIImageView *imageView = [scrollView.subviews objectAtIndex:selectedIndex];
    UIImage *image = imageView.image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(savingImageIsFinished:didFinishSavingWithError:contextInfo:), nil);
}

- (void) savingImageIsFinished:(UIImage *)_image didFinishSavingWithError:(NSError *)_error contextInfo:(void *)_contextInfo {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"プロ生" message:@"壁紙を保存しました" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)hideBars:(id)sender {
    if (self.navigationController.navigationBar.isHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

@end
