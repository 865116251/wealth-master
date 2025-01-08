import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = '首页';

  build() {
    Column() {
      Text(this.message)
        .id('indexTitle')
        .fontFamily('HarmonyHeiTi-Bold')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
      menuBtnList()
        .margin({top:30})
    }
    .height('100%')
    .width('100%')
  }
}

class menuBtnClass{
  id : string = '';
  title : string = '';
  path : string = '';

  constructor(id:string,title:string,path:string) {
    this.id = id;
    this.title = title;
    this.path = path;
  }
}

@Preview
@Component
struct menuBtnList{
  @State menuBtnList : menuBtnClass[] = [
    new menuBtnClass('wage','工资规划','pages/Wage'),
    new menuBtnClass('test','测试','pages/test')
  ];

  build(){
    Column(){
      ForEach(this.menuBtnList,(item:menuBtnClass , index:number)=>{
        Button(item.title)
          .id(item.id)
          .width('90%')
          .margin({bottom:20})
          .onClick(()=>{
            router.pushUrl({
              url:item.path
            })
          })
      })
    }
    .height('100%')
    .width('100%')
  }
}
