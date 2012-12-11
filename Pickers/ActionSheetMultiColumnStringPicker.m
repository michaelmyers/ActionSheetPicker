//
//  ActionSheetMultiColumnStringPicker.m
//  ActionSheetPicker
//
//  Created by YuAo on 12/11/12.
//
//

#import "ActionSheetMultiColumnStringPicker.h"

@interface ActionSheetMultiColumnStringPicker()
@property (nonatomic,strong) NSArray        *items;
@property (nonatomic)        NSInteger      numberOfColumns;
@property (nonatomic,strong) NSMutableArray *selectedItems;
@end

@implementation ActionSheetMultiColumnStringPicker

+ (id)showPickerWithTitle:(NSString *)title items:(NSArray *)items numberOfColumns:(NSInteger)numberOfColumns doneBlock:(ActionMultiColumnStringDoneBlock)doneBlock cancelBlock:(ActionMultiColumnStringCancelBlock)cancelBlock origin:(id)origin {
    ActionSheetMultiColumnStringPicker *picker = [[ActionSheetMultiColumnStringPicker alloc] initWithTitle:title items:items numberOfColumns:numberOfColumns doneBlock:doneBlock cancelBlock:cancelBlock origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title
              items:(NSArray *)items
    numberOfColumns:(NSInteger)numberOfColumns
          doneBlock:(ActionMultiColumnStringDoneBlock)doneBlock
        cancelBlock:(ActionMultiColumnStringCancelBlock)cancelBlockOrNil
             origin:(id)origin
{
    if (self = [super initWithTarget:nil successAction:nil cancelAction:nil origin:origin]) {
        self.items = items;
        self.numberOfColumns = numberOfColumns;
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
        self.selectedItems = [NSMutableArray arrayWithCapacity:numberOfColumns];
    }
    return self;
}

- (UIView *)configuredPickerView {
    if (!self.items)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = YES;
    
    [stringPicker selectRow:0 inComponent:0 animated:NO];
    [self pickerView:stringPicker didSelectRow:0 inComponent:0];

    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    return stringPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (self.onActionSheetDone) {
        _onActionSheetDone(self, [self.selectedItems copy]);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:successAction withObject:self.selectedItems withObject:origin];
#pragma clang diagnostic pop
        return;
    }
    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), (char *)successAction);
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:cancelAction withObject:origin];
#pragma clang diagnostic pop
    }
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedItems[0] = self.items[row];
    }else{
        id<ActionSheetMultiColumnStringPickerItem> selectedItem = [self.selectedItems[component - 1] childItems][row];
        if (selectedItem) {
            self.selectedItems[component] = selectedItem;
            if (self.selectedItems.count > component + 1) {
                [self.selectedItems removeObjectAtIndex:component+1];
            }
        }
    }
    if (component + 1 < self.numberOfColumns) {
        [pickerView selectRow:0 inComponent:component+1 animated:NO];
        [self pickerView:pickerView didSelectRow:0 inComponent:component+1];
    }
    [pickerView reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.numberOfColumns;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.items.count;
    }else{
        if (component > self.selectedItems.count ) {
            return 0;
        }else{
            return [self.selectedItems[component - 1] childItems].count;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.items[row] title];
    }else{
        return [[self.selectedItems[component - 1] childItems][row] title];
    }
}

@end
