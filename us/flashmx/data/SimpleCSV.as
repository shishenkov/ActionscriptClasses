package us.flashmx.data 
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * ...
	 * @author Nick Shishenkov <nshishenkov@gmail.com>
	 */
	public class SimpleCSV 
	{
		static private var _str:String;
		
		public function SimpleCSV() 
		{
			
		}
		
		//
		public static function ArrayToCSV(_data:Array, _delimiter:String = ",", _lineBreak:String = "\n"):String
		{
			var _csv:String		= "";
			var _csvArr:Array	= [];
			var _newRow:Array	= [];
			
			//
			for each(var _row:Array in _data)
			{
				_newRow	= [];
				for each(var _var:String in _row)
				{
					var _cell:*				= Number(_var);
					var _isString:Boolean	= isNaN(_cell);
					//
					_cell		= _isString ? '"' + _var.replace(/\"/g, '""') + '"' : _cell;
					//
					_newRow.push(_cell);
				}
				//
				_csvArr.push(_newRow.join(_delimiter));
			}
			
			//
			_csv	= _csvArr.join(_lineBreak);
			
			//
			return _csv;
		}
		
		//
		public static function SaveArrayToCSVFile(_file:File, _data:Array, _delimiter:String = ",", _lineBreak:String = "\n"):void
		{
			_str	= ArrayToCSV(_data, _delimiter, _lineBreak);
			//
			_file.browseForSave("Save as ...");
			//
			_file.addEventListener(Event.SELECT, 
			function(e:Event):void {
				var f:File	= e.target as File;
				var fs:FileStream	= new FileStream;
				fs.open(f, FileMode.WRITE);
				trace("String:\n" + _str + "\n--------------");
				//prepare UTF
				fs.writeByte (0xEF);
				fs.writeByte (0xBB);
				fs.writeByte (0xBF);
				//write UTF
				fs.writeMultiByte(_str, "utf-8");
				fs.close();
			});
		}
	}

}