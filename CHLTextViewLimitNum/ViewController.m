//
//  ViewController.m
//  CHLTextViewLimitNum
//
//  Created by huochaihy on 2016/11/14.
//  Copyright © 2016年 CHLdemo.com. All rights reserved.
//

#import "ViewController.h"
#import "TextViewPlaceholder.h"

/**< 颜色 */
#define GET_COLOR(hexColor) COLOR_ALPHA(hexColor,1.0)

#define COLOR_ALPHA(hexColor,a) [UIColor colorWithRed:(strtoul([hexColor substringWithRange:NSMakeRange(0, 2)].UTF8String, 0, 16)/255.0f) green:(strtoul([hexColor substringWithRange:NSMakeRange(2, 2)].UTF8String, 0, 16)/255.0f) blue:(strtoul([hexColor substringWithRange:NSMakeRange(4, 2)].UTF8String, 0, 16)/255.0f) alpha:a]

#define MAX_LIMIT_NUMS 10

@interface ViewController ()<UITextViewDelegate>

@property(nonatomic,strong)TextViewPlaceholder * inputTextView;

@end

@implementation ViewController


-(UITextView *)inputTextView{
    if (!_inputTextView) {
        _inputTextView = [[TextViewPlaceholder alloc]initWithFrame:CGRectMake(0, 100, 300, 100)];
        _inputTextView.layer.borderColor = GET_COLOR(@"8bb9ec").CGColor;
        _inputTextView.layer.borderWidth = 1;
        _inputTextView.layer.cornerRadius = 4;
        _inputTextView.backgroundColor = COLOR_ALPHA(@"8bb9ec", 0.2);
        _inputTextView.textColor = GET_COLOR(@"a1bee1");
        _inputTextView.font = [UIFont systemFontOfSize:15];
        _inputTextView.delegate = self;
        _inputTextView.placeholder = @"战队简介文字输入不超过50字";
        _inputTextView.placeholderColor = GET_COLOR(@"a1bee1");
    }
    return _inputTextView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
}
@end
