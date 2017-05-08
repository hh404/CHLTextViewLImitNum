//
//  ViewController.m
//  CHLTextViewLimitNum
//
//  Created by huochaihy on 2016/11/14.
//  Copyright © 2016年 CHLdemo.com. All rights reserved.
//

#import "ViewController.h"
#import "PlaceholderTextView.h"

/**< 颜色 */
#define GET_COLOR(hexColor) COLOR_ALPHA(hexColor,1.0)

#define COLOR_ALPHA(hexColor,a) [UIColor colorWithRed:(strtoul([hexColor substringWithRange:NSMakeRange(0, 2)].UTF8String, 0, 16)/255.0f) green:(strtoul([hexColor substringWithRange:NSMakeRange(2, 2)].UTF8String, 0, 16)/255.0f) blue:(strtoul([hexColor substringWithRange:NSMakeRange(4, 2)].UTF8String, 0, 16)/255.0f) alpha:a]

#define MAX_LIMIT_NUMS 10

@interface ViewController ()<UITextViewDelegate>

@property(nonatomic,strong)PlaceholderTextView * inputTextView;

@end

@implementation ViewController


-(UITextView *)inputTextView{
    if (!_inputTextView) {
        _inputTextView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(40, 100, 300, 100)];
        _inputTextView.layer.borderColor = GET_COLOR(@"8bb9ec").CGColor;
        _inputTextView.layer.borderWidth = 1;
        _inputTextView.layer.cornerRadius = 4;
        _inputTextView.backgroundColor = COLOR_ALPHA(@"8bb9ec", 0.2);
        _inputTextView.textColor = [UIColor blackColor];
        _inputTextView.font = [UIFont systemFontOfSize:15];
        _inputTextView.delegate = self;
        _inputTextView.placeholder = @"战队简介文字输入不超过10字";
        _inputTextView.placeholderColor = GET_COLOR(@"a1bee1");
        _inputTextView.maxLength = 5;
    }
    return _inputTextView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.inputTextView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    return [self.inputTextView textView:textView shouldChangeTextInRange:range replacementText:text];
    
}


@end
