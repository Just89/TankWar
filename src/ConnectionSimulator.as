package  
{
	import network.Package;
	import network.PackageInterface;
	import network.PackageManager;
	/**
	 * ...
	 * @author ...
	 */
	public class ConnectionSimulator 
	{
		private static var _client1:PackageManager;
		private static var _client2:PackageManager;
		
		public static function registerClient(manager:PackageManager):void
		{
			if (_client1 == null)
			{
				_client1 = manager;
			}
			else
			{
				_client2 = manager;
			}
		}
		
		public static function send(client:PackageManager, pkg:Package):void
		{
			if (_client1 == client)
			{
				_client2.recieveMessage(pkg);
			}
			else if (_client2 == client)
			{
				_client1.recieveMessage(pkg);
			}
		}
	}
}