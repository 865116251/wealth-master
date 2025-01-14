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
      .margin({bottom:10})
      //资金分布
      Row(){
        Text('资金类别分布')
          .width('100%')
          .height('100%')
          .fontSize(25)
          .fontFamily('HarmonyHeiTi-Bold')
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
      }.width('50%')
      .height('5%')
      // .backgroundColor(Color.Red)

      List(){
        statistics()
          .margin({top:10})
          .width('100%')
          .height('100%')
          .alignSelf(ItemAlign.Center)
      }.width('100%')
      .height('30%')


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
  id : number|null = null;
  title : string = '';
  parentId : number | null  = null;
  sum : number;
  childList:expendItemClass[] | null;
  type : number | null; // 0-未知 1-生活开销 2-存储 3-投资理财 4-娱乐消费

  constructor(id:number|null,title:string,parentId:number | null,sum:number,childList:expendItemClass[] | null,type:number | null) {
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
  @Link selectIndex:number;
  @Link selectValue:string;
  build() {
    Column(){
      Text('请填写需要增加的选项').fontSize(20).margin({top:20})
      Row(){
        Text('所属类型').fontSize(15).margin({right:20})
        Select([{value:'日常开销'},{value:'每月储备'}])
          .selected(this.selectIndex)
          .value(this.selectValue)
          .font({size:15,weight:300})
          .selectedOptionFont({size:18,weight:500})
          .onSelect((index:number,value:string)=>{
            this.selectIndex = index;
            this.selectValue = value;
            console.log("selectIndex:" + this.selectIndex);
            console.log("selectValue:" + this.selectValue);
          })
      }.margin({left:30,top:20})
      .width('100%')

      TextInput({placeholder: '', text: this.textValue}).height(50).width('90%')
        .onChange((value:string)=>{
          this.textValue = value
        }).margin({top:10})
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
      }.margin({ bottom: 10 ,top:20})
    }.borderRadius(10).height('40%')
  }
}


@Preview
@Component
struct expendItemList{
  @State textValue: string = '';
  @State type:number = 0;
  @State selectValue:string = '日常开销';

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: addDialog({
      cancel: ()=> { this.onCancel() },
      confirm: ()=> { this.onAccept() },
      textValue: $textValue,
      selectIndex: $type,
      selectValue: $selectValue
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

  @State dailyExpendList : expendItemClass[] = [
    new expendItemClass(10,'生活费',1,100,null,1),
    new expendItemClass(11,'交通费',1,100,null,1)
  ];

  @State storeExpendList : expendItemClass[] = [
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
    console.log("this.textValue:" +this.textValue);
    console.log("selectIndex:" + this.type);
    console.log("expendItems1:" + this.expendItems);
    this.expendItems.forEach(value=>{
      if(value.title === this.selectValue){
        const newItem : expendItemClass = new expendItemClass(null,this.textValue,value.id,0,null,this.type);
        value.childList?.push(newItem);
      }
    })
    //todo: 暂时解决expendItems无响应的问题，需要更新this.expendItems
    this.expendItems.reverse()
    this.expendItems.reverse()
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
                  .fontSize(20)
                  .fontFamily('HarmonyHeiTi-Bold')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Start)
              }.width('50%')
              Row(){
                Text(item.sum.toString())
                  .width('100%')
                  .height('100%')
                  .fontSize(20)
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
                    .fontSize(18)
                    .fontFamily('HarmonyHeiTi-Bold')
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Start)
                  TextInput()
                    .width('70%')
                    .height(30)
                    .fontSize(15)
                    .type(InputType.Number)
                    .textAlign(TextAlign.End)
                    .onChange((value:string) =>{
                      console.log("inputValue:",value)
                    })
                }
                .margin({top:10,left:10})
                .width('100%')
                .height('10%')
              }
            })
            // .backgroundColor(Color.Red)
          }
          .margin({top:10})
          .width('95%')
          // .backgroundColor(Color.Green)
        })
        RelativeContainer(){
          Column(){
            Row(){
              Text('待分配金额:')
                .fontSize(20)
                .fontColor(Color.Black)
              Text('2000')
                .fontSize(20)
                .margin({left:50})
            }
            .height('50%')
            .margin({bottom:10})
            .alignRules({
              middle:{
                anchor:'__container__',
                align:HorizontalAlign.Center
              }
            })

            Button('增加')
              .id('addBtn')
              .fontColor(Color.White)
              .backgroundColor(Color.Gray)
              .onClick(()=>{
                if(this.dialogController!=null){
                  this.dialogController.open();
                }
              })
          }
          .alignRules({
            middle:{
              anchor:'__container__',
              align:HorizontalAlign.Center
            }
          })
          .width('100%')
          .height('100%')
        }
        .margin({top:10})
        .width('100%')
        .height('20%')
        .position({bottom:0})
      }
      // .justifyContent(FlexAlign.Start)
      .width('100%')
      .height('100%')
      // .backgroundColor(Color.Blue)
  }
}

class flowItem{
  id : number|null = null;
  icon:ResourceStr | null = null;
  title : string = '';
  typeList : number[]  = [];
  sum : number;

  constructor(id:number|null,icon:ResourceStr | null,title:string,typeList:number[],sum:number,) {
    this.id = id;
    this.icon = icon;
    this.title = title;
    this.typeList = typeList;
    this.sum = sum;
  }
}

/**
 * 统计
 */
@Preview
@Component
struct statistics{
  @State dailyExpendList : expendItemClass[] = [
    new expendItemClass(10,'生活费',1,100,null,1),
    new expendItemClass(11,'交通费',1,100,null,1)
  ];

  @State storeExpendList : expendItemClass[] = [
    new expendItemClass(20,'备用金',2,300,null,2)
  ]

  @State expendItems : expendItemClass[] = [
    new expendItemClass(1,'日常开销',null,200,this.dailyExpendList,null),
    new expendItemClass(2,'每月储备',null,300,this.storeExpendList,null)
  ];

  @State capitalFlowList :flowItem[] = [
    new flowItem(1,$r('app.media.chineseBankIcon'),'中国银行',[1],100),
    new flowItem(1,$r('app.media.jiansheBank'),'建设银行',[1],100),
    new flowItem(1,$r('app.media.zhaoshangBank'),'招商银行',[1],100),
    new flowItem(1,$r('app.media.zhifubao'),'支付宝',[1],100)
  ]


  build(){
      Column(){
        ForEach(this.capitalFlowList,(item:flowItem)=>{
          Column(){
            Row(){
              Row(){
                Image(item.icon)
                  .width(20)
                  .height(20)
                  .margin({left:5,right:5})
                Text(item.title)
                  .fontSize(20)
              }.width('50%')

              Row(){
                Text(item.sum.toString())
                  .width('100%')
                  .fontSize(20)
                  .textAlign(TextAlign.End)
              }.width('50%')
            }.width('100%')
            .height(50)
          }.width('95%')
          // .backgroundColor(Color.Orange)
        })
      }.width('100%')
      .height('100%')
      // .backgroundColor(Color.Yellow)
  }
}
