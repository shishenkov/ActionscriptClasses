package us.flashmx.tools
{
	import flash.filesystem.*;
	import flash.utils.*;

	public class FileTools
	{
		public function FileTools()
		{
		}
		
		public static function readBinaryFile(file : File) : ByteArray {
			var stream : FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var fileBytes : ByteArray = new ByteArray();
			stream.readBytes(fileBytes);
			stream.close();
			return fileBytes;
		}
		
		public static function writeBinaryFile(f : File, array : ByteArray) : String {
			try {
				var fs : FileStream = new FileStream();
				fs.open(f, FileMode.WRITE);
				fs.writeBytes(array);
				fs.close();
				return f.nativePath + " written.";
			}
			catch (err : Error) {
				return err.name;
			}
			return "Error writing file.";
		}
		
		public static function readTextFile(file:File) : String {
			if (!file.exists) {
				return null;
			}
			var stream : FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var s : String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			return s;
		}
		
		public static function writeTextFile( f : File, text : String, _mode=FileMode.WRITE) : String {
			try {
				var fs : FileStream = new FileStream();
				fs.open(f, _mode);
				fs.writeUTFBytes(text);
				fs.close();
				return f.nativePath + " written.";
			}
			catch (err : Error) {
				return err.name;
			}
			return "Error writing file.";
		}
		
		public static function writeTextFileFile(file : File, text : String) : String {
			try {
				var fs : FileStream = new FileStream();
				fs.open(file, FileMode.WRITE);
				fs.writeUTFBytes(text);
				fs.close();
				return file.nativePath + " written.";
			}
			catch (err : Error) {
				return err.name;
			}
			return "Error writing file.";
		}
		
		public static function clearDirectory(_dir:File):Boolean
		{
			if(!_dir.exists) return false;
			if(!_dir.isDirectory) return false;
			//
			try{
				_dir.deleteDirectory(true);
			}catch(err:Error){
				return false;
			}
			//
			_dir.createDirectory();
			//
			return true;
		}
	}
}