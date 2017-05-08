# CHLTextViewLImitNum
限制UITextView的输入字数(支持中文和英文)以及提醒内容

下面的截图限制字数在5，中英文都算一个字

![](http://upload-images.jianshu.io/upload_images/3134371-679f0dafbdba89d7.gif?imageMogr2/auto-orient/strip)


##使用指南
添加为子View

```
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
        _inputTextView.placeholder = @"战队简介文字输入不超过5个字";
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
```
判断最大长度需要实现如下代码

```
#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    return [self.inputTextView textView:textView shouldChangeTextInRange:range replacementText:text];
    
}
```
