package haxe.lang;private typedef NativeString = String;/** * ... * @author waneck */@:keep @:nativegen @:native("haxe.lang.StringExt") private class StringExt{	@:functionBody('			if ( index >= me.length() || index < 0 )				return null;			else				return java.lang.Character.toString(me.charAt(index));	')	public static function charAt(me:NativeString, index:Int):NativeString	{		return null;	}		@:functionBody('			if ( index >= me.length() || index < 0 )				return null;			else				return me.codePointAt(index);	')	public static function charCodeAt(me:NativeString, index:Int):Null<Int>	{		return null;	}		@:functionBody('			int sIndex = (startIndex != null ) ? (haxe.lang.Runtime.toInt(startIndex)) : 0;			if (sIndex >= me.length() || sIndex < 0)				return -1;			return me.indexOf(str, sIndex);	')	public static function indexOf(me:NativeString, str:NativeString, ?startIndex:Int):Int	{		return -1;	}		@:functionBody('			int sIndex = (startIndex != null ) ? (haxe.lang.Runtime.toInt(startIndex)) : (me.length() - 1);			if (sIndex > me.length() || sIndex < 0)				sIndex = me.length() - 1;			else if (sIndex < 0)				return -1;			return me.lastIndexOf(str, sIndex);	')	public static function lastIndexOf(me:NativeString, str:NativeString, ?startIndex:Int):Int	{		return -1;	}		@:functionBody('			Array<java.lang.String> ret = new Array<java.lang.String>();						int slen = delimiter.length();			if (slen == 0)			{				int len = me.length();				for (int i = 0; i < len; i++)				{					ret.push(me.substring(i, i + 1));				}			} else {				int start = 0;				int pos = me.indexOf(delimiter, start);								while (pos > 0)				{					ret.push(me.substring(start, pos));										start = pos + slen;					pos = me.indexOf(delimiter, start);				}								ret.push(me.substring(start));			}			return ret;	')	public static function split(me:NativeString, delimiter:NativeString):Array<NativeString>	{		return null;	}		@:functionBody('			int meLen = me.length();			int targetLen = meLen;			if (len != null)			{				targetLen = haxe.lang.Runtime.toInt(len);				if (targetLen == 0)					return "";				if( pos != 0 && targetLen < 0 ){					return "";				}			}						if( pos < 0 ){				pos = meLen + pos;				if( pos < 0 ) pos = 0;			} else if( targetLen < 0 ){				targetLen = meLen + targetLen - pos;			}			if( pos + targetLen > meLen ){				targetLen = meLen - pos;			}			if ( pos < 0 || targetLen <= 0 ) return "";						return me.substring(pos, pos + targetLen);	')	public static function substr(me:NativeString, pos:Int, ?len:Int):NativeString	{		return null;	}		@:functionBody('			return me.toLowerCase();	')	public static function toLowerCase(me:NativeString):NativeString	{		return null;	}		@:functionBody('			return me.toUpperCase();	')	public static function toUpperCase(me:NativeString):NativeString	{		return null;	}		public static function toNativeString(me:NativeString):NativeString	{		return me;	}		@:functionBody('		return java.lang.Character.toString( (char) code );	')	public static function fromCharCode(code:Int):NativeString	{		return null;	}}@:keep class StringRefl{	private var target:NativeString;		public var length(default, null) : Int;		public function new(target:NativeString)	{		this.target = target;		this.length = target.length;	}		public function charAt( index : Int ) : NativeString	{		return StringExt.charAt(target, index);	}		public function charCodeAt( index : Int ) : Null<Int>	{		return StringExt.charCodeAt(target, index);	}		public function indexOf( str : NativeString, ?startIndex : Int=0 ) : Int	{		return StringExt.indexOf(target, str, startIndex);	}		public function lastIndexOf( str : NativeString, ?startIndex : Int=-1 ) : Int	{		if (startIndex == -1) startIndex = length;		return StringExt.lastIndexOf(target, str, startIndex);	}		public function split( delimiter : NativeString ) : Array<NativeString>	{		return StringExt.split(target, delimiter);	}		public function substr( pos : Int, ?len : Int=-1 ) : NativeString	{		if (len == -1) len = length;		return StringExt.substr(target, pos, len);	}		public function toLowerCase() : NativeString	{		return StringExt.toLowerCase(target);	}		public function toString() : NativeString	{		return target;	}		public function toUpperCase() : NativeString	{		return StringExt.toUpperCase(target);	}		public static function fromCharCode( code : Int ) : NativeString	{		return StringExt.fromCharCode(code);	}}