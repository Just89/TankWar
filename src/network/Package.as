package network
{
	
	/**
	 * Package
	 * Wrapper for the message to be communicated between objects
	 *
	 * @version 1.0
	 * @author  Jens Kooij
	 */
	public class Package
	{
		/**
		 * The type of message
		 */
		private var _type:String;
		/**
		 * The message itself
		 */
		private var _message:String;
		
		/**
		 * The constructor
		 *
		 * @param	type
		 * @param	message
		 * @param	sender
		 */
		public function Package(type:String, message:String)
		{
			this._message = message;
			this._type = type;
		}
		
		/**
		 * Used for tracing
		 *
		 * @return String
		 */
		public function toString():String
		{
			return '[Package]' + "\n\t - [Type] \t" + this.type + "\n\t - [Message] \t" + this.message + "\n\t - [Sender] \t";
		}
		
		/**
		 * Getter for the message
		 *
		 * @return String
		 */
		public function get message():String
		{
			return _message;
		}
		
		/**
		 * Getter for the type
		 *
		 * @return String
		 */
		public function get type():String
		{
			return _type;
		}
	
	}

}