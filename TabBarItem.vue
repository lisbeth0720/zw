<template>
  <div class="tab-bar-item" @click="itemClick">
     <!-- <img src="~/assets/img/tabbar/category.svg" alt="" />
     <div name="item-text">我的</div> -->
      <div v-if="!isActive">
         <slot name="item-icon"></slot>
      </div>
      <div v-else>
        <slot name="item-icon-active"></slot>
      </div>
      <div :style="activeStyle">
        <slot name="item-text"></slot>
      </div>
  </div>
</template>

<script>

export default {
  name: 'TabBarItem',
  props:{
     path:String,
     activeColor:{
       type:String,
       default:"blue",
     }
  },
  data(){
     return{
       //isActive:true
     }
  },
  computed:{
      isActive(){
        return this.$route.path.indexOf(this.path)!=-1;
        //$route处于活跃的路由
      },
      activeStyle(){    
        return this.isActive?{color:this.activeColor}:{}
      }
  },
  methods:{
     itemClick(){
       //console.log("itemClick");
        //this.$router.push(this.path);//返回不可以点击
       this.$router.replace(this.path);//返回可以点击
     }
  },
  components: {//在components里注册组件后才能在模板里使用
  
  }
}
</script>

<style>
  .tab-bar-item {
      flex:1;
      text-align:center;
      height:49px;
      font-size:14px;
  }
  .tab-bar-item img{
      height:24px;
      width:24px;
      margin-top:3px;
      vertical-align:middle;
      margin-bottom:2px;
  }
   
</style>
