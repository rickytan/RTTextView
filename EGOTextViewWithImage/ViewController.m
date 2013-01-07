//
//  ViewController.m
//  EGOTextViewWithImage
//
//  Created by ricky on 12-11-30.
//  Copyright (c) 2012年 ricky. All rights reserved.
//

#import "ViewController.h"
#import "EGOTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc
{
    [_egotextView release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    _egotextView = [[EGOTextView alloc] initWithFrame:self.view.bounds];
    NSMutableDictionary *emotions = [NSMutableDictionary dictionaryWithCapacity:12];
    for (int i=1; i<=12; ++i) {
        NSString *s = [NSString stringWithFormat:@"em%02d",i];
        [emotions setValue:[s stringByAppendingPathExtension:@"gif"]
                    forKey:s];
    }
    _egotextView.textImageMapping = [NSDictionary dictionaryWithDictionary:emotions];
    _egotextView.leftDelimiter = @"\\[";
    _egotextView.rightDelimiter = @"\\]";
    [self.view addSubview:_egotextView];
    
    _emotionInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
    _emotionInputView.backgroundColor = [UIColor lightGrayColor];
    CGFloat w = 320.0/4, h = 220.0/3;
    CGFloat offx = w/2, offy = h/2;
    for (int r=0; r<3; r++) {
        for (int c=0; c<4; c++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *bgimg = [UIImage imageNamed:[NSString stringWithFormat:@"em%02d.gif",r*4+c+1]];
            btn.tag = r*4+c+1;
            btn.frame = (CGRect){{0,0},bgimg.size};
            btn.center = CGPointMake(offx + w*c, offy + h*r);
            [btn setBackgroundImage:bgimg
                           forState:UIControlStateNormal];
            [_emotionInputView addSubview:btn];
            
            [btn addTarget:self
                    action:@selector(onInsertEmotion:)
          forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"表情"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(onLeftItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onInsertEmotion:(UIButton*)button
{
    NSString *emotionString = [NSString stringWithFormat:@"[em%02d]",button.tag];
    [_egotextView insertText:emotionString];
}

- (void)onLeftItem:(id)sender
{
    static BOOL isEmotion = NO;
    isEmotion = !isEmotion;
    if (isEmotion) {
        [(UIBarButtonItem*)sender setTitle:@"文字"];
        [_egotextView resignFirstResponder];
        _egotextView.inputView = _emotionInputView;
        [_egotextView becomeFirstResponder];
    }
    else {
        [(UIBarButtonItem*)sender setTitle:@"表情"];
        [_egotextView resignFirstResponder];
        _egotextView.inputView = nil;
        [_egotextView becomeFirstResponder];
    }
}

@end
