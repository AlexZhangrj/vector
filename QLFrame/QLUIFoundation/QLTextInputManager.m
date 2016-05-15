
#import "QLTextInputManager.h"
#import "QLStringAPI.h"
#import "QLStringAPI+QLUIFoundation.h"



@interface QLTextInputManager ()

@property (nonatomic, strong) NSMutableDictionary * delegateRegisterList;


@end
@implementation QLTextInputManager

static QLTextInputManager * __shared;
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegateRegisterList = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount countChanged:(QLIntergerChangedWithMaxCountCallBackBlock)countChanged didReturn:(QLCallBackBlock)didReturn inputStateChanged:(QLInputStateChangedCallBackBlock)inputStateChanged
{
//    id<UITextFieldDelegate, UITextViewDelegate, QLTextInputDelegate> delegate;
//    if ([textInput isKindOfClass:[UITextField class]]) {
//        delegate = [[QLTextFieldInputDelegate alloc]init];
//    }else if ([textInput isKindOfClass:[UITextView class]]){
//        delegate = [[QLTextViewInputDelegate alloc]init];
//    }
//    [delegate setMaxInputCount:maxCount];
//    [delegate setCountChanged:countChanged];
//    [delegate setDidReturn:didReturn];
//    [delegate setInputStateChanged:inputStateChanged];
//    
//    [delegate listenerInput:textInput];
//    
//    [self.delegateRegisterList setObject:delegate forKey:[QLStringTool addressOfObject2String:textInput]];
    
    [self registTextInput:textInput maxInputLength:maxCount currentCountChangeCallBackBlock:nil countChanged:countChanged didReturn:didReturn inputStateChanged:inputStateChanged maxInputCountLimitary:NO];

}

- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount currentCountChangeCallBackBlock:(QLIntergerChangedCallBackBlock)currentCountChangeCallBackBlock countChanged:(QLIntergerChangedWithMaxCountCallBackBlock)countChanged didReturn:(QLCallBackBlock)didReturn inputStateChanged:(QLInputStateChangedCallBackBlock)inputStateChanged
{
    [self registTextInput:textInput maxInputLength:maxCount currentCountChangeCallBackBlock:currentCountChangeCallBackBlock countChanged:countChanged didReturn:didReturn inputStateChanged:inputStateChanged maxInputCountLimitary:NO];
}

- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount currentCountChangeCallBackBlock:(QLIntergerChangedCallBackBlock)currentCountChangeCallBackBlock countChanged:(QLIntergerChangedWithMaxCountCallBackBlock)countChanged didReturn:(QLCallBackBlock)didReturn inputStateChanged:(QLInputStateChangedCallBackBlock)inputStateChanged maxInputCountLimitary:(BOOL)maxInputCountLimitary
{
    id<UITextFieldDelegate, UITextViewDelegate, QLTextInputDelegate> delegate;
    if ([textInput isKindOfClass:[UITextField class]]) {
        delegate = [[QLTextFieldInputDelegate alloc]init];
    }else if ([textInput isKindOfClass:[UITextView class]]){
        delegate = [[QLTextViewInputDelegate alloc]init];
    }
    [delegate setMaxInputCount:maxCount];
    [delegate setCountChanged:countChanged];
    [delegate setCurrentCountChangeCallBackBlock:currentCountChangeCallBackBlock];
    [delegate setDidReturn:didReturn];
    [delegate setInputStateChanged:inputStateChanged];
    
    [delegate listenerInput:textInput];
    [delegate setMaxInputCountLimitary:maxInputCountLimitary];
    
    [self.delegateRegisterList setObject:delegate forKey:[QLStringAPI addressOfObject2String:textInput]];
}


//- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount
//{
//    id<UITextFieldDelegate, UITextViewDelegate, QLTextInputDelegate> delegate;
//    if ([textInput isKindOfClass:[UITextField class]]) {
//        delegate = [[QLTextFieldInputDelegate alloc]init];
//    }else if ([textInput isKindOfClass:[UITextView class]]){
//        delegate = [[QLTextViewInputDelegate alloc]init];
//    }
//    [delegate setMaxInputCount:maxCount];
//    [delegate listenerInput:textInput];
//    
//    [self.delegateRegisterList setObject:delegate forKey:[QLStringTool addressOfObject2String:textInput]];
//}
//
//- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount currentLengthDidChanged:(QLIntergerChangedCallBackBlock)callBackBlock;
//{
//    id<UITextFieldDelegate, UITextViewDelegate, QLTextInputDelegate> delegate;
//    if ([textInput isKindOfClass:[UITextField class]]) {
//        delegate = [[QLTextFieldInputDelegate alloc]init];
//    }else if ([textInput isKindOfClass:[UITextView class]]){
//        delegate = [[QLTextViewInputDelegate alloc]init];
//    }
//    [delegate setMaxInputCount:maxCount];
//    [delegate setCurrentCountChangeCallBackBlock:callBackBlock];
//    [delegate listenerInput:textInput];
//    
//    [self.delegateRegisterList setObject:delegate forKey:[QLStringTool addressOfObject2String:textInput]];
//}
//
//- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount countChanged:(QLIntergerChangedWithMaxCountCallBackBlock)countChanged
//{
//    id<UITextFieldDelegate, UITextViewDelegate, QLTextInputDelegate> delegate;
//    if ([textInput isKindOfClass:[UITextField class]]) {
//        delegate = [[QLTextFieldInputDelegate alloc]init];
//    }else if ([textInput isKindOfClass:[UITextView class]]){
//        delegate = [[QLTextViewInputDelegate alloc]init];
//    }
//    [delegate setMaxInputCount:maxCount];
//    [delegate setCountChanged:countChanged];
//    [delegate listenerInput:textInput];
//    
//    [self.delegateRegisterList setObject:delegate forKey:[QLStringTool addressOfObject2String:textInput]];
//}


