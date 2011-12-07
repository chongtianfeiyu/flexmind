package com.mindLighting.view.mediators
{
	import air.net.URLMonitor;
	
	import com.mindLighting.model.vo.feedback;
	import com.mindLighting.view.components.containers.FeedbackContainer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.validators.Validator;
	
	import org.robotlegs.mvcs.Mediator;
	
	import spark.events.TextOperationEvent;
	
	public class FeedbackMediator extends Mediator
	{
		//--------------------------------------------------------------------------
		//
		//  Instance Properties
		//
		//--------------------------------------------------------------------------
		protected static const STATE_SUCCESS:String = "Success";

		//protected static const GATEWAY:String = "http://localhost/mindlight/service/gateway.php";
		protected static const GATEWAY:String = "http://www.mindlighting.net/service/gateway.php";
		[Inject]
		public var v:FeedbackContainer;
		
		public var feel:feedback;
		
		protected var monitor:URLMonitor;
		protected var _available:Boolean;
		
		protected var _user:String  = 'asdffdsa';
		protected var _pass:String = 'asdfQWER1234';
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			trace("FeedbackContainerMediator.onRegister()");
			v.txtContent.addEventListener(TextOperationEvent.CHANGE,txtContentChange);
			v.btnSend.addEventListener(MouseEvent.CLICK,btnSendClick);
			v.authService.addEventListener(ResultEvent.RESULT,authResult);
			v.authService.addEventListener(FaultEvent.FAULT,authFault);
			
			//make sure connects internet
			monitor = new URLMonitor(new URLRequest("http://www.baidu.com")); 
			monitor.addEventListener(StatusEvent.STATUS, onStatusChange);
			monitor.pollInterval = 20000;
			monitor.start();
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		protected function sendFeel():void
		{			
			feel = new  feedback();
			feel.name = v.txtName.text;
			feel.email = v.txtEmail.text;
			feel.content = v.txtContent.text;
			
			v.authService.loginAndSend(_user,_pass,feel);
		}
		
		protected function changeSucessSection():void
		{
			v.currentState = STATE_SUCCESS;
			v.lblName.text = feel.name;
			CursorManager.removeBusyCursor();
			
		}
		//--------------------------------------------------------------------------
		//
		//  EventHandling
		//
		//--------------------------------------------------------------------------
		protected function onStatusChange(e:StatusEvent):void
		{
			if (monitor.available) 
			{
				_available = true; 
			} else {
				_available = false;
			}
		}
		
		protected function authResult(e:ResultEvent):void
		{
			trace('okay');
			if(e.result.toString() == 'login')
			{
				trace('seed feel');
				//desconnect 
				
				v.authService.out();
				v.authService.logout();
				changeSucessSection();
			}
			
			if(e.result.toString() == 'logout')
			{
				trace('logout service');
			}
		}
		
		protected function authFault(e:FaultEvent):void
		{
			trace('error');
			if(e.fault.toString() == 'loginError')
			{
				trace('send feel error');
			}
		}
		protected function btnSendClick(evt:Event):void
		{
			var valid:Array =  Validator.validateAll([v.emailValid, v.nameValid]);
			
			// valid all
			if(valid.length == 0)
			{
				
				if(_available)
				{
					sendFeel();
				}
				else
				{
					Alert.show('请检查网路');
				}
			}
		}
		
		protected function txtContentChange(evt:TextOperationEvent):void
		{
			if(evt.target.text.length > 4)
			{
				v.btnSend.enabled = true;
			}
			else
			{
				v.btnSend.enabled = false;
			}
		}	
		
		
	}
}