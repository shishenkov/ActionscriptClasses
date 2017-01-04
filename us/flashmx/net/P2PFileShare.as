/*
* Copyright 2010 (c) Tom Krcha, FlashRealtime.com, @tomkrcha
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package us.flashmx.net
{
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="status",type="flash.events.StatusEvent")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	
	public class P2PFileShare extends EventDispatcher
	{
		public var p2pSharedObject:P2PSharedObject, _fileToSend:LocalFileLoader;
		private var _netGroup:NetGroup, _netStream:NetStream;
		
		
		public function P2PFileShare()
		{
		}
		
		public function set stream(_ns:NetStream):void
		{
			_netStream	= _ns;
		}
		
		public function set group(_ng:NetGroup):void
		{
			if(_netGroup != null)
			{
				_netGroup.removeEventListener(NetStatusEvent.NET_STATUS,_netStatus);
				_netGroup	= null;
			}
			//
			_netGroup	= _ng;
			//
			_netGroup.addEventListener(NetStatusEvent.NET_STATUS,_netStatus);
		}
		
		protected function _netStatus(event:NetStatusEvent):void
		{
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					//      writeText(event.info.code);
					//setupGroup();
					break;
				
				case "NetGroup.Connect.Success":
					//writeText("READY: "+event.info.code);
					//connected = true;
					//onGroupConnected();
					break;
				
				case "NetGroup.Neighbor.Connect":
					//writeText(event.info.code);
					break;
				
				case "NetGroup.Replication.Fetch.SendNotify": // e.info.index
					//writeText("____ index: "+event.info.index);
					break;
				
				case "NetGroup.Replication.Fetch.Failed": // e.info.index
					//writeText("____ index: "+event.info.index);
					
					break;
				
				case "NetGroup.Replication.Fetch.Result": // e.info.index, e.info.object
					//writeText("____ index: "+event.info.index+" | object: "+event.info.object);
					//writeText("down: "+event.info.index);
					p2pSharedObject.chunks[event.info.index] = event.info.object;
					p2pSharedObject.actualFetchIndex = event.info.index;
					
					if(event.info.index == 0){
						p2pSharedObject.packetLength = event.info.object.totalChunks;
						group.addWantObjects(1,p2pSharedObject.packetLength+1);
						//writeText("netGroup.addWantObjects(1,"+(p2pSharedObject.packetLength+1)+");");
						//p2pSharedObject.data = new ByteArray();
						
					}else if(event.info.index==p2pSharedObject.packetLength-1){
						combineChunks();
						dispatchEvent(new Event(Event.COMPLETE));
					}else{
						p2pSharedObject.dataBuffer = new ByteArray();
						
						if(p2pSharedObject.chunks[event.info.index]){
							p2pSharedObject.dataBuffer.writeBytes(p2pSharedObject.chunks[event.info.index]);
							
						}else{
							//writeText("DEBUG: Chunk index "+event.info.index+" null. Check!")
						}
					}
					//
					onChunkReceived(event.info.index);
					// Share for other peers
					group.addHaveObjects(event.info.index,event.info.index);
					break;
				
				case "NetGroup.Replication.Request": // e.info.index, e.info.requestID
					group.writeRequestedObject(event.info.requestID,p2pSharedObject.chunks[event.info.index])
					break;
				
				default:
					break;
			}
		}
		
		//
		protected function onChunkReceived(index:uint):void{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,index,p2pSharedObject.packetLength));
		}
		//
		public function updateHaveObjects():void{
			if(p2pSharedObject){
				trace("p2pSharedObject.lastIndexBegin: "+p2pSharedObject.lastIndexBegin + "  p2pSharedObject.lastIndexEnd: "+ p2pSharedObject.lastIndexEnd)
				group.addHaveObjects(p2pSharedObject.lastIndexBegin,p2pSharedObject.lastIndexEnd);
			}
		}
		
		public function startSending():void
		{
			_fileToSend	= new LocalFileLoader();
			_fileToSend.addEventListener(Event.COMPLETE, _fileToSendReady);
		}
		
		protected function _fileToSendReady(event:Event):void
		{
			p2pSharedObject					= _fileToSend.p2pSharedObject;
			p2pSharedObject.lastIndexBegin	= 0;
			p2pSharedObject.lastIndexEnd	= p2pSharedObject.packetLength-1;
			updateHaveObjects();
			
			//
			if(stream != null)
			{
				stream.play(null);
				stream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);                           
				stream.appendBytes(p2pSharedObject.data);
			}
		}
		
		public function startReceiving():void{
			p2pSharedObject = new P2PSharedObject();
			p2pSharedObject.chunks = new Object();
			
			group.addWantObjects(0,0);
			//writeText("netGroup.addWantObjects(0,0);");
		}
		
		public function checkObject():void{
			trace(p2pSharedObject.chunks);
		}
		
		private function combineChunks():void
		{
			this.p2pSharedObject.data = new ByteArray();
			for(var i:int = 1;i<this.p2pSharedObject.packetLength+1;i++){
				if(this.p2pSharedObject.chunks[i]){
					this.p2pSharedObject.data.writeBytes(this.p2pSharedObject.chunks[i]);
				}
			}
		}
	}
}