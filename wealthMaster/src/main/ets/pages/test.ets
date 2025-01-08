@Entry
@Component
struct Prop_linkDemo {
  @State counter: number = 0
  private todayDate = '2021.11.29'

  private toggleClick() {
    this.counter += 1
  }

  build() {
    Column() {
      Text('@State @Prop @Link 演示').fontSize(24)

      Button(`父组件State: ${this.counter}`).fontSize(24)
        .onClick(this.toggleClick.bind(this))
        .margin({ top: 20 })


      ChildProp({ counterVal: this.counter })
      ChildLink({ counterRef: $counter })

      Text('总结：状态变量(@State，@Prop，@Link)发生变化时，会调用该变量所在组件的build方法重新渲染UI')
        .fontColor('#FF0000')
        .fontSize(24)
        .margin({ top: 20 })

    }.width('100%')
    .margin({ top: 50 })
  }
}

@Component
struct ChildProp {
  @Prop counterVal: number;

  build() {
    Column() {
      Text('@Prop 单向的 内部修改不会改变父组件').fontSize(24)

      Button(`子组件Prop: ${this.counterVal}`).fontSize(24).onClick(() => {
        this.counterVal += 1
      })
    }.width('100%')
    .margin({ top: 50 })
  }
}

@Component
struct ChildLink {
  @Link counterRef: number

  build() {
    Column() {
      Text('@Link 类似传引用 内部修改会引起外部的改变').fontSize(24)

      Button(`子组件Link: ${this.counterRef}`).fontSize(24).onClick(() => {
        this.counterRef += 1
      })
    }.width('100%')
    .margin({ top: 50 })
  }
}