package network
{
	
	/**
	 * PackageInterface
	 * All objects that use the Packagemanger should implement this interface
	 *
	 * @version 1.0
	 * @author  Jens Kooij
	 */
	public interface PackageInterface
	{
		/**
		 * The individual handler for messages that are send to the object
		 *
		 * @param	type
		 * @param	message
		 * @param	sender
		 */
		function receiveMessage(msg:Package):void;
	}

}