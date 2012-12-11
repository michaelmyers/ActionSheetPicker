//
//  ActionSheetMultiColumnStringPicker.h
//  ActionSheetPicker
//
//  Created by YuAo on 12/11/12.
//
//

#import "AbstractActionSheetPicker.h"
@class ActionSheetMultiColumnStringPicker;
typedef void(^ActionMultiColumnStringDoneBlock)(ActionSheetMultiColumnStringPicker *picker, NSArray *selectedItems);
typedef void(^ActionMultiColumnStringCancelBlock)(ActionSheetMultiColumnStringPicker *picker);


@protocol ActionSheetMultiColumnStringPickerItem <NSObject>
- (NSString *)title;
//The item in this array must also confirm to ActionSheetMultiColumnStringPickerItem
- (NSArray *)childItems;
@end

@interface ActionSheetMultiColumnStringPicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>

+ (id)showPickerWithTitle:(NSString *)title
                    items:(NSArray *)items
          numberOfColumns:(NSInteger)numberOfColumns
                doneBlock:(ActionMultiColumnStringDoneBlock)doneBlock
              cancelBlock:(ActionMultiColumnStringCancelBlock)cancelBlock
                   origin:(id)origin;

- (id)initWithTitle:(NSString *)title
              items:(NSArray *)items
    numberOfColumns:(NSInteger)numberOfColumns
          doneBlock:(ActionMultiColumnStringDoneBlock)doneBlock
        cancelBlock:(ActionMultiColumnStringCancelBlock)cancelBlockOrNil
             origin:(id)origin;

@property (nonatomic, copy) ActionMultiColumnStringDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionMultiColumnStringCancelBlock onActionSheetCancel;

@end
