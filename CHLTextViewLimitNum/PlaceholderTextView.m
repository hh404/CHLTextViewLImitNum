//
//  TextViewPlaceholder.m
//  YuWan
//
//  Created by huochaihy on 2016/11/10.
//  Copyright © 2016年 changhailuo. All rights reserved.
//

#import "PlaceholderTextView.h"
#import "UIView+Extension.h"
@interface PlaceholderTextView ()
/** 占位文字label */
@property (nonatomic, weak) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *residueLabel;
@end

@implementation PlaceholderTextView

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        // 添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
        
        self.residueLabel = [[UILabel alloc] init];
        self.residueLabel.backgroundColor =[UIColor clearColor];
        self.residueLabel.textAlignment = NSTextAlignmentRight;
        self.residueLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        self.residueLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
        _residueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_residueLabel];
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 垂直方向上永远有弹簧效果
        self.alwaysBounceVertical = YES;
        
        // 默认字体
        self.font = [UIFont systemFontOfSize:15];
        
        // 默认的占位文字颜色
        self.placeholderColor = [UIColor grayColor];
        
        // 监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _residueLabel.y = self.height - 30;
    _residueLabel.x = 12;
    _residueLabel.width= self.width - 24;
    _residueLabel.height = 25;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 监听文字改变
 */
- (void)textDidChange:(NSNotification*)aNo
{
    // 只要有文字, 就隐藏占位文字label
    self.placeholderLabel.hidden = self.hasText;
    if(!aNo)
    {
        return;
    }
    
    UITextView *textView = aNo.object;
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > self.maxLength)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:self.maxLength];
        
        [textView setText:s];
    }
    self.residueLabel.text =[NSString stringWithFormat:@"%tu/%tu",self.maxLength - [textView.text length],_maxLength];
}

/**
 * 更新占位文字的尺寸
 */
- (void)updatePlaceholderLabelSize
{
    CGSize maxSize = CGSizeMake(8+self.frame.size.width - 2 * self.placeholderLabel.x, MAXFLOAT);
    self.placeholderLabel.size = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
}

#pragma mark - 重写setter
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    
    [self updatePlaceholderLabelSize];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    [self updatePlaceholderLabelSize];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange:nil];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange:nil];
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
        
        if (offsetRange.location < self.maxLength) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = self.maxLength - comcatstr.length;
    
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

- (void)setMaxLength:(NSUInteger)maxLength
{
    _maxLength = maxLength;
    self.residueLabel.text =[NSString stringWithFormat:@"%tu/%tu",_maxLength,_maxLength];
}

@end
