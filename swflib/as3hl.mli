open As3

type hl_ident = string
type hl_int = int32
type hl_uint = int32
type hl_float = float
type hl_slot = int
type hl_jump = as3_jump
type hl_op = as3_op

type hl_opcode =
	| HBreakPoint
	| HNop
	| HThrow
	| HGetSuper of hl_name
	| HSetSuper of hl_name
	| HRegKill of reg
	| HLabel
	| HJump of hl_jump * int
	| HSwitch of int * int list
	| HPushWith
	| HPopScope
	| HForIn
	| HHasNext
	| HNull
	| HUndefined
	| HForEach
	| HSmallInt of int
	| HInt of int
	| HTrue
	| HFalse
	| HNaN
	| HPop
	| HDup
	| HSwap
	| HString of hl_ident
	| HIntRef of hl_int
	| HUIntRef of hl_uint
	| HFloat of hl_float
	| HScope
	| HNamespace of hl_namespace
	| HNext of reg * reg
	| HFunction of hl_method
	| HCallStack of nargs
	| HConstruct of nargs
	| HCallMethod of hl_slot * nargs
	| HCallStatic of hl_method * nargs
	| HCallSuper of hl_name * nargs
	| HCallProperty of hl_name * nargs
	| HRetVoid
	| HRet
	| HConstructSuper of nargs
	| HConstructProperty of hl_name * nargs
	| HCallPropLex of hl_name * nargs
	| HCallSuperVoid of hl_name * nargs
	| HCallPropVoid of hl_name * nargs
	| HObject of nargs
	| HArray of nargs
	| HNewBlock
	| HClassDef of hl_class
	| HCatch of int
	| HFindPropStrict of hl_name
	| HFindProp of hl_name
	| HFindDefinition of hl_name
	| HGetLex of hl_name
	| HSetProp of hl_name
	| HReg of reg
	| HSetReg of reg
	| HGetGlobalScope
	| HGetScope of int
	| HGetProp of hl_name
	| HInitProp of hl_name
	| HDeleteProp of hl_name
	| HGetSlot of hl_slot
	| HSetSlot of hl_slot
	| HToString
	| HToXml
	| HToXmlAttr
	| HToInt
	| HToUInt
	| HToNumber
	| HToBool
	| HToObject
	| HCheckIsXml
	| HCast of hl_name
	| HAsAny
	| HAsString
	| HAsType of hl_name
	| HAsObject
	| HIncrReg of reg
	| HDecrReg of reg
	| HTypeof
	| HInstanceOf
	| HIsType of hl_name
	| HIncrIReg of reg
	| HDecrIReg of reg
	| HThis
	| HSetThis
	| HDebugReg of hl_ident * reg * int
	| HDebugLine of int
	| HDebugFile of hl_ident
	| HBreakPointLine of int
	| HTimestamp
	| HOp of hl_op
	| HUnk of char

and hl_namespace =
	| HNPrivate of hl_ident option
	| HNPublic of hl_ident option
	| HNInternal of hl_ident option
	| HNProtected of hl_ident
	| HNNamespace of hl_ident
	| HNExplicit of hl_ident
	| HNStaticProtected of hl_ident option

and hl_ns_set = hl_namespace list

and hl_name =
	| HMName of hl_ident * hl_namespace
	| HMMultiName of hl_ident option * hl_ns_set
	| HMRuntimeName of hl_ident
	| HMRuntimeNameLate
	| HMMultiNameLate of hl_ns_set
	| HMAttrib of hl_name

and hl_value =
	| HVNone
	| HVNull
	| HVBool of bool
	| HVString of hl_ident
	| HVInt of hl_int
	| HVUInt of hl_uint
	| HVFloat of hl_float
	| HVNamespace of int * hl_namespace

and hl_method = {
	hlmt_mark : int;
	hlmt_ret : hl_name option;
	hlmt_args : hl_name option list;
	hlmt_native : bool;
	hlmt_var_args : bool;
	hlmt_arguments_defined : bool;
	hlmt_uses_dxns : bool;
	hlmt_new_block : bool;
	hlmt_unused_flag : bool;
	hlmt_debug_name : hl_ident option;
	hlmt_dparams : hl_value list option;
	hlmt_pnames : hl_ident list option;
	hlmt_function : hl_function;
}

and hl_try_catch = {
	hltc_start : int;
	hltc_end : int;
	hltc_handle : int;
	hltc_type : hl_name option;
	hltc_name : hl_name option;
}

and hl_function = {
	hlf_stack_size : int;
	hlf_nregs : int;
	hlf_init_scope : int;
	hlf_max_scope : int;
	mutable hlf_code : hl_opcode array;
	hlf_trys : hl_try_catch array;
	hlf_locals : (hl_name * hl_name option * hl_slot) array;
}

and hl_method_kind = as3_method_kind

and hl_method_field = {
	hlm_type : hl_method;
	hlm_final : bool;
	hlm_override : bool;
	hlm_kind : hl_method_kind;
}

and hl_var_field = {
	hlv_type : hl_name option;
	hlv_value : hl_value;
	hlv_const : bool;
}

and hl_metadata = {
	hlmeta_name : hl_ident;
	hlmeta_data : (hl_ident option * hl_ident) array;
}

and hl_field_kind =
	| HFMethod of hl_method_field
	| HFVar of hl_var_field
	| HFFunction of hl_method
	| HFClass of hl_class (* only for hl_static fields *)

and hl_field = {
	hlf_name : hl_name;
	hlf_slot : hl_slot;
	hlf_kind : hl_field_kind;
	hlf_metas : hl_metadata array option;
}

and hl_class = {
	hlc_name : hl_name;
	hlc_super : hl_name option;
	hlc_sealed : bool;
	hlc_final : bool;
	hlc_interface : bool;
	hlc_namespace : hl_namespace option;
	hlc_implements : hl_name array;
	hlc_construct : hl_method;
	hlc_fields : hl_field array;
	hlc_static_construct : hl_method;
	hlc_static_fields : hl_field array;
}

and hl_static = {
	hls_method : hl_method;
	hls_fields : hl_field array;
}

and hl_tag = hl_static list
