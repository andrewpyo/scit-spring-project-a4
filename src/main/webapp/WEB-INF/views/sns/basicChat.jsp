<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Bubblemap</title>
	<script src="<c:url value="/resources/js/jquery.min.js" />"></script>
	
		<link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
		<script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
		<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>	
	<script type="text/javascript">
		$(document).ready(function(){
			$('#btnSend').on('click', function(evt) {
				  evt.preventDefault();
			if (socket.readyState !== 1) return;
			  	  let msg = $('input#msg').val();
			  	  socket.send(msg);
			  });
			  connect();
			})
  </script>
	<script type="text/javascript">
  var socket = null;
  function connect(){
	  var ws = new WebSocket("ws://localhost:8888/replyEcho?bno=1234");
		socket = ws;

	  ws.onopen = function () {
	      console.log('Info: connection opened.');	      
	  };


	  ws.onmessage = function (event) {
	      console.log("ReceiveMessage:", event.data+'\n');
	  };


	  ws.onclose = function (event) { console.log('Info: connection closed.');
	  		//setTimeout( function(){ connect(); }, 1000); // retry connection!!
	  		};
	  ws.onerror = function (err) { console.log('Error:', err); };
	  }	
  </script>
	<style type="text/css">
		#chatroom{
			width: 300px;
			height: 300px;
			border: 1px solid;
		}
		.mytext{
		    border:0;padding:10px;background:whitesmoke;
		}
		.text{
		    width:75%;display:flex;flex-direction:column;
		}
		.text > p:first-of-type{
		    width:100%;margin-top:0;margin-bottom:auto;line-height: 13px;font-size: 12px;
		}
		.text > p:last-of-type{
		    width:100%;text-align:right;color:silver;margin-bottom:-7px;margin-top:auto;
		}
		.text-l{
		    float:left;padding-right:10px;
		}        
		.text-r{
		    float:right;padding-left:10px;
		}
		.avatar{
		    display:flex;
		    justify-content:center;
		    align-items:center;
		    width:25%;
		    float:left;
		    padding-right:10px;
		}
		.macro{
		    margin-top:5px;width:85%;border-radius:5px;padding:5px;display:flex;
		}
		.msj-rta{
		    float:right;background:whitesmoke;
		}
		.msj{
		    float:left;background:white;
		}
		.frame{
		    background:#e0e0de;
		    height:450px;
		    overflow:hidden;
		    padding:0;
		}
		.frame > div:last-of-type{
		    position:absolute;bottom:0;width:100%;display:flex;
		}
		body > div > div > div:nth-child(2) > span{
		    background: whitesmoke;padding: 10px;font-size: 21px;border-radius: 50%;
		}
		body > div > div > div.msj-rta.macro{
		    margin:auto;margin-left:1%;
		}
		ul {
		    width:100%;
		    list-style-type: none;
		    padding:18px;
		    position:absolute;
		    bottom:47px;
		    display:flex;
		    flex-direction: column;
		    top:0;
		    overflow-y:scroll;
		}
		.msj:before{
		    width: 0;
		    height: 0;
		    content:"";
		    top:-5px;
		    left:-14px;
		    position:relative;
		    border-style: solid;
		    border-width: 0 13px 13px 0;
		    border-color: transparent #ffffff transparent transparent;            
		}
		.msj-rta:after{
		    width: 0;
		    height: 0;
		    content:"";
		    top:-5px;
		    left:14px;
		    position:relative;
		    border-style: solid;
		    border-width: 13px 13px 0 0;
		    border-color: whitesmoke transparent transparent transparent;           
		}  
		input:focus{
		    outline: none;
		}        
		::-webkit-input-placeholder { /* Chrome/Opera/Safari */
		    color: #d4d4d4;
		}
		::-moz-placeholder { /* Firefox 19+ */
		    color: #d4d4d4;
		}
		:-ms-input-placeholder { /* IE 10+ */
		    color: #d4d4d4;
		}
		:-moz-placeholder { /* Firefox 18- */
		    color: #d4d4d4;
		}  
	</style>
</head>
<body>
<div class="well">
	<input type="text" id="msg" value="1212" class="form-control"/>
	<button id="btnSend" class="btn btn-primary">Send Message</button>
</div>

        <div class="col-sm-3 col-sm-offset-4 frame">
            <ul></ul>
            <div>
                <div class="msj-rta macro">                        
                    <div class="text text-r" style="background:whitesmoke !important">
                        <input class="mytext" placeholder="Type a message"/>
                    </div> 

                </div>
                <div style="padding:10px;">
                    <span class="glyphicon glyphicon-share-alt"></span>
                </div>                
            </div>
        </div>       
        
        <script type="text/javascript">
        var me = {};
        me.avatar = "/resources/assets/images/avatar-2.jpg";

        var you = {};
        you.avatar = "https://a11.t26.net/taringa/avatares/9/1/2/F/7/8/Demon_King1/48x48_5C5.jpg";

        function formatAMPM(date) {
            var hours = date.getHours();
            var minutes = date.getMinutes();
            var ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12;
            hours = hours ? hours : 12; // the hour '0' should be '12'
            minutes = minutes < 10 ? '0'+minutes : minutes;
            var strTime = hours + ':' + minutes + ' ' + ampm;
            return strTime;
        }            

        //-- No use time. It is a javaScript effect.
        function insertChat(who, text, time){
            if (time === undefined){
                time = 0;
            }
            var control = "";
            var date = formatAMPM(new Date());
            
            if (who == "me"){
                control = '<li style="width:100%">' +
                                '<div class="msj macro">' +
                                '<div class="avatar"><img class="img-circle" style="width:100%;" src="'+ me.avatar +'" /></div>' +
                                    '<div class="text text-l">' +
                                        '<p>'+ text +'</p>' +
                                        '<p><small>'+date+'</small></p>' +
                                    '</div>' +
                                '</div>' +
                            '</li>';                    
            }else{
                control = '<li style="width:100%;">' +
                                '<div class="msj-rta macro">' +
                                    '<div class="text text-r">' +
                                        '<p>'+text+'</p>' +
                                        '<p><small>'+date+'</small></p>' +
                                    '</div>' +
                                '<div class="avatar" style="padding:0px 0px 0px 10px !important"><img class="img-circle" style="width:100%;" src="'+you.avatar+'" /></div>' +                                
                          '</li>';
            }
            setTimeout(
                function(){                        
                    $("ul").append(control).scrollTop($("ul").prop('scrollHeight'));
                }, time);
            
        }

        function resetChat(){
            $("ul").empty();
        }

        $(".mytext").on("keydown", function(e){
            if (e.which == 13){
                var text = $(this).val();
                if (text !== ""){
                    insertChat("me", text);              
                    $(this).val('');
                }
            }
        });

        $('body > div > div > div:nth-child(2) > span').click(function(){
            $(".mytext").trigger({type: 'keydown', which: 13, keyCode: 13});
        })

        //-- Clear Chat
        resetChat();

        //-- Print Messages
        insertChat("me", "Hello Tom...", 0);  
        insertChat("you", "Hi, Pablo", 1500);
        insertChat("me", "What would you like to talk about today?", 3500);
        insertChat("you", "Tell me a joke",7000);
        insertChat("me", "Spaceman: Computer! Computer! Do we bring battery?!", 9500);
        insertChat("you", "LOL", 12000);
        </script>
</body>
</html>