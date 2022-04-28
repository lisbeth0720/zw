<template>
<div class="login-layout">
	   <form id='login-form'>
		  <fieldset>
			<label class="block">
				<div class="block input-icon icon-logo">
					<img src="~/assets/img/common/hflogo.png" style="width: 50px;height: 50px;position: absolute;left: 36%;">			
				</div>
			</label>												
			<label class="block">
				<div class="block input-icon icon-logo">
					<label for="loginname" class="login-label name-label lable12">会议预约</label>
				</div>
			</label>
			<label class="block">
				  <div class="block input-icon labelDiv" style="">
					  <select class="form-control" 
					          id="companyID"
							  v-model="companyid"
							  @change="companyChange">
							  <option value="0" selected>请选择单位号</option>
							  <option v-for="item in coppanyidList"
							  :key="item" :value="item.companyID">{{item.companyName}}</option>
							  </select>	
					   <i id="icon-select"></i>
				 </div>
			</label>
			<label class="block">
				<div class="block input-icon labelDiv">
					<label for="loginname" class="login-label name-label lable11">
						<img src="~/assets/img/common/user.png" />
					</label>
					<input autocapitalize="off" 
                           autocorrect="off" 
                           type="text" 
                           class="form-control" 
                           id="name" 
                           placeholder="登录名"
                           v-model="username" />														
				</div>
			</label>
			<label class="block">
				<div class="block input-icon labelDiv">
					 <label for="loginpwd" class="login-label name-label lable11">
						 <img src="~/assets/img/common/password.png" />
					 </label>
					  <input type="password" 
                             class="form-control" 
                             id="pwd" 
                             placeholder="密码" 
                             v-model="pwd"/>				
				</div>
			</label>
			<label class="block">
			  <div class="block input-icon" style="left:16%;">
				  <button type="button" id="login" @click="login">登录</button>
			  </div>
			</label>
		</fieldset>
	</form>
  </div>
</template>
<script>
  import { useStore } from 'vuex'
  import {mapActions} from 'vuex'
  
  //3.一些方法
  import {getCompanyId,userLogin,getTocken,getMaxTicket} from "network/login.js";


  export default {
	name: "Login",
    components: {
	    
    },
    data() {
     const store = useStore()
     
	 return {
        Ticket:"",
        MaxTicket:"",

        username:"",
        pwd:"",
        companyid:"0",//默认选中第一个

		coppanyidList:[],
      }
    },
    computed: {
		 
    },
   
    created() {
        //1.单位号
        this.getLoginCompanyId()

        //2.得到短Token
        this.getLoginTocken()

        //3.得到长Token
        this.getLoginMaxTicket()

		//登录页不显示底部的导航

    },
    mounted(){
      
    },
    methods: {
      // 1.事件监听方法
	  //1.1取到actions里的submitLogin方法
      ...mapActions(['submitLogin']),
	  //1.2检测单位号是否发生改变
      companyChange(){
          this.companyid=document.querySelector("#companyID").value;
	  },
      //1.3登陆
      login(){
        //var companyid=document.querySelector("#companyID").value;
		console.log(this.companyid,this.username,this.pwd)
        userLogin(this.companyid,this.username,this.pwd).then(res=>{
          if(res.code=="0"){
                this.Ticket=res.data.Ticket;
		 		this.MaxTicket=res.data.MaxTicket;
				 //为了能很好的实现其他界面，不用刷新就重新登录，先把信息存到localStorage
		 		localStorage.setItem('Ticket',this.Ticket);
		 		localStorage.setItem('MaxTicket',this.MaxTicket);
		 		localStorage.setItem('username',this.username);
                    
                // 1.创建对象
                const obj = {}
                // 2.对象信息
                obj.Ticket = this.Ticket;
                obj.MaxTicket = this.MaxTicket;
                obj.username = this.username;
                 //将信息提交到vuex里
                this.submitLogin(obj).then(res=>{
                    //console.log(res)
                })
				//跳转到主页
				this.$router.push("/home"); 
		   	}else if(res.code=="30007"){
			   this.$router.push("/home"); 
		  	}else{
				this.$router.push("/login"); 
		  	}
        })
      },
     
      // 2.网络请求相关方法
	   //2.1得到单位号
      getLoginCompanyId(){//获取单位号
          getCompanyId().then(res=>{
			   this.coppanyidList=res.data;
            //    if(getCookie("companyName")){
			// 	   var list1="<option value='"+getCookie("companyID")+"'>"+getCookie("companyName")+"</option>";
			// 	}else{
			// 		var list1='<option value="">请选择单位号</option>';
			// 	}
			//    for (var i=0;i<result.length;i++ ){
			// 		list1+="<option value='"+result[i].companyID+"'>"+result[i].companyName+"</option>";              
			// 	}
			// 	document.getElementById("companyID").innerHTML=list1;
			// 	if (result.length == 0) {
			// 		 document.getElementById("companyID").innerHTML=result[0].companyID;
			// 	}	 
         }) 
      },
      //2.2得到短Token
      getLoginTocken(){
        getTocken().then(res=>{
           if(res.code=="0"){
				this.Ticket=res.data.Ticket;
				this.MaxTicket=res.data.MaxTicket;
				localStorage.setItem('Ticket',this.Ticket);
				localStorage.setItem('MaxTicket',this.MaxTicket);
				//localStorage.setItem('username',this.username);
			}
        })
      },
      //2.3得到长Token
      getLoginMaxTicket(){
        getMaxTicket().then(res=>{
          if(res.code=="0"){
			   	return "0";
		   	}else if(res.code=="30007"){
			   	//window.location.href="../login.html";
		  	}else{
				  //window.location.href="../login.html";
		  	}
        })
      },
    }
	}
</script>
<style scoped>
        .login-layout{
			background-color: #e4e6e9;
			height: 100vh;
			width:100%;
			font-family: 'Open Sans';
			font-size: 13px;
			color: #393939;
			line-height: 1.5;
            background: url("../../assets/img/common/login.jpg") no-repeat;
            background-size: 100% 100%;
        }

        fieldset{
		    border: 0;
			height:50%; 
			width:100%;
			position:absolute;
			top:50%;
			left:0;
			transform: translate(0%,-50%)
	    }
       
       .login-layout label {
            margin-bottom: 11px;
        }
       .lable12 {
            position: absolute;
            z-index:3;
            top: 2px;
            width: 100%;
            font-size: 20px;
            color: #fff;
            text-align: center;
        }
       
	   .input-icon {
	        position: relative;
	   }
	   .block {
	        display: block!important;
	   }
	   .login-layout label {
	        margin-bottom: 11px;
	   }
	  
	   .lable11 {
	        position: absolute;
	        z-index: 3;
	        top: 2px;
	        left: 6px;
	        width: 39px;
	        background: url("../../assets/img/common/user.png") no-repeat;
	    }
	   .icon-logo{
		    background-color: transparent;
		    border-radius: 8px !important;
		    width: 67%;
		    height: 44px;
		    margin: auto;
	    }
	  
	    #login-form .labelDiv{
	  		background-color: transparent;
	  	    border-radius: 8px !important;
	  		width: 67%;
	  		height: 44px;
	  	    margin: auto;
	  		border:1px solid #fcfcfc;
	   }
	   .labelDiv img{
	   		width: 20px;
	  		height: 20px;
	  	    position: absolute;
	  		top: 8px;
	  	    left: 6px;
	    }
	    #companyID{
		   color: black;
		   width: 100%;
		   position:absolute;
		   top:-1px;
		   height: 43px; 
		   background: rgba(255,255,255,.5);
		   border-bottom-right-radius: 8px !important;
		   border-top-right-radius: 8px !important;
		   padding: 10px;
	    }
	  
	  #login,#login:focus{
		  border-radius: 8px;
		  left: 0px;
		  position: relative;
		  border: 1px solid transparent;
		  text-align: center;
		  background-color: transparent;
		  border-color: white;
		  width: 239px;
		  height: 45px;
		  font-size:20px;
		  color:#fff;
		  width: 67%;
		  margin:1px;
		  letter-spacing:3px
	  }
	  #pwd{
		  border:0px;
		  color: black;
		  width: 82%;
		  height: 43px;
		  margin-left:18.5%;
		  background: rgba(255,255,255,.5);
		  border-bottom-right-radius: 8px !important;
		  border-top-right-radius: 8px !important;
		  padding: 10px;
	  }
	  #name{
		  border:0px;
		  color: black;
		  width: 82%;
		  height: 43px;
		  margin-left: 18.5%;
		  background-color: rgba(255,255,255,.5);
		  border-bottom-right-radius: 8px !important;
		  border-top-right-radius: 8px !important;
		  padding: 10px;
	  }
	
	  #icon-select{
		  height:12px;
		  width:12px;
		  background:url('../../assets/img/common/icon_select.png') no-repeat;
		  background-size:100% 100%;
		  position:absolute;
		  top:50%;
		  right:5px;
		  transform: translate(0,-50%);
		  z-index:4;
	  }
</style>