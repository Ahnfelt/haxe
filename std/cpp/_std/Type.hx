/*
 * Copyright (C)2005-2012 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
enum ValueType {
	TNull;
	TInt;
	TFloat;
	TBool;
	TObject;
	TFunction;
	TClass( c : Class<Dynamic> );
	TEnum( e : Enum<Dynamic> );
	TUnknown;
}

@:coreApi class Type {
	public static function getClass<T>( o : T ) : Class<T> untyped {
			if (o==null || !Reflect.isObject(o))  return null;
			var c = o.__GetClass();
			switch(c.toString())
			{
				case "__Anon" : return null;
				case "Class" : return null;
			}
			return c;
	}

	public static function getEnum( o : EnumValue ) : Enum<Dynamic> untyped {
		if (o==null) return null;
		return untyped o.__GetClass();
	}


	public static function getSuperClass( c : Class<Dynamic> ) : Class<Dynamic> untyped {
		return c.GetSuper();
	}

	public static function getClassName( c : Class<Dynamic> ) : String {
		if( c == null )
			return null;
		return untyped c.mName;
	}

	public static function getEnumName( e : Enum<Dynamic> ) : String {
		return untyped e.__ToString();
	}

	public static function resolveClass( name : String ) : Class<Dynamic> untyped {
		var result:Class<Dynamic> = Class.Resolve(name);
		if (result!=null && result.__IsEnum() )
			return null;
		return result;
	}

	public static function resolveEnum( name : String ) : Enum<Dynamic> untyped {
		var result:Class<Dynamic> = Class.Resolve(name);
		if (result!=null && !result.__IsEnum() )
			return null;
		return result;
	}

	public static function createInstance<T>( cl : Class<T>, args : Array<Dynamic> ) : T untyped {
		if (cl!=null)
			return cl.mConstructArgs(args);
		return null;
	}

	public static function createEmptyInstance<T>( cl : Class<T> ) : T untyped {
		return cl.mConstructEmpty();
	}

	public static function createEnum<T>( e : Enum<T>, constr : String, ?params : Array<Dynamic> ) : T {
		if (untyped e.mConstructEnum != null)
			return untyped e.mConstructEnum(constr,params);
		return null;
	}

	public static function createEnumIndex<T>( e : Enum<T>, index : Int, ?params : Array<Dynamic> ) : T {
		var c = Type.getEnumConstructs(e)[index];
		if( c == null ) throw index+" is not a valid enum constructor index";
		return createEnum(e,c,params);
	}

	public static function getInstanceFields( c : Class<Dynamic> ) : Array<String> {
		return untyped c.GetInstanceFields();
	}

	public static function getClassFields( c : Class<Dynamic> ) : Array<String> {
			return untyped c.GetClassFields();
	}

	public static function getEnumConstructs( e : Enum<Dynamic> ) : Array<String> untyped {
			return untyped e.GetClassFields();
	}

	public static function typeof( v : Dynamic ) : ValueType untyped {
			if (v==null) return TNull;
			var t:Int = untyped v.__GetType();
			switch(t)
			{
				case untyped __global__.vtBool : return TBool;
				case untyped __global__.vtInt : return TInt;
				case untyped __global__.vtFloat : return TFloat;
				case untyped __global__.vtFunction : return TFunction;
				case untyped __global__.vtObject : return TObject;
				case untyped __global__.vtEnum : return TEnum(v.__GetClass());
				default:
					return untyped TClass(v.__GetClass());
			}
	}

	public static function enumEq<T>( a : T, b : T ) : Bool untyped {
			return a==b;
	}

	public static function enumConstructor( e : EnumValue ) : String {
			return untyped e.__Tag();
	}

	public static function enumParameters( e : EnumValue ) : Array<Dynamic> {
			var result : Array<Dynamic> =  untyped e.__EnumParams();
			return result==null ? [] : result;
	}

	public inline static function enumIndex( e : EnumValue ) : Int {
			return untyped e.__Index();
	}

	public static function allEnums<T>( e : Enum<T> ) : Array<T> {
      var names:Array<String> =  untyped e.GetClassFields();
		var enums = new Array<T>();
      for(name in names)
      {
         try {
            var result:T = untyped e.mConstructEnum(name,null);
            enums.push( result );
         } catch ( invalidArgCount:String) {
         }
      }
		return enums;
	}

}

