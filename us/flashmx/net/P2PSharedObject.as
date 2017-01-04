package us.flashmx.net
{
	import flash.utils.ByteArray;

	public class P2PSharedObject
	{
		public var size:Number = 0;
		public var packetLength:uint = 0;
		public var actualFetchIndex:Number = 0;
		public var data:ByteArray;
		public var dataBuffer:ByteArray;
		public var chunks:Object = new Object();
		
		public var lastIndexBegin:uint;
		public var lastIndexEnd:uint;
		
		public function P2PSharedObject()
		{
		}
	}
}