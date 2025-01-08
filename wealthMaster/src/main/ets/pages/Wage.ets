import text from '@ohos.graphics.text';
import { faceDetector } from '@kit.CoreVisionKit';

@Entry
@Component
struct Wage {
  @State message: string = '工资分配';

  build() {
    Column() {
      Text(this.message)
        .id('title')
        .fontSize(25)
        .fontFamily('HarmonyHeiTi-Bold')
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          // middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      incomeTotalInput()
      .margin({top:30,left:30})
      .width('100%')
      .height('5%')
      List(){
        expendItemList()
          .margin({top:30})
          .width('100%')
          .height('100%')
          .alignSelf(ItemAlign.Center)
      }.width('100%')
      .height('60%')
      //资金分布
      statistics()
        .width('100%')
        .height('40%')

    }
    .height('100%')
    .width('100%')
  }
}

/**
 * 总收入输入框
 */
@Preview
@Component
struct incomeTotalInput{
  build() {
    Row(){
      Text($r('app.string.Wage_Total_label'))
        .width('30%')
        .height('100%')
        .fontSize(20)
        .fontFamily('HarmonyHeiTi-Bold')
        .fontWeight(FontWeight.Bold)
      TextInput()
        .width('60%')
        .type(InputType.Number)
        .onChange((value:string) =>{
          console.log("value:",value);
        })
    }
  }
}


class expendItemClass{
  id : number = 0;
  title : string = '';
  parentId : number | null  = null;
  sum : number;
  childList:expendItemClass[] | null;
  type : number | null; // 0-未知 1-生活开销 2-存储 3-投资理财 4-娱乐消费

  constructor(id:number,title:string,parentId:number | null,sum:number,childList:expendItemClass[] | null,type:number | null) {
    this.id = id;
    this.title = title;
    this.parentId = parentId;
    this.sum = sum;
    this.childList = childList;
    this.type = type;
  }
}

@CustomDialog
@Component
struct addDialog {
  @Link textValue: string
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column(){
      Text('请填写需要增加的选项').fontSize(20).margin({top:20})
      TextInput({placeholder: '', text: this.textValue}).height(80).width('90%')
        .onChange((value:string)=>{
          this.textValue = value
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
              this.cancel()
            }
          }).fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            if (this.controller != undefined) {
              // this.inputValue = this.textValue
              this.controller.close()
              this.confirm()
            }
          }).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }.borderRadius(10)
  }
}


@Preview
@Component
struct expendItemList{
  @State textValue: string = ''
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: addDialog({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
      textValue: $textValue,
      // inputValue: $inputValue
    }),
    cancel: this.exitApp,
    autoCancel: true,
    onWillDismiss:(dismissDialogAction: DismissDialogAction)=> {
      console.info("reason=" + JSON.stringify(dismissDialogAction.reason))
      console.log("dialog onWillDismiss")
      if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
        dismissDialogAction.dismiss()
      }
      if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
        dismissDialogAction.dismiss()
      }
    },
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false,
    cornerRadius: 10,
  })

  dailyExpendList : expendItemClass[] = [
    new expendItemClass(10,'生活费',1,100,null,1),
    new expendItemClass(11,'交通费',1,100,null,1)
  ];

  storeExpendList : expendItemClass[] = [
    new expendItemClass(20,'备用金',2,300,null,2)
  ]

  @State expendItems : expendItemClass[] = [
    new expendItemClass(1,'日常开销',null,200,this.dailyExpendList,null),
    new expendItemClass(2,'每月储备',null,300,this.storeExpendList,null)
  ];

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }
  exitApp() {
    console.info('Click the callback in the blank area')
  }


  build() {
      Column(){
        ForEach(this.expendItems,(item:expendItemClass,index:number)=>{
          Column(){
            Row(){
              Row(){
                Text(item.title)
                  .width('100%')
                  .height('100%')
                  .fontSize(30)
                  .fontFamily('HarmonyHeiTi-Bold')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Start)
              }.width('50%')
              Row(){
                Text(item.sum.toString())
                  .width('100%')
                  .height('100%')
                  .fontSize(25)
                  .fontFamily('HarmonyHeiTi-Bold')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.End)
              }.width('50%')
            }
            .margin({top:10,bottom:10})
            .width('100%')
            .height('5%')
            ForEach(item.childList,(child:expendItemClass,index:number)=>{
              Column(){
                Row(){
                  Text(child.title)
                    .width('30%')
                    .height('100%')
                    .fontSize(20)
                    .fontFamily('HarmonyHeiTi-Bold')
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Start)
                  TextInput()
                    .width('70%')
                    .type(InputType.Number)
                    .textAlign(TextAlign.End)
                    .onChange((value:string) =>{
                      console.log("inputValue:",value)
                    })
                }
                .margin({top:10,left:10})
                .width('100%')
                .height('5%')
              }
            })
            // .backgroundColor(Color.Red)
          }
          .margin({top:10})
          .width('95%')
          .backgroundColor(Color.Green)
        })
        RelativeContainer(){
          Button('增加')
            .id('addBtn')
            .fontColor(Color.Gray)
            .alignRules({
              middle:{
                anchor:'__container__',
                align:HorizontalAlign.Center
              }
            })
            .backgroundColor(Color.White)
            .onClick(()=>{
              if(this.dialogController!=null){
                this.dialogController.open();
              }
            })
        }
        .margin({top:10})
        .width('100%')
        .height('10%')
        .position({bottom:0})
      }
      // .justifyContent(FlexAlign.Start)
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Blue)
  }
}

// @Preview
// @CustomDialog
// struct addDialog{
//   controller?CustomerDialogController
//   build(){
//     RelativeContainer(){
//
//     }.width('100%')
//     .height('100%')
//     .backgroundColor()
//   }
// }

/**
 * 统计
 */
@Preview
@Component
struct statistics{
  dailyExpendList : expendItemClass[] = [
    new expendItemClass(10,'生活费',1,100,null,1),
    new expendItemClass(11,'交通费',1,100,null,1)
  ];

  storeExpendList : expendItemClass[] = [
    new expendItemClass(20,'备用金',2,300,null,2)
  ]

  @State expendItems : expendItemClass[] = [
    new expendItemClass(1,'日常开销',null,200,this.dailyExpendList,null),
    new expendItemClass(2,'每月储备',null,300,this.storeExpendList,null)
  ];



  build(){
    Column(){
      Row(){
        Text('资金类别分布')
          .width('100%')
          .height('100%')
          .fontSize(25)
          .fontFamily('HarmonyHeiTi-Bold')
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
      }.width('50%')
      .height('10%')
      .backgroundColor(Color.Red)

      Column(){

      }.width('100%')
      
    }
  }
}
