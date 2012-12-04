package network
{
	import flash.utils.Dictionary;
	
	/**
	 * Singleton Object PackageManager
	 * Takes care of (internal) communication between objects
	 *
	 * @version 1.0
	 * @author  Jens Kooij
	 */
	public class PackageManager
	{
		/**
		 * An Array containing all send messages
		 */
		public var messages:Array = new Array();
		/**
		 * An Array containing all registered objects that want to talk with eachother :-)
		 */
		public var objects:Vector.<PackageInterface> = new Vector.<PackageInterface>();
		
		/**
		 * The constructor, initializing the Singleton instance
		 *
		 */
		public function PackageManager()
		{
			ConnectionSimulator.registerClient(this);
		}
		
		/**
		 * Sends the message to the socket server, or in this case, just return true;
		 * Also makes the PackageManager send the message to all registered Objects, except the sender
		 *
		 * @param	type
		 * @param	theMessage
		 * @return	Boolean
		 */
		public function sendMessage(type:String, message:String):Boolean
		{
			// Insert Socket code here ... :-)
			if (true)
			{
				var pkg:Package = new Package(type, message);
				
				this.messages.push(pkg);
				
				ConnectionSimulator.send(this, pkg);
				
				return true;
			}
		}
		
		/**
		 * 
		 * @param	pkg
		 * @return
		 */
		public function recieveMessage(pkg:Package):Boolean
		{
			// Insert Socket code here ... :-)
			if (true)
			{
				for (var i:int = 0; i < objects.length; i++) 
				{
					objects[i].receiveMessage(pkg);
				}
				return true;
			}
		}
		
		
		
		/**
		 * Places the object in the object-pointer-array
		 *
		 * @param	obj
		 * @return  Boolean
		 */
		public function registerObject(obj:Object):Boolean
		{
			this.objects.push(obj);
			return true;
		}
	
	}

}