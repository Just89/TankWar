package tank.expansions
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.ErrorEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import tank.expansions.weapon.Weapon;
	
	/**
	 * ...
	 * @author Automatic
	 */
	public class ExpansionLibrary
	{
		private var _sqlConnection:SQLConnection;
		
		private var _initDatabase:Boolean = false;
		
		private var _blocks:Vector.<Block> = new Vector.<Block>();
		private var _weapons:Vector.<Weapon> = new Vector.<Weapon>();
		
		public function ExpansionLibrary()
		{
			_sqlConnection = new SQLConnection();
			_sqlConnection.addEventListener(SQLErrorEvent.ERROR, onError);
			_sqlConnection.addEventListener(SQLEvent.OPEN, onOpen);
			
			var dbFile:File = File.applicationStorageDirectory.resolvePath("expansions.db");
				
			CONFIG::debug {
				if (dbFile.exists)
				{
					dbFile.deleteFile();
				}				
			}
			
			if (!dbFile.exists)
			{
				_initDatabase = true;
			}
			
			_sqlConnection.open(dbFile);
		}
		
		public function closeConnection():void 
		{
			_sqlConnection.close();
		}
		
		private function onOpen(e:SQLEvent):void
		{
			if (_initDatabase)
			{
				initDatabase();
			}
			
			var sqlStatement:SQLStatement = new SQLStatement();
				sqlStatement.sqlConnection = _sqlConnection;
				sqlStatement.itemClass = Block;
				sqlStatement.text = "SELECT * FROM blocks";
				sqlStatement.execute();
			
			for each(var block:Block in sqlStatement.getResult().data)
			{
				block.load();
				block.lock();
				_blocks.push(block);
			}
			
			sqlStatement.itemClass = Weapon;
			sqlStatement.text = "SELECT weapons.*, blocks.* FROM blocks, weapons WHERE blocks.id = weapons.blockid ;";
			sqlStatement.execute();
			
			for each(var weapon:Weapon in sqlStatement.getResult().data)
			{
				weapon.load();
				weapon.lock();
				_weapons.push(weapon);
			}
		}
		
		private function initDatabase():void
		{
			var file:File = File.applicationDirectory.resolvePath("databasescripts\\database 1.txt");
			
			var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				
			var string:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
				fileStream.close();
			
			var querys:Array = string.split("\n");
			
			_sqlConnection.begin();
			
			for each (var query:String in querys)
			{
				if (query.indexOf("//") == -1)
				{
					var sqlStatement:SQLStatement = new SQLStatement();
					sqlStatement.sqlConnection = _sqlConnection;
					sqlStatement.text = query;
					sqlStatement.execute();
				}
			}
			
			_sqlConnection.commit();
		}
		
		private function onError(e:ErrorEvent):void
		{
			trace(e);
		}
		
		public function get blocks():Vector.<Block> 
		{
			return _blocks;
		}
		
		public function get weapons():Vector.<Weapon> 
		{
			return _weapons;
		}
		
		
		/* SINGLETON */
		private static var _instance:ExpansionLibrary = new ExpansionLibrary();
		
		public static function get instance():ExpansionLibrary
		{
			return _instance;
		}
	
	}
}