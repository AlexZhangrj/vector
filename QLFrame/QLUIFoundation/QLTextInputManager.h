

#import <UIKit/UIKit.h>
//#import "QLBlocks.h"

typedef enum{
    QLInputStateUnknow              = 0,
    QLInputStateShouldBeginEditing  = 1,
    QLInputStateEditing             = 2,
    QLInputStateShouldEndEditing    = 3,
    QLInputStateEndEditing          = 4
}QLInputState;

typedef void (^QLCallBackBlock)(id obj);
typedef void (^QLIntergerChangedCallBackBlock)(NSInteger oldCount, NSInteger newCount);
typedef void (^QLInputStateChangedCallBackBlock)(QLInputState oldState, QLInputState newState);
typedef void (^QLIntergerChangedWithMaxCountCallBackBlock)(NSInteger oldCount, NSInteger newCount, NSInteger maxCount);


@protocol QLTextInputDelegate <NSObject>

@property (nonatomic, copy) QLIntergerChangedCallBackBlock currentCountChangeCallBackBlock;
@property (nonatomic, copy) QLIntergerChangedWithMaxCountCallBackBlock countChanged;
@property (nonatomic, copy) QLCallBackBlock didReturn;
@property (nonatomic, copy) QLInputStateChangedCallBackBlock inputStateChanged;


@property (nonatomic, assign) NSInteger maxInputCount;
@property (nonatomic, assign) NSInteger currentInputCount;
@property (nonatomic, assign) QLInputState inputState;

@property (nonatomic, assign) BOOL maxInputCountLimitary;

- (void)listenerInput:(id<UITextInput>)input;

@end



@interface QLTextInputManager : NSObject

//- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount;
//- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount currentLengthDidChanged:(QLIntergerChangedCallBackBlock)callBackBlock;
//- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount countChanged:(QLIntergerChangedWithMaxCountCallBackBlock)countChanged;

- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount countChanged:(QLIntergerChangedWithMaxCountCallBackBlock)countChanged didReturn:(QLCallBackBlock)didReturn inputStateChanged:(QLInputStateChangedCallBackBlock)inputStateChanged;

- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount currentCountChangeCallBackBlock:(QLIntergerChangedCallBackBlock)currentCountChangeCallBackBlock countChanged:(QLIntergerChangedWithMaxCountCallBackBlock)countChanged didReturn:(QLCallBackBlock)didReturn inputStateChanged:(QLInputStateChangedCallBackBlock)inputStateChanged;


- (void)registTextInput:(id<UITextInput>)textInput maxInputLength:(NSInteger)maxCount currentCountChangeCallBackBlock:(QLIntergerChangedCallBackBlock)currentCountChangeCallBackBlock countChanged:(QLIntergerChangedWithMaxCountCallBackBlock)countChanged didReturn:(QLCallBackBlock)didReturn inputStateChanged:(QLInputStateChangedCallBackBlock)inputStateChanged maxInputCountLimitary:(BOOL)maxInputCountLimitary;

- (void)cancelTextInput:(id<UITextInput>)textInput;

+ (QLTextInputManager *)share;

@end

@interface QLTextInputDelegate : NSObject<UITextFieldDelegate, UITextViewDelegate, QLTextInputDelegate>

@property (nonatomic, copy) QLIntergerChangedCallBackBlock currentCountChangeCallBackBlock;
@property (nonatomic, copy) QLIntergerChangedWithMaxCountCallBackBlock countChanged;
@property (nonatomic, copy) QLInputStateChangedCallBackBlock inputStateChanged;

@property (nonatomic, copy) QLCallBackBlock didReturn;

@property (nonatomic, assign) NSInteger maxInputCount;
@property (nonatomic, assign) NSInteger currentInputCount;
@property (nonatomic, assign) QLInputState inputState;
@property (nonatomic, assign) BOOL maxInputCountLimitary;

- (void)listenerInput:(id<UITextInput>)input;

@end


@interface QLTextFieldInputDelegate : QLTextInputDelegate


- (void)listenerInput:(id<UITextInput>)input;


@end

@interface QLTextViewInputDelegate : QLTextInputDelegate


- (void)listenerInput:(id<UITextInput>)input;

@end