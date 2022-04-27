<template>
   <div class="wrapper" ref="wrapper">
      <div class="content">
          <slot></slot>
      </div>
   </div>
</template>
<script>
   import BetterScroll from 'better-scroll';
   //import { truncate } from 'fs';

   export default {
      name: 'BetterScroll',
      props:{
        probeType:{
            type:Number,
            default:0
        },
        pullUpLoad: {
		    type: Boolean,
          default: false
      }
      },
      data() {
         return {
           bscroll: null,
           //bsMaxScrollY:0 //
         };
      },
      mounted(){//组件挂载完之后
        //document.querySelector(".wrapper")也可以只写(".wrapper")
        //通过document.querySelector(".wrapper")这个方式获取效果不好，因为若一个界面中还有类名为wrapper的就会导致，查找到的wrapper不对，默认获取的是第一个wrapper
        //所以，给标签绑定ref,再用this.refs.refname能明确的查找，这个效果更好
        //备注，若ref是绑定在组件上的，那么通过"this.$refs.refname"获取到的是一个组件对象
        //若r绑定在普通元素中，那么通过"this.$refs.refname"获取到的是一个元素对象（和document.querySelector(".wrapper")获取的结果一样）
        //1.创建BetterScroll对象
        this.bscroll = new BetterScroll(this.$refs.wrapper,{
           probeType:this.probeType,//=3表示实时监听滚动的位置这个不能设置死，因为不用的位置用这个组件不一样，有的地方需要实时监听滚动位置，有的地方不需要，所以通过传入变量来确定
           click:true,//默认这个false若不设置这个true滚动内部的元素div,span等点击事件将会无效，button的点击事件有效
           pullUpLoad:this.pullUpLoad
        })
        //2.监听滚动的位置
        this.bscroll.on("scroll",(position)=>{
          //console.log(position)
          this.$emit("scroll",position);//scroll()名字随意，其他地方用这个方法名字需要和这个一致
       })

       //3.监听scroll滚动到底部，上拉加载更多
       //better-scroll默认是只能加载更多一次，需要执行scroll.finishPullUp()才能加载更多数据
       if(this.pullUpLoad){
        this.bscroll.on('pullingUp', () => {
          //console.log('上拉加载');
          //监听到滚动底部
          this.$emit('pullingUp');
        })
       }
     },
      methods: {
         //time=500参数中这样设置是es6语法，表示当这个参数不传的时候，默认值
         scrollToTop(x,y,time=500){
            //scrollTo(x,y,time) //坐标以及时间
            //this.bscroll.scrollTo(0,0,time);
            //下面这段代码和上面的区别是，
            //下面的是当bscroll对象创建实例完成后才执行scrollTo(0,0,time);
            //逻辑与，先判断this.bscroll，为true才会继续执行
            //如果改成上面的代码，偶尔会出现bug，导致bscroll还不存在的时候就调用了scrollTo()会报错
            this.bscroll&&this.bscroll.scrollTo&&this.bscroll.scrollTo(0,0,time);
         },
         refresh(){
            //console.log("----");
            //获取scroll的滚动后高度，当到最底部的时候可以加个提示语，“我是有底线的"
            //this.bsMaxScrollY=document.getElementsByClassName("wrapper")[0].offsetHeight;
             //this.bscroll.refresh();
             //下面这段代码和上面的区别是，
            //下面的是当bscroll对象创建实例完成后才执行refresh(0,0,time);
            //逻辑与，先判断this.bscroll，为true才会继续执行
             this.bscroll&&this.bscroll.refresh();
         },
         finishPullUp(){
             this.bscroll.finishPullUp();
         }, 
         scrollTo(x,y,time){
            this.bscroll&&this.bscroll.scrollTo&&this.bscroll.scrollTo(x,y,time);
         },
         getScrollY(){
            return this.bscroll?this.bscroll.y:0;
         }
     }
}
</script>
<style scoped>

</style>