- (void)cancelTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount
{
    [self.delegateRegisterList removeObjectForKey:[QLStringAPI addressOfObject2String:textInput]];
}

+ (QLTextInputManager *)share
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (nil == __shared) {
            __shared = [[QLTextInputManager alloc]init];
        }
    });
    return __shared;
}





@end



@implementation QLTextInputDelegate

- (void)setCurrentInputCount:(NSInteger)currentInputCount
{
    if (currentInputCount != _currentInputCount) {
        NSInteger old = _currentInputCount;
        _currentInputCount = currentInputCount;
        if (self.currentCountChangeCallBackBlock) {
            self.currentCountChangeCallBackBlock(old, currentInputCount);
        }
        
        if (self.countChanged) {
            self.countChanged(old, currentInputCount, self.maxInputCount);
        }
    }
}

- (void)setInputState:(QLInputState)inputState
{
    if (inputState != _inputState) {
        QLInputState old = _inputState;
        _inputState = inputState;
        if (self.inputStateChanged) {
            self.inputStateChanged(old, inputState);
        }
    }
}

- (void)listenerInput:(id<UITextInput>)input
{
}

@end

@interface QLTextFieldInputDelegate ()

@property (nonatomic, assign) BOOL isReplaceRange;

@end

@implementation QLTextFieldInputDelegate


- (void)listenerInput:(id<UITextInput>)input
{
    UITextField * textField = (UITextField * )input;
    textField.delegate = self;
    self.currentInputCount = textField.text.length;
    if ([textField isFirstResponder]) {
        self.inputState = QLInputStateEditing;
    }
}

- (void)textChanged:(NSNotification *)notif
{
    if (!self.isReplaceRange ) {
        if (self.maxInputCountLimitary) {
            UITextField * textField = notif.object;
            if (textField.text.length > self.maxInputCount) {
                textField.text = [textField.text substringToIndex:self.maxInputCount];
            }
        }
    }
    
    self.isReplaceRange = NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.inputState = QLInputStateShouldBeginEditing;
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.inputState = QLInputStateEditing;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.inputState = QLInputStateShouldEndEditing;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.inputState = QLInputStateEndEditing;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSLog(@"%@", textField.text);
//    NSLog(@"%@", NSStringFromRange(range));
//    NSLog(@"%@", string);
//    
//    
//    return YES;
//    
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
//    if ([string isEqualToString:@"\n"]) {
//        if (self.didReturn) {
//            self.didReturn(textField);
//            return NO;
//        }else {
//            return YES;
//        }
//    }
    self.isReplaceRange = YES;
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (toBeString.length > self.maxInputCount && self.maxInputCountLimitary) {
        return NO;
    }else {
        self.currentInputCount = toBeString.length;
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.didReturn) {
        self.didReturn(textField);
    }
    return YES;
}

@end

@interface QLTextViewInputDelegate ()
@property (nonatomic, assign) BOOL isReplaceRange;


@end

@implementation QLTextViewInputDelegate


- (void)listenerInput:(id<UITextInput>)input
{
    UITextView * textView = (UITextView * )input;
    textView.delegate = self;
    self.currentInputCount = textView.text.length;
    if ([textView isFirstResponder]) {
        self.inputState = QLInputStateEditing;
    }
}


#if 0
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.isReplaceRange = YES;
    if ([text isEqualToString:@""]) {
        self.currentInputCount = range.location;
    }else {
//        if (textView.text.length > self.maxInputCount && text.length > range.length) {
//            return NO;
//        }
    }
    
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
//    if (range.location > self.maxInputCount) {
//        return NO;
//    }else {
        return YES;
//    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (!self.isReplaceRange) {
        if (textView.text.length > self.maxInputCount) {
            textView.text = [textView.text substringToIndex:self.maxInputCount];
        }
        //        self.wordCountLable.text = [NSString stringWithFormat:@"%ld", self.maxInputCount - textView.text.length];
        self.currentInputCount = textView.text.length;
    }
    
    self.isReplaceRange = NO;
}
#endif

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.isReplaceRange = YES;
    
    if ([text isEqualToString:@"\n"]) {
        if (self.didReturn) {
            self.didReturn(textView);
            return NO;
        }
    }
    
    if (self.maxInputCountLimitary) {
        if (range.location + text.length > self.maxInputCount && range.length < text.length) {
            return NO;
        }else {
            return YES;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (!self.isReplaceRange) {
        if (self.maxInputCountLimitary) {
            if(textView.text.length > self.maxInputCount) {
                textView.text = [textView.text substringToIndex:self.maxInputCount];
            }
        }
    }
    self.currentInputCount = textView.text.length;
    self.isReplaceRange = NO;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.inputState = QLInputStateEditing;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.inputState = QLInputStateEndEditing;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.inputState = QLInputStateShouldBeginEditing;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.inputState = QLInputStateShouldEndEditing;
    return YES;
}


@end