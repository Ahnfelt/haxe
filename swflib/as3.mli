(*
 *  This file is part of SwfLib
 *  Copyright (c)2004-2006 Nicolas Cannasse
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *)

type 'a index
type 'a index_nz

type as3_ident = string
type as3_int = int32
type as3_float = float

type as3_jump =
	| J3Lt
	| J3Lte
	| J3Gt
	| J3Gte
	| J3Always
	| J3Backward
	| J3True
	| J3Neq
	| J3Eq
	| J3PhysNeq
	| J3PhysEq

type as3_op_binop =
	| A3Incr
	| A3Decr
	| A3Not
	| A3BitNot
	| A3OAdd
	| A3OSub
	| A3OMul
	| A3ODiv
	| A3OMod
	| A3OShl
	| A3OShr
	| A3OUShr
	| A3OAnd
	| A3OOr
	| A3OXor
	| A3OEq
	| A3OPhysEq
	| A3OLt
	| A3OLte
	| A3OGt
	| A3OGte
	| A3Is
	| A3As

type as3_opcode =
	| A3Throw
	| A3StackReset of int
	| A3Nop
	| A3Jump of as3_jump * int
	| A3ForIn
	| A3Null
	| A3Undefined
	| A3ForEach
	| A3SmallInt of int
	| A3Int of int
	| A3True
	| A3False
	| A3Pop
	| A3Dup
	| A3String of int (* as3_ident index *)
	| A3IntRef of int (* as3_int index *)
	| A3Float of int (* as3_float index *)
	| A3Context
	| A3Next of int * int (* stack1 * stack2 *)
	| A3SuperCall of int * int (* as3_type index * nargs *)
	| A3Call of int * int (* as3_type index * nargs *)
	| A3RetVoid
	| A3Ret
	| A3New of int * int (* as3_type index * nargs *)
	| A3Object of int
	| A3Array of int
	| A3GetInf of int (* as3_type index *)
	| A3SetInf of int (* as3_type index *)
	| A3SetProp of int (* as3_type index *)
	| A3Stack of int
	| A3SetStack of int
	| A3Get of int (* as3_type index *)
	| A3Set of int (* as3_type index *)
	| A3Delete of int (* as3_type index *)
	| A3ToInt
	| A3ToUInt
	| A3ToNumber
	| A3ToBool
	| A3ToObject
	| A3Typeof
	| A3InstanceOf
	| A3This
	| A3DebugStack of int * int * int * int
	| A3DebugLine of int
	| A3DebugFile of int (* as3_ident index *)
	| A3Op of as3_op_binop
	| A3Unk of char

type as3_base_right =
	| A3RPrivate of as3_ident index option
	| A3RPublic of as3_ident index option
	| A3RInternal of as3_ident index option
	| A3RProtected of as3_ident index
	| A3RUnknown1 of as3_ident index
	| A3RUnknown2 of as3_ident index option

type as3_rights = as3_base_right index list

type as3_type =
	| A3TClassInterface of as3_ident index * as3_base_right index
	| A3TMethodVar of as3_ident index * as3_base_right index
	| A3TUnknown1 of int * int
	| A3TUnknown2 of int * int * int

type as3_value =
	| A3VNone
	| A3VNull
	| A3VBool of bool
	| A3VString of as3_ident index
	| A3VInt of as3_int index
	| A3VFloat of as3_float index
	| A3VNamespace of as3_base_right index

type as3_method_type = {
	mt3_ret : as3_type index option;
	mt3_args : as3_type index option list;
	mt3_native : bool;
	mt3_var_args : bool;
	mt3_debug_name : as3_ident index;
	mt3_dparams : as3_value list option;
	mt3_pnames : as3_ident index list option;
	mt3_unk_flags : bool * bool * bool * bool;
}

type as3_method_kind =
	| MK3Normal
	| MK3Getter
	| MK3Setter

type as3_method = {
	m3_type : as3_method_type index_nz;
	m3_final : bool;
	m3_override : bool;
	m3_kind : as3_method_kind;
}

type as3_var = {
	v3_type : as3_type index option;
	v3_value : as3_value;
	v3_const : bool;
}

type as3_metadata = {
	meta3_name : as3_ident index;
	meta3_data : (as3_ident index * as3_ident index) array;
}

type as3_field_kind =
	| A3FMethod of as3_method
	| A3FVar of as3_var
	| A3FClass of as3_class index_nz

and as3_field = {
	f3_name : as3_type index;
	f3_slot : int;
	f3_kind : as3_field_kind;
	f3_metas : as3_metadata index_nz array option;
}

and as3_class = {
	cl3_name : as3_type index;
	cl3_super : as3_type index option;
	cl3_sealed : bool;
	cl3_final : bool;
	cl3_interface : bool;
	cl3_rights : as3_base_right index option;
	cl3_implements : as3_type index array;
	cl3_construct : as3_method_type index_nz;
	cl3_fields : as3_field array;
}

type as3_static = {
	st3_method : as3_method_type index_nz;
	st3_fields : as3_field array;
}

type as3_function = {
	fun3_id : as3_method_type index_nz;
	fun3_unk1 : int;
	fun3_unk2 : int;
	fun3_unk3 : int;
	fun3_unk4 : int;
	fun3_code : as3_opcode list;
}

type as3_tag = {
	as3_ints : as3_int array;
	(* ??? *)
	as3_floats : as3_float array;
	as3_idents : as3_ident array;
	as3_base_rights : as3_base_right array;
	as3_rights : as3_rights array;
	mutable as3_types : as3_type array;
	mutable as3_method_types : as3_method_type array;
	mutable as3_metadatas : as3_metadata array;
	mutable as3_classes : as3_class array;
	mutable as3_statics : as3_static array;
	mutable as3_inits : as3_static array;
	mutable as3_functions : as3_function array;

	mutable as3_unknown : string;
	as3_original_data : string;
}
