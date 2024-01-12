grammar Spirv;

options { tokenVocab = SpirvLexer; }

spv : (op | opRet)* EOF;
opRet : idResult Equals opWithRet;

// Annotation Operations
opDecorate : Op Decorate targetIdRef decoration;
opMemberDecorate : Op MemberDecorate structureType member decoration;
opDecorationGroup : (Op DecorationGroup  | DecorationGroup);
opGroupDecorate : Op GroupDecorate decorationGroup targetsIdRef*;
opGroupMemberDecorate : Op GroupMemberDecorate decorationGroup targetsPairIdRefLiteralInteger*;
opDecorateId : Op DecorateId targetIdRef decoration;
opDecorateString : Op DecorateString targetIdRef decoration;
opDecorateStringGOOGLE : Op DecorateStringGOOGLE targetIdRef decoration;
opMemberDecorateString : Op MemberDecorateString structType member decoration;
opMemberDecorateStringGOOGLE : Op MemberDecorateStringGOOGLE structType member decoration;

// Arithmetic Operations
opSNegate : (Op SNegate idResultType | SNegate) operand;
opFNegate : (Op FNegate idResultType | FNegate) operand;
opIAdd : (Op IAdd idResultType | IAdd) operand1 operand2;
opFAdd : (Op FAdd idResultType | FAdd) operand1 operand2;
opISub : (Op ISub idResultType | ISub) operand1 operand2;
opFSub : (Op FSub idResultType | FSub) operand1 operand2;
opIMul : (Op IMul idResultType | IMul) operand1 operand2;
opFMul : (Op FMul idResultType | FMul) operand1 operand2;
opUDiv : (Op UDiv idResultType | UDiv) operand1 operand2;
opSDiv : (Op SDiv idResultType | SDiv) operand1 operand2;
opFDiv : (Op FDiv idResultType | FDiv) operand1 operand2;
opUMod : (Op UMod idResultType | UMod) operand1 operand2;
opSRem : (Op SRem idResultType | SRem) operand1 operand2;
opSMod : (Op SMod idResultType | SMod) operand1 operand2;
opFRem : (Op FRem idResultType | FRem) operand1 operand2;
opFMod : (Op FMod idResultType | FMod) operand1 operand2;
opVectorTimesScalar : (Op VectorTimesScalar idResultType | VectorTimesScalar) vectorIdRef scalar;
opMatrixTimesScalar : (Op MatrixTimesScalar idResultType | MatrixTimesScalar) matrix scalar;
opVectorTimesMatrix : (Op VectorTimesMatrix idResultType | VectorTimesMatrix) vectorIdRef matrix;
opMatrixTimesVector : (Op MatrixTimesVector idResultType | MatrixTimesVector) matrix vectorIdRef;
opMatrixTimesMatrix : (Op MatrixTimesMatrix idResultType | MatrixTimesMatrix) leftMatrix rightMatrix;
opOuterProduct : (Op OuterProduct idResultType | OuterProduct) vector1 vector2;
opDot : (Op Dot idResultType | Dot) vector1 vector2;
opIAddCarry : (Op IAddCarry idResultType | IAddCarry) operand1 operand2;
opISubBorrow : (Op ISubBorrow idResultType | ISubBorrow) operand1 operand2;
opUMulExtended : (Op UMulExtended idResultType | UMulExtended) operand1 operand2;
opSMulExtended : (Op SMulExtended idResultType | SMulExtended) operand1 operand2;
opSDot : (Op SDot idResultType | SDot) vector1 vector2 packedVectorFormat?;
opSDotKHR : (Op SDotKHR idResultType | SDotKHR) vector1 vector2 packedVectorFormat?;
opUDot : (Op UDot idResultType | UDot) vector1 vector2 packedVectorFormat?;
opUDotKHR : (Op UDotKHR idResultType | UDotKHR) vector1 vector2 packedVectorFormat?;
opSUDot : (Op SUDot idResultType | SUDot) vector1 vector2 packedVectorFormat?;
opSUDotKHR : (Op SUDotKHR idResultType | SUDotKHR) vector1 vector2 packedVectorFormat?;
opSDotAccSat : (Op SDotAccSat idResultType | SDotAccSat) vector1 vector2 accumulator packedVectorFormat?;
opSDotAccSatKHR : (Op SDotAccSatKHR idResultType | SDotAccSatKHR) vector1 vector2 accumulator packedVectorFormat?;
opUDotAccSat : (Op UDotAccSat idResultType | UDotAccSat) vector1 vector2 accumulator packedVectorFormat?;
opUDotAccSatKHR : (Op UDotAccSatKHR idResultType | UDotAccSatKHR) vector1 vector2 accumulator packedVectorFormat?;
opSUDotAccSat : (Op SUDotAccSat idResultType | SUDotAccSat) vector1 vector2 accumulator packedVectorFormat?;
opSUDotAccSatKHR : (Op SUDotAccSatKHR idResultType | SUDotAccSatKHR) vector1 vector2 accumulator packedVectorFormat?;
opCooperativeMatrixMulAddKHR : (Op CooperativeMatrixMulAddKHR idResultType | CooperativeMatrixMulAddKHR) a b c cooperativeMatrixOperands?;

// Atomic Operations
opAtomicLoad : (Op AtomicLoad idResultType | AtomicLoad) pointer memory semantics;
opAtomicStore : Op AtomicStore pointer memory semantics valueIdRef;
opAtomicExchange : (Op AtomicExchange idResultType | AtomicExchange) pointer memory semantics valueIdRef;
opAtomicCompareExchange : (Op AtomicCompareExchange idResultType | AtomicCompareExchange) pointer memory equal unequal valueIdRef comparator;
opAtomicCompareExchangeWeak : (Op AtomicCompareExchangeWeak idResultType | AtomicCompareExchangeWeak) pointer memory equal unequal valueIdRef comparator;
opAtomicIIncrement : (Op AtomicIIncrement idResultType | AtomicIIncrement) pointer memory semantics;
opAtomicIDecrement : (Op AtomicIDecrement idResultType | AtomicIDecrement) pointer memory semantics;
opAtomicIAdd : (Op AtomicIAdd idResultType | AtomicIAdd) pointer memory semantics valueIdRef;
opAtomicISub : (Op AtomicISub idResultType | AtomicISub) pointer memory semantics valueIdRef;
opAtomicSMin : (Op AtomicSMin idResultType | AtomicSMin) pointer memory semantics valueIdRef;
opAtomicUMin : (Op AtomicUMin idResultType | AtomicUMin) pointer memory semantics valueIdRef;
opAtomicSMax : (Op AtomicSMax idResultType | AtomicSMax) pointer memory semantics valueIdRef;
opAtomicUMax : (Op AtomicUMax idResultType | AtomicUMax) pointer memory semantics valueIdRef;
opAtomicAnd : (Op AtomicAnd idResultType | AtomicAnd) pointer memory semantics valueIdRef;
opAtomicOr : (Op AtomicOr idResultType | AtomicOr) pointer memory semantics valueIdRef;
opAtomicXor : (Op AtomicXor idResultType | AtomicXor) pointer memory semantics valueIdRef;
opAtomicFlagTestAndSet : (Op AtomicFlagTestAndSet idResultType | AtomicFlagTestAndSet) pointer memory semantics;
opAtomicFlagClear : Op AtomicFlagClear pointer memory semantics;
opAtomicFMinEXT : (Op AtomicFMinEXT idResultType | AtomicFMinEXT) pointer memory semantics valueIdRef;
opAtomicFMaxEXT : (Op AtomicFMaxEXT idResultType | AtomicFMaxEXT) pointer memory semantics valueIdRef;
opAtomicFAddEXT : (Op AtomicFAddEXT idResultType | AtomicFAddEXT) pointer memory semantics valueIdRef;

// Barrier Operations
opControlBarrier : Op ControlBarrier execution memory semantics;
opMemoryBarrier : Op MemoryBarrier memory semantics;
opNamedBarrierInitialize : (Op NamedBarrierInitialize idResultType | NamedBarrierInitialize) subgroupCount;
opMemoryNamedBarrier : Op MemoryNamedBarrier namedBarrier memory semantics;
opControlBarrierArriveINTEL : Op ControlBarrierArriveINTEL execution memory semantics;
opControlBarrierWaitINTEL : Op ControlBarrierWaitINTEL execution memory semantics;

// Bit Operations
opShiftRightLogical : (Op ShiftRightLogical idResultType | ShiftRightLogical) base shift;
opShiftRightArithmetic : (Op ShiftRightArithmetic idResultType | ShiftRightArithmetic) base shift;
opShiftLeftLogical : (Op ShiftLeftLogical idResultType | ShiftLeftLogical) base shift;
opBitwiseOr : (Op BitwiseOr idResultType | BitwiseOr) operand1 operand2;
opBitwiseXor : (Op BitwiseXor idResultType | BitwiseXor) operand1 operand2;
opBitwiseAnd : (Op BitwiseAnd idResultType | BitwiseAnd) operand1 operand2;
opNot : (Op Not idResultType | Not) operand;
opBitFieldInsert : (Op BitFieldInsert idResultType | BitFieldInsert) base insert offsetIdRef count;
opBitFieldSExtract : (Op BitFieldSExtract idResultType | BitFieldSExtract) base offsetIdRef count;
opBitFieldUExtract : (Op BitFieldUExtract idResultType | BitFieldUExtract) base offsetIdRef count;
opBitReverse : (Op BitReverse idResultType | BitReverse) base;
opBitCount : (Op BitCount idResultType | BitCount) base;

// Composite Operations
opVectorExtractDynamic : (Op VectorExtractDynamic idResultType | VectorExtractDynamic) vectorIdRef indexIdRef;
opVectorInsertDynamic : (Op VectorInsertDynamic idResultType | VectorInsertDynamic) vectorIdRef componentIdRef indexIdRef;
opVectorShuffle : (Op VectorShuffle idResultType | VectorShuffle) vector1 vector2 components*;
opCompositeConstruct : (Op CompositeConstruct idResultType | CompositeConstruct) constituents*;
opCompositeExtract : (Op CompositeExtract idResultType | CompositeExtract) composite indexesLiteralInteger*;
opCompositeInsert : (Op CompositeInsert idResultType | CompositeInsert) object composite indexesLiteralInteger*;
opCopyObject : (Op CopyObject idResultType | CopyObject) operand;
opTranspose : (Op Transpose idResultType | Transpose) matrix;
opCopyLogical : (Op CopyLogical idResultType | CopyLogical) operand;
opCompositeConstructContinuedINTEL : (Op CompositeConstructContinuedINTEL idResultType | CompositeConstructContinuedINTEL) constituents*;

// Constant-Creation Operations
opConstantTrue : (Op ConstantTrue idResultType | ConstantTrue);
opConstantFalse : (Op ConstantFalse idResultType | ConstantFalse);
opConstant : (Op Constant idResultType | Constant) valueLiteralContextDependentNumber;
opConstantComposite : (Op ConstantComposite idResultType | ConstantComposite) constituents*;
opConstantSampler : (Op ConstantSampler idResultType | ConstantSampler) samplerAddressingMode paramLiteralInteger samplerFilterMode;
opConstantNull : (Op ConstantNull idResultType | ConstantNull);
opSpecConstantTrue : (Op SpecConstantTrue idResultType | SpecConstantTrue);
opSpecConstantFalse : (Op SpecConstantFalse idResultType | SpecConstantFalse);
opSpecConstant : (Op SpecConstant idResultType | SpecConstant) valueLiteralContextDependentNumber;
opSpecConstantComposite : (Op SpecConstantComposite idResultType | SpecConstantComposite) constituents*;
opSpecConstantOp : (Op SpecConstantOp idResultType | SpecConstantOp) opcode;
opConstantCompositeContinuedINTEL : Op ConstantCompositeContinuedINTEL constituents*;
opSpecConstantCompositeContinuedINTEL : Op SpecConstantCompositeContinuedINTEL constituents*;

// Control-Flow Operations
opPhi : (Op Phi idResultType | Phi) variable*;
opLoopMerge : Op LoopMerge mergeBlock continueTarget loopControl;
opSelectionMerge : Op SelectionMerge mergeBlock selectionControl;
opLabel : (Op Label  | Label);
opBranch : Op Branch targetLabel;
opBranchConditional : Op BranchConditional condition trueLabel falseLabel branchWeights*;
opSwitch : Op Switch selector default targetPairLiteralIntegerIdRef*;
opKill : Op Kill;
opReturn : Op Return;
opReturnValue : Op ReturnValue valueIdRef;
opUnreachable : Op Unreachable;
opLifetimeStart : Op LifetimeStart pointer sizeLiteralInteger;
opLifetimeStop : Op LifetimeStop pointer sizeLiteralInteger;
opTerminateInvocation : Op TerminateInvocation;
opDemoteToHelperInvocation : Op DemoteToHelperInvocation;
opDemoteToHelperInvocationEXT : Op DemoteToHelperInvocationEXT;

// Conversion Operations
opConvertFToU : (Op ConvertFToU idResultType | ConvertFToU) floatValue;
opConvertFToS : (Op ConvertFToS idResultType | ConvertFToS) floatValue;
opConvertSToF : (Op ConvertSToF idResultType | ConvertSToF) signedValue;
opConvertUToF : (Op ConvertUToF idResultType | ConvertUToF) unsignedValue;
opUConvert : (Op UConvert idResultType | UConvert) unsignedValue;
opSConvert : (Op SConvert idResultType | SConvert) signedValue;
opFConvert : (Op FConvert idResultType | FConvert) floatValue;
opQuantizeToF16 : (Op QuantizeToF16 idResultType | QuantizeToF16) valueIdRef;
opConvertPtrToU : (Op ConvertPtrToU idResultType | ConvertPtrToU) pointer;
opSatConvertSToU : (Op SatConvertSToU idResultType | SatConvertSToU) signedValue;
opSatConvertUToS : (Op SatConvertUToS idResultType | SatConvertUToS) unsignedValue;
opConvertUToPtr : (Op ConvertUToPtr idResultType | ConvertUToPtr) integerValue;
opPtrCastToGeneric : (Op PtrCastToGeneric idResultType | PtrCastToGeneric) pointer;
opGenericCastToPtr : (Op GenericCastToPtr idResultType | GenericCastToPtr) pointer;
opGenericCastToPtrExplicit : (Op GenericCastToPtrExplicit idResultType | GenericCastToPtrExplicit) pointer storage;
opBitcast : (Op Bitcast idResultType | Bitcast) operand;
opConvertFToBF16INTEL : (Op ConvertFToBF16INTEL idResultType | ConvertFToBF16INTEL) floatValue;
opConvertBF16ToFINTEL : (Op ConvertBF16ToFINTEL idResultType | ConvertBF16ToFINTEL) bFloat16Value;

// Debug Operations
opSourceContinued : Op SourceContinued continuedSource;
opSource : Op Source sourceLanguage version file? sourceLiteralString?;
opSourceExtension : Op SourceExtension extension;
opName : Op Name targetIdRef nameLiteralString;
opMemberName : Op MemberName type member nameLiteralString;
opString : (Op String  | String) string;
opLine : Op Line file line column;
opNoLine : Op NoLine;
opModuleProcessed : Op ModuleProcessed process;

// Derivative Operations
opDPdx : (Op DPdx idResultType | DPdx) p;
opDPdy : (Op DPdy idResultType | DPdy) p;
opFwidth : (Op Fwidth idResultType | Fwidth) p;
opDPdxFine : (Op DPdxFine idResultType | DPdxFine) p;
opDPdyFine : (Op DPdyFine idResultType | DPdyFine) p;
opFwidthFine : (Op FwidthFine idResultType | FwidthFine) p;
opDPdxCoarse : (Op DPdxCoarse idResultType | DPdxCoarse) p;
opDPdyCoarse : (Op DPdyCoarse idResultType | DPdyCoarse) p;
opFwidthCoarse : (Op FwidthCoarse idResultType | FwidthCoarse) p;

// Device-Side_Enqueue Operations
opEnqueueMarker : (Op EnqueueMarker idResultType | EnqueueMarker) queue numEvents waitEvents retEvent;
opEnqueueKernel : (Op EnqueueKernel idResultType | EnqueueKernel) queue flags nDRange numEvents waitEvents retEvent invoke paramIdRef paramSize paramAlign localSize*;
opGetKernelNDrangeSubGroupCount : (Op GetKernelNDrangeSubGroupCount idResultType | GetKernelNDrangeSubGroupCount) nDRange invoke paramIdRef paramSize paramAlign;
opGetKernelNDrangeMaxSubGroupSize : (Op GetKernelNDrangeMaxSubGroupSize idResultType | GetKernelNDrangeMaxSubGroupSize) nDRange invoke paramIdRef paramSize paramAlign;
opGetKernelWorkGroupSize : (Op GetKernelWorkGroupSize idResultType | GetKernelWorkGroupSize) invoke paramIdRef paramSize paramAlign;
opGetKernelPreferredWorkGroupSizeMultiple : (Op GetKernelPreferredWorkGroupSizeMultiple idResultType | GetKernelPreferredWorkGroupSizeMultiple) invoke paramIdRef paramSize paramAlign;
opRetainEvent : Op RetainEvent event;
opReleaseEvent : Op ReleaseEvent event;
opCreateUserEvent : (Op CreateUserEvent idResultType | CreateUserEvent);
opIsValidEvent : (Op IsValidEvent idResultType | IsValidEvent) event;
opSetUserEventStatus : Op SetUserEventStatus event status;
opCaptureEventProfilingInfo : Op CaptureEventProfilingInfo event profilingInfo valueIdRef;
opGetDefaultQueue : (Op GetDefaultQueue idResultType | GetDefaultQueue);
opBuildNDRange : (Op BuildNDRange idResultType | BuildNDRange) globalWorkSize localWorkSize globalWorkOffset;
opGetKernelLocalSizeForSubgroupCount : (Op GetKernelLocalSizeForSubgroupCount idResultType | GetKernelLocalSizeForSubgroupCount) subgroupCount invoke paramIdRef paramSize paramAlign;
opGetKernelMaxNumSubgroups : (Op GetKernelMaxNumSubgroups idResultType | GetKernelMaxNumSubgroups) invoke paramIdRef paramSize paramAlign;

// Extension Operations
opExtension : Op Extension nameLiteralString;
opExtInstImport : (Op ExtInstImport  | ExtInstImport) nameLiteralString;
opExtInst : (Op ExtInst idResultType | ExtInst) set instruction operand*;

// Function Operations
opFunction : (Op Function idResultType | Function) functionControl functionType;
opFunctionParameter : (Op FunctionParameter idResultType | FunctionParameter);
opFunctionEnd : Op FunctionEnd;
opFunctionCall : (Op FunctionCall idResultType | FunctionCall) function argument*;

// Group Operations
opGroupAsyncCopy : (Op GroupAsyncCopy idResultType | GroupAsyncCopy) execution destination sourceIdRef numElements stride event;
opGroupWaitEvents : Op GroupWaitEvents execution numEvents eventsList;
opGroupAll : (Op GroupAll idResultType | GroupAll) execution predicate;
opGroupAny : (Op GroupAny idResultType | GroupAny) execution predicate;
opGroupBroadcast : (Op GroupBroadcast idResultType | GroupBroadcast) execution valueIdRef localId;
opGroupIAdd : (Op GroupIAdd idResultType | GroupIAdd) execution operation x;
opGroupFAdd : (Op GroupFAdd idResultType | GroupFAdd) execution operation x;
opGroupFMin : (Op GroupFMin idResultType | GroupFMin) execution operation x;
opGroupUMin : (Op GroupUMin idResultType | GroupUMin) execution operation x;
opGroupSMin : (Op GroupSMin idResultType | GroupSMin) execution operation x;
opGroupFMax : (Op GroupFMax idResultType | GroupFMax) execution operation x;
opGroupUMax : (Op GroupUMax idResultType | GroupUMax) execution operation x;
opGroupSMax : (Op GroupSMax idResultType | GroupSMax) execution operation x;
opSubgroupBallotKHR : (Op SubgroupBallotKHR idResultType | SubgroupBallotKHR) predicate;
opSubgroupFirstInvocationKHR : (Op SubgroupFirstInvocationKHR idResultType | SubgroupFirstInvocationKHR) valueIdRef;
opSubgroupAllKHR : (Op SubgroupAllKHR idResultType | SubgroupAllKHR) predicate;
opSubgroupAnyKHR : (Op SubgroupAnyKHR idResultType | SubgroupAnyKHR) predicate;
opSubgroupAllEqualKHR : (Op SubgroupAllEqualKHR idResultType | SubgroupAllEqualKHR) predicate;
opGroupNonUniformRotateKHR : (Op GroupNonUniformRotateKHR idResultType | GroupNonUniformRotateKHR) execution valueIdRef delta clusterSize?;
opSubgroupReadInvocationKHR : (Op SubgroupReadInvocationKHR idResultType | SubgroupReadInvocationKHR) valueIdRef indexIdRef;
opGroupIAddNonUniformAMD : (Op GroupIAddNonUniformAMD idResultType | GroupIAddNonUniformAMD) execution operation x;
opGroupFAddNonUniformAMD : (Op GroupFAddNonUniformAMD idResultType | GroupFAddNonUniformAMD) execution operation x;
opGroupFMinNonUniformAMD : (Op GroupFMinNonUniformAMD idResultType | GroupFMinNonUniformAMD) execution operation x;
opGroupUMinNonUniformAMD : (Op GroupUMinNonUniformAMD idResultType | GroupUMinNonUniformAMD) execution operation x;
opGroupSMinNonUniformAMD : (Op GroupSMinNonUniformAMD idResultType | GroupSMinNonUniformAMD) execution operation x;
opGroupFMaxNonUniformAMD : (Op GroupFMaxNonUniformAMD idResultType | GroupFMaxNonUniformAMD) execution operation x;
opGroupUMaxNonUniformAMD : (Op GroupUMaxNonUniformAMD idResultType | GroupUMaxNonUniformAMD) execution operation x;
opGroupSMaxNonUniformAMD : (Op GroupSMaxNonUniformAMD idResultType | GroupSMaxNonUniformAMD) execution operation x;
opSubgroupShuffleINTEL : (Op SubgroupShuffleINTEL idResultType | SubgroupShuffleINTEL) data invocationId;
opSubgroupShuffleDownINTEL : (Op SubgroupShuffleDownINTEL idResultType | SubgroupShuffleDownINTEL) current next delta;
opSubgroupShuffleUpINTEL : (Op SubgroupShuffleUpINTEL idResultType | SubgroupShuffleUpINTEL) previous current delta;
opSubgroupShuffleXorINTEL : (Op SubgroupShuffleXorINTEL idResultType | SubgroupShuffleXorINTEL) data valueIdRef;
opSubgroupBlockReadINTEL : (Op SubgroupBlockReadINTEL idResultType | SubgroupBlockReadINTEL) ptr;
opSubgroupBlockWriteINTEL : Op SubgroupBlockWriteINTEL ptr data;
opSubgroupImageBlockReadINTEL : (Op SubgroupImageBlockReadINTEL idResultType | SubgroupImageBlockReadINTEL) image coordinate;
opSubgroupImageBlockWriteINTEL : Op SubgroupImageBlockWriteINTEL image coordinate data;
opSubgroupImageMediaBlockReadINTEL : (Op SubgroupImageMediaBlockReadINTEL idResultType | SubgroupImageMediaBlockReadINTEL) image coordinate widthIdRef height;
opSubgroupImageMediaBlockWriteINTEL : Op SubgroupImageMediaBlockWriteINTEL image coordinate widthIdRef height data;
opGroupIMulKHR : (Op GroupIMulKHR idResultType | GroupIMulKHR) execution operation x;
opGroupFMulKHR : (Op GroupFMulKHR idResultType | GroupFMulKHR) execution operation x;
opGroupBitwiseAndKHR : (Op GroupBitwiseAndKHR idResultType | GroupBitwiseAndKHR) execution operation x;
opGroupBitwiseOrKHR : (Op GroupBitwiseOrKHR idResultType | GroupBitwiseOrKHR) execution operation x;
opGroupBitwiseXorKHR : (Op GroupBitwiseXorKHR idResultType | GroupBitwiseXorKHR) execution operation x;
opGroupLogicalAndKHR : (Op GroupLogicalAndKHR idResultType | GroupLogicalAndKHR) execution operation x;
opGroupLogicalOrKHR : (Op GroupLogicalOrKHR idResultType | GroupLogicalOrKHR) execution operation x;
opGroupLogicalXorKHR : (Op GroupLogicalXorKHR idResultType | GroupLogicalXorKHR) execution operation x;

// Image Operations
opSampledImage : (Op SampledImage idResultType | SampledImage) image sampler;
opImageSampleImplicitLod : (Op ImageSampleImplicitLod idResultType | ImageSampleImplicitLod) sampledImage coordinate imageOperands?;
opImageSampleExplicitLod : (Op ImageSampleExplicitLod idResultType | ImageSampleExplicitLod) sampledImage coordinate imageOperands;
opImageSampleDrefImplicitLod : (Op ImageSampleDrefImplicitLod idResultType | ImageSampleDrefImplicitLod) sampledImage coordinate d imageOperands?;
opImageSampleDrefExplicitLod : (Op ImageSampleDrefExplicitLod idResultType | ImageSampleDrefExplicitLod) sampledImage coordinate d imageOperands;
opImageSampleProjImplicitLod : (Op ImageSampleProjImplicitLod idResultType | ImageSampleProjImplicitLod) sampledImage coordinate imageOperands?;
opImageSampleProjExplicitLod : (Op ImageSampleProjExplicitLod idResultType | ImageSampleProjExplicitLod) sampledImage coordinate imageOperands;
opImageSampleProjDrefImplicitLod : (Op ImageSampleProjDrefImplicitLod idResultType | ImageSampleProjDrefImplicitLod) sampledImage coordinate d imageOperands?;
opImageSampleProjDrefExplicitLod : (Op ImageSampleProjDrefExplicitLod idResultType | ImageSampleProjDrefExplicitLod) sampledImage coordinate d imageOperands;
opImageFetch : (Op ImageFetch idResultType | ImageFetch) image coordinate imageOperands?;
opImageGather : (Op ImageGather idResultType | ImageGather) sampledImage coordinate componentIdRef imageOperands?;
opImageDrefGather : (Op ImageDrefGather idResultType | ImageDrefGather) sampledImage coordinate d imageOperands?;
opImageRead : (Op ImageRead idResultType | ImageRead) image coordinate imageOperands?;
opImageWrite : Op ImageWrite image coordinate texel imageOperands?;
opImage : (Op Image idResultType | Image) sampledImage;
opImageQueryFormat : (Op ImageQueryFormat idResultType | ImageQueryFormat) image;
opImageQueryOrder : (Op ImageQueryOrder idResultType | ImageQueryOrder) image;
opImageQuerySizeLod : (Op ImageQuerySizeLod idResultType | ImageQuerySizeLod) image levelOfDetail;
opImageQuerySize : (Op ImageQuerySize idResultType | ImageQuerySize) image;
opImageQueryLod : (Op ImageQueryLod idResultType | ImageQueryLod) sampledImage coordinate;
opImageQueryLevels : (Op ImageQueryLevels idResultType | ImageQueryLevels) image;
opImageQuerySamples : (Op ImageQuerySamples idResultType | ImageQuerySamples) image;
opImageSparseSampleImplicitLod : (Op ImageSparseSampleImplicitLod idResultType | ImageSparseSampleImplicitLod) sampledImage coordinate imageOperands?;
opImageSparseSampleExplicitLod : (Op ImageSparseSampleExplicitLod idResultType | ImageSparseSampleExplicitLod) sampledImage coordinate imageOperands;
opImageSparseSampleDrefImplicitLod : (Op ImageSparseSampleDrefImplicitLod idResultType | ImageSparseSampleDrefImplicitLod) sampledImage coordinate d imageOperands?;
opImageSparseSampleDrefExplicitLod : (Op ImageSparseSampleDrefExplicitLod idResultType | ImageSparseSampleDrefExplicitLod) sampledImage coordinate d imageOperands;
opImageSparseSampleProjImplicitLod : (Op ImageSparseSampleProjImplicitLod idResultType | ImageSparseSampleProjImplicitLod) sampledImage coordinate imageOperands?;
opImageSparseSampleProjExplicitLod : (Op ImageSparseSampleProjExplicitLod idResultType | ImageSparseSampleProjExplicitLod) sampledImage coordinate imageOperands;
opImageSparseSampleProjDrefImplicitLod : (Op ImageSparseSampleProjDrefImplicitLod idResultType | ImageSparseSampleProjDrefImplicitLod) sampledImage coordinate d imageOperands?;
opImageSparseSampleProjDrefExplicitLod : (Op ImageSparseSampleProjDrefExplicitLod idResultType | ImageSparseSampleProjDrefExplicitLod) sampledImage coordinate d imageOperands;
opImageSparseFetch : (Op ImageSparseFetch idResultType | ImageSparseFetch) image coordinate imageOperands?;
opImageSparseGather : (Op ImageSparseGather idResultType | ImageSparseGather) sampledImage coordinate componentIdRef imageOperands?;
opImageSparseDrefGather : (Op ImageSparseDrefGather idResultType | ImageSparseDrefGather) sampledImage coordinate d imageOperands?;
opImageSparseTexelsResident : (Op ImageSparseTexelsResident idResultType | ImageSparseTexelsResident) residentCode;
opImageSparseRead : (Op ImageSparseRead idResultType | ImageSparseRead) image coordinate imageOperands?;
opColorAttachmentReadEXT : (Op ColorAttachmentReadEXT idResultType | ColorAttachmentReadEXT) attachment sample?;
opDepthAttachmentReadEXT : (Op DepthAttachmentReadEXT idResultType | DepthAttachmentReadEXT) sample?;
opStencilAttachmentReadEXT : (Op StencilAttachmentReadEXT idResultType | StencilAttachmentReadEXT) sample?;
opImageSampleWeightedQCOM : (Op ImageSampleWeightedQCOM idResultType | ImageSampleWeightedQCOM) texture coordinates weights;
opImageBoxFilterQCOM : (Op ImageBoxFilterQCOM idResultType | ImageBoxFilterQCOM) texture coordinates boxSize;
opImageBlockMatchSSDQCOM : (Op ImageBlockMatchSSDQCOM idResultType | ImageBlockMatchSSDQCOM) targetIdRef targetCoordinates reference referenceCoordinates blockSize;
opImageBlockMatchSADQCOM : (Op ImageBlockMatchSADQCOM idResultType | ImageBlockMatchSADQCOM) targetIdRef targetCoordinates reference referenceCoordinates blockSize;
opImageSampleFootprintNV : (Op ImageSampleFootprintNV idResultType | ImageSampleFootprintNV) sampledImage coordinate granularity coarse imageOperands?;

// Memory Operations
opVariable : (Op Variable idResultType | Variable) storageClass initializer?;
opImageTexelPointer : (Op ImageTexelPointer idResultType | ImageTexelPointer) image coordinate sample;
opLoad : (Op Load idResultType | Load) pointer memoryAccess?;
opStore : Op Store pointer object memoryAccess?;
opCopyMemory : Op CopyMemory targetIdRef sourceIdRef memoryAccess? memoryAccess?;
opCopyMemorySized : Op CopyMemorySized targetIdRef sourceIdRef sizeIdRef memoryAccess? memoryAccess?;
opAccessChain : (Op AccessChain idResultType | AccessChain) base indexesIdRef*;
opInBoundsAccessChain : (Op InBoundsAccessChain idResultType | InBoundsAccessChain) base indexesIdRef*;
opPtrAccessChain : (Op PtrAccessChain idResultType | PtrAccessChain) base element indexesIdRef*;
opArrayLength : (Op ArrayLength idResultType | ArrayLength) structure arrayMember;
opGenericPtrMemSemantics : (Op GenericPtrMemSemantics idResultType | GenericPtrMemSemantics) pointer;
opInBoundsPtrAccessChain : (Op InBoundsPtrAccessChain idResultType | InBoundsPtrAccessChain) base element indexesIdRef*;
opPtrEqual : (Op PtrEqual idResultType | PtrEqual) operand1 operand2;
opPtrNotEqual : (Op PtrNotEqual idResultType | PtrNotEqual) operand1 operand2;
opPtrDiff : (Op PtrDiff idResultType | PtrDiff) operand1 operand2;
opCooperativeMatrixLoadKHR : (Op CooperativeMatrixLoadKHR idResultType | CooperativeMatrixLoadKHR) pointer memoryLayout stride? memoryOperand?;
opCooperativeMatrixStoreKHR : Op CooperativeMatrixStoreKHR pointer object memoryLayout stride? memoryOperand?;
opMaskedGatherINTEL : (Op MaskedGatherINTEL idResultType | MaskedGatherINTEL) ptrVector alignmentLiteralInteger mask fillEmpty;
opMaskedScatterINTEL : Op MaskedScatterINTEL inputVector ptrVector alignmentLiteralInteger mask;

// Miscellaneous Operations
opNop : Op Nop;
opUndef : (Op Undef idResultType | Undef);
opSizeOf : (Op SizeOf idResultType | SizeOf) pointer;
opCooperativeMatrixLengthKHR : (Op CooperativeMatrixLengthKHR idResultType | CooperativeMatrixLengthKHR) type;
opAssumeTrueKHR : Op AssumeTrueKHR condition;
opExpectKHR : (Op ExpectKHR idResultType | ExpectKHR) valueIdRef expectedValue;

// Mode-Setting Operations
opMemoryModel : Op MemoryModel addressingModel memoryModel;
opEntryPoint : Op EntryPoint executionModel entryPoint nameLiteralString interface*;
opExecutionMode : Op ExecutionMode entryPoint modeExecutionMode;
opCapability : Op Capability capability;
opExecutionModeId : Op ExecutionModeId entryPoint modeExecutionMode;

// Non-Uniform Operations
opGroupNonUniformElect : (Op GroupNonUniformElect idResultType | GroupNonUniformElect) execution;
opGroupNonUniformAll : (Op GroupNonUniformAll idResultType | GroupNonUniformAll) execution predicate;
opGroupNonUniformAny : (Op GroupNonUniformAny idResultType | GroupNonUniformAny) execution predicate;
opGroupNonUniformAllEqual : (Op GroupNonUniformAllEqual idResultType | GroupNonUniformAllEqual) execution valueIdRef;
opGroupNonUniformBroadcast : (Op GroupNonUniformBroadcast idResultType | GroupNonUniformBroadcast) execution valueIdRef id;
opGroupNonUniformBroadcastFirst : (Op GroupNonUniformBroadcastFirst idResultType | GroupNonUniformBroadcastFirst) execution valueIdRef;
opGroupNonUniformBallot : (Op GroupNonUniformBallot idResultType | GroupNonUniformBallot) execution predicate;
opGroupNonUniformInverseBallot : (Op GroupNonUniformInverseBallot idResultType | GroupNonUniformInverseBallot) execution valueIdRef;
opGroupNonUniformBallotBitExtract : (Op GroupNonUniformBallotBitExtract idResultType | GroupNonUniformBallotBitExtract) execution valueIdRef indexIdRef;
opGroupNonUniformBallotBitCount : (Op GroupNonUniformBallotBitCount idResultType | GroupNonUniformBallotBitCount) execution operation valueIdRef;
opGroupNonUniformBallotFindLSB : (Op GroupNonUniformBallotFindLSB idResultType | GroupNonUniformBallotFindLSB) execution valueIdRef;
opGroupNonUniformBallotFindMSB : (Op GroupNonUniformBallotFindMSB idResultType | GroupNonUniformBallotFindMSB) execution valueIdRef;
opGroupNonUniformShuffle : (Op GroupNonUniformShuffle idResultType | GroupNonUniformShuffle) execution valueIdRef id;
opGroupNonUniformShuffleXor : (Op GroupNonUniformShuffleXor idResultType | GroupNonUniformShuffleXor) execution valueIdRef mask;
opGroupNonUniformShuffleUp : (Op GroupNonUniformShuffleUp idResultType | GroupNonUniformShuffleUp) execution valueIdRef delta;
opGroupNonUniformShuffleDown : (Op GroupNonUniformShuffleDown idResultType | GroupNonUniformShuffleDown) execution valueIdRef delta;
opGroupNonUniformIAdd : (Op GroupNonUniformIAdd idResultType | GroupNonUniformIAdd) execution operation valueIdRef clusterSize?;
opGroupNonUniformFAdd : (Op GroupNonUniformFAdd idResultType | GroupNonUniformFAdd) execution operation valueIdRef clusterSize?;
opGroupNonUniformIMul : (Op GroupNonUniformIMul idResultType | GroupNonUniformIMul) execution operation valueIdRef clusterSize?;
opGroupNonUniformFMul : (Op GroupNonUniformFMul idResultType | GroupNonUniformFMul) execution operation valueIdRef clusterSize?;
opGroupNonUniformSMin : (Op GroupNonUniformSMin idResultType | GroupNonUniformSMin) execution operation valueIdRef clusterSize?;
opGroupNonUniformUMin : (Op GroupNonUniformUMin idResultType | GroupNonUniformUMin) execution operation valueIdRef clusterSize?;
opGroupNonUniformFMin : (Op GroupNonUniformFMin idResultType | GroupNonUniformFMin) execution operation valueIdRef clusterSize?;
opGroupNonUniformSMax : (Op GroupNonUniformSMax idResultType | GroupNonUniformSMax) execution operation valueIdRef clusterSize?;
opGroupNonUniformUMax : (Op GroupNonUniformUMax idResultType | GroupNonUniformUMax) execution operation valueIdRef clusterSize?;
opGroupNonUniformFMax : (Op GroupNonUniformFMax idResultType | GroupNonUniformFMax) execution operation valueIdRef clusterSize?;
opGroupNonUniformBitwiseAnd : (Op GroupNonUniformBitwiseAnd idResultType | GroupNonUniformBitwiseAnd) execution operation valueIdRef clusterSize?;
opGroupNonUniformBitwiseOr : (Op GroupNonUniformBitwiseOr idResultType | GroupNonUniformBitwiseOr) execution operation valueIdRef clusterSize?;
opGroupNonUniformBitwiseXor : (Op GroupNonUniformBitwiseXor idResultType | GroupNonUniformBitwiseXor) execution operation valueIdRef clusterSize?;
opGroupNonUniformLogicalAnd : (Op GroupNonUniformLogicalAnd idResultType | GroupNonUniformLogicalAnd) execution operation valueIdRef clusterSize?;
opGroupNonUniformLogicalOr : (Op GroupNonUniformLogicalOr idResultType | GroupNonUniformLogicalOr) execution operation valueIdRef clusterSize?;
opGroupNonUniformLogicalXor : (Op GroupNonUniformLogicalXor idResultType | GroupNonUniformLogicalXor) execution operation valueIdRef clusterSize?;
opGroupNonUniformQuadBroadcast : (Op GroupNonUniformQuadBroadcast idResultType | GroupNonUniformQuadBroadcast) execution valueIdRef indexIdRef;
opGroupNonUniformQuadSwap : (Op GroupNonUniformQuadSwap idResultType | GroupNonUniformQuadSwap) execution valueIdRef direction;
opGroupNonUniformPartitionNV : (Op GroupNonUniformPartitionNV idResultType | GroupNonUniformPartitionNV) valueIdRef;

// Pipe Operations
opReadPipe : (Op ReadPipe idResultType | ReadPipe) pipe pointer packetSizeIdRef packetAlignmentIdRef;
opWritePipe : (Op WritePipe idResultType | WritePipe) pipe pointer packetSizeIdRef packetAlignmentIdRef;
opReservedReadPipe : (Op ReservedReadPipe idResultType | ReservedReadPipe) pipe reserveId indexIdRef pointer packetSizeIdRef packetAlignmentIdRef;
opReservedWritePipe : (Op ReservedWritePipe idResultType | ReservedWritePipe) pipe reserveId indexIdRef pointer packetSizeIdRef packetAlignmentIdRef;
opReserveReadPipePackets : (Op ReserveReadPipePackets idResultType | ReserveReadPipePackets) pipe numPackets packetSizeIdRef packetAlignmentIdRef;
opReserveWritePipePackets : (Op ReserveWritePipePackets idResultType | ReserveWritePipePackets) pipe numPackets packetSizeIdRef packetAlignmentIdRef;
opCommitReadPipe : Op CommitReadPipe pipe reserveId packetSizeIdRef packetAlignmentIdRef;
opCommitWritePipe : Op CommitWritePipe pipe reserveId packetSizeIdRef packetAlignmentIdRef;
opIsValidReserveId : (Op IsValidReserveId idResultType | IsValidReserveId) reserveId;
opGetNumPipePackets : (Op GetNumPipePackets idResultType | GetNumPipePackets) pipe packetSizeIdRef packetAlignmentIdRef;
opGetMaxPipePackets : (Op GetMaxPipePackets idResultType | GetMaxPipePackets) pipe packetSizeIdRef packetAlignmentIdRef;
opGroupReserveReadPipePackets : (Op GroupReserveReadPipePackets idResultType | GroupReserveReadPipePackets) execution pipe numPackets packetSizeIdRef packetAlignmentIdRef;
opGroupReserveWritePipePackets : (Op GroupReserveWritePipePackets idResultType | GroupReserveWritePipePackets) execution pipe numPackets packetSizeIdRef packetAlignmentIdRef;
opGroupCommitReadPipe : Op GroupCommitReadPipe execution pipe reserveId packetSizeIdRef packetAlignmentIdRef;
opGroupCommitWritePipe : Op GroupCommitWritePipe execution pipe reserveId packetSizeIdRef packetAlignmentIdRef;
opConstantPipeStorage : (Op ConstantPipeStorage idResultType | ConstantPipeStorage) packetSizeLiteralInteger packetAlignmentLiteralInteger capacity;
opCreatePipeFromPipeStorage : (Op CreatePipeFromPipeStorage idResultType | CreatePipeFromPipeStorage) pipeStorage;
opReadPipeBlockingINTEL : (Op ReadPipeBlockingINTEL idResultType | ReadPipeBlockingINTEL) packetSizeIdRef packetAlignmentIdRef;
opWritePipeBlockingINTEL : (Op WritePipeBlockingINTEL idResultType | WritePipeBlockingINTEL) packetSizeIdRef packetAlignmentIdRef;

// Primitive Operations
opEmitVertex : Op EmitVertex;
opEndPrimitive : Op EndPrimitive;
opEmitStreamVertex : Op EmitStreamVertex stream;
opEndStreamPrimitive : Op EndStreamPrimitive stream;

// Relational_and_Logical Operations
opAny : (Op Any idResultType | Any) vectorIdRef;
opAll : (Op All idResultType | All) vectorIdRef;
opIsNan : (Op IsNan idResultType | IsNan) x;
opIsInf : (Op IsInf idResultType | IsInf) x;
opIsFinite : (Op IsFinite idResultType | IsFinite) x;
opIsNormal : (Op IsNormal idResultType | IsNormal) x;
opSignBitSet : (Op SignBitSet idResultType | SignBitSet) x;
opLessOrGreater : (Op LessOrGreater idResultType | LessOrGreater) x y;
opOrdered : (Op Ordered idResultType | Ordered) x y;
opUnordered : (Op Unordered idResultType | Unordered) x y;
opLogicalEqual : (Op LogicalEqual idResultType | LogicalEqual) operand1 operand2;
opLogicalNotEqual : (Op LogicalNotEqual idResultType | LogicalNotEqual) operand1 operand2;
opLogicalOr : (Op LogicalOr idResultType | LogicalOr) operand1 operand2;
opLogicalAnd : (Op LogicalAnd idResultType | LogicalAnd) operand1 operand2;
opLogicalNot : (Op LogicalNot idResultType | LogicalNot) operand;
opSelect : (Op Select idResultType | Select) condition object1 object2;
opIEqual : (Op IEqual idResultType | IEqual) operand1 operand2;
opINotEqual : (Op INotEqual idResultType | INotEqual) operand1 operand2;
opUGreaterThan : (Op UGreaterThan idResultType | UGreaterThan) operand1 operand2;
opSGreaterThan : (Op SGreaterThan idResultType | SGreaterThan) operand1 operand2;
opUGreaterThanEqual : (Op UGreaterThanEqual idResultType | UGreaterThanEqual) operand1 operand2;
opSGreaterThanEqual : (Op SGreaterThanEqual idResultType | SGreaterThanEqual) operand1 operand2;
opULessThan : (Op ULessThan idResultType | ULessThan) operand1 operand2;
opSLessThan : (Op SLessThan idResultType | SLessThan) operand1 operand2;
opULessThanEqual : (Op ULessThanEqual idResultType | ULessThanEqual) operand1 operand2;
opSLessThanEqual : (Op SLessThanEqual idResultType | SLessThanEqual) operand1 operand2;
opFOrdEqual : (Op FOrdEqual idResultType | FOrdEqual) operand1 operand2;
opFUnordEqual : (Op FUnordEqual idResultType | FUnordEqual) operand1 operand2;
opFOrdNotEqual : (Op FOrdNotEqual idResultType | FOrdNotEqual) operand1 operand2;
opFUnordNotEqual : (Op FUnordNotEqual idResultType | FUnordNotEqual) operand1 operand2;
opFOrdLessThan : (Op FOrdLessThan idResultType | FOrdLessThan) operand1 operand2;
opFUnordLessThan : (Op FUnordLessThan idResultType | FUnordLessThan) operand1 operand2;
opFOrdGreaterThan : (Op FOrdGreaterThan idResultType | FOrdGreaterThan) operand1 operand2;
opFUnordGreaterThan : (Op FUnordGreaterThan idResultType | FUnordGreaterThan) operand1 operand2;
opFOrdLessThanEqual : (Op FOrdLessThanEqual idResultType | FOrdLessThanEqual) operand1 operand2;
opFUnordLessThanEqual : (Op FUnordLessThanEqual idResultType | FUnordLessThanEqual) operand1 operand2;
opFOrdGreaterThanEqual : (Op FOrdGreaterThanEqual idResultType | FOrdGreaterThanEqual) operand1 operand2;
opFUnordGreaterThanEqual : (Op FUnordGreaterThanEqual idResultType | FUnordGreaterThanEqual) operand1 operand2;

// Reserved Operations
opTraceRayKHR : Op TraceRayKHR accel rayFlagsIdRef cullMask sBTOffset sBTStride missIndex rayOrigin rayTmin rayDirection rayTmax payload;
opExecuteCallableKHR : Op ExecuteCallableKHR sBTIndex callableData;
opConvertUToAccelerationStructureKHR : (Op ConvertUToAccelerationStructureKHR idResultType | ConvertUToAccelerationStructureKHR) accel;
opIgnoreIntersectionKHR : Op IgnoreIntersectionKHR;
opTerminateRayKHR : Op TerminateRayKHR;
opRayQueryInitializeKHR : Op RayQueryInitializeKHR rayQuery accel rayFlagsIdRef cullMask rayOrigin rayTmin rayDirection rayTmax;
opRayQueryTerminateKHR : Op RayQueryTerminateKHR rayQuery;
opRayQueryGenerateIntersectionKHR : Op RayQueryGenerateIntersectionKHR rayQuery hitT;
opRayQueryConfirmIntersectionKHR : Op RayQueryConfirmIntersectionKHR rayQuery;
opRayQueryProceedKHR : (Op RayQueryProceedKHR idResultType | RayQueryProceedKHR) rayQuery;
opRayQueryGetIntersectionTypeKHR : (Op RayQueryGetIntersectionTypeKHR idResultType | RayQueryGetIntersectionTypeKHR) rayQuery intersection;
opFragmentMaskFetchAMD : (Op FragmentMaskFetchAMD idResultType | FragmentMaskFetchAMD) image coordinate;
opFragmentFetchAMD : (Op FragmentFetchAMD idResultType | FragmentFetchAMD) image coordinate fragmentIndex;
opReadClockKHR : (Op ReadClockKHR idResultType | ReadClockKHR) scopeIdScope;
opFinalizeNodePayloadsAMDX : Op FinalizeNodePayloadsAMDX payloadArray;
opFinishWritingNodePayloadAMDX : (Op FinishWritingNodePayloadAMDX idResultType | FinishWritingNodePayloadAMDX) payload;
opInitializeNodePayloadsAMDX : Op InitializeNodePayloadsAMDX payloadArray visibility payloadCount nodeIndex;
opHitObjectRecordHitMotionNV : Op HitObjectRecordHitMotionNV hitObject accelerationStructure instanceId primitiveId geometryIndex hitKind sBTRecordOffset sBTRecordStride origin tMin direction tMax currentTime hitObjectAttributes;
opHitObjectRecordHitWithIndexMotionNV : Op HitObjectRecordHitWithIndexMotionNV hitObject accelerationStructure instanceId primitiveId geometryIndex hitKind sBTRecordIndex origin tMin direction tMax currentTime hitObjectAttributes;
opHitObjectRecordMissMotionNV : Op HitObjectRecordMissMotionNV hitObject sBTIndex origin tMin direction tMax currentTime;
opHitObjectGetWorldToObjectNV : (Op HitObjectGetWorldToObjectNV idResultType | HitObjectGetWorldToObjectNV) hitObject;
opHitObjectGetObjectToWorldNV : (Op HitObjectGetObjectToWorldNV idResultType | HitObjectGetObjectToWorldNV) hitObject;
opHitObjectGetObjectRayDirectionNV : (Op HitObjectGetObjectRayDirectionNV idResultType | HitObjectGetObjectRayDirectionNV) hitObject;
opHitObjectGetObjectRayOriginNV : (Op HitObjectGetObjectRayOriginNV idResultType | HitObjectGetObjectRayOriginNV) hitObject;
opHitObjectTraceRayMotionNV : Op HitObjectTraceRayMotionNV hitObject accelerationStructure rayFlagsIdRef cullMask sBTRecordOffset sBTRecordStride missIndex origin tMin direction tMax time payload;
opHitObjectGetShaderRecordBufferHandleNV : (Op HitObjectGetShaderRecordBufferHandleNV idResultType | HitObjectGetShaderRecordBufferHandleNV) hitObject;
opHitObjectGetShaderBindingTableRecordIndexNV : (Op HitObjectGetShaderBindingTableRecordIndexNV idResultType | HitObjectGetShaderBindingTableRecordIndexNV) hitObject;
opHitObjectRecordEmptyNV : Op HitObjectRecordEmptyNV hitObject;
opHitObjectTraceRayNV : Op HitObjectTraceRayNV hitObject accelerationStructure rayFlagsIdRef cullMask sBTRecordOffset sBTRecordStride missIndex origin tMin direction tMax payload;
opHitObjectRecordHitNV : Op HitObjectRecordHitNV hitObject accelerationStructure instanceId primitiveId geometryIndex hitKind sBTRecordOffset sBTRecordStride origin tMin direction tMax hitObjectAttributes;
opHitObjectRecordHitWithIndexNV : Op HitObjectRecordHitWithIndexNV hitObject accelerationStructure instanceId primitiveId geometryIndex hitKind sBTRecordIndex origin tMin direction tMax hitObjectAttributes;
opHitObjectRecordMissNV : Op HitObjectRecordMissNV hitObject sBTIndex origin tMin direction tMax;
opHitObjectExecuteShaderNV : Op HitObjectExecuteShaderNV hitObject payload;
opHitObjectGetCurrentTimeNV : (Op HitObjectGetCurrentTimeNV idResultType | HitObjectGetCurrentTimeNV) hitObject;
opHitObjectGetAttributesNV : Op HitObjectGetAttributesNV hitObject hitObjectAttribute;
opHitObjectGetHitKindNV : (Op HitObjectGetHitKindNV idResultType | HitObjectGetHitKindNV) hitObject;
opHitObjectGetPrimitiveIndexNV : (Op HitObjectGetPrimitiveIndexNV idResultType | HitObjectGetPrimitiveIndexNV) hitObject;
opHitObjectGetGeometryIndexNV : (Op HitObjectGetGeometryIndexNV idResultType | HitObjectGetGeometryIndexNV) hitObject;
opHitObjectGetInstanceIdNV : (Op HitObjectGetInstanceIdNV idResultType | HitObjectGetInstanceIdNV) hitObject;
opHitObjectGetInstanceCustomIndexNV : (Op HitObjectGetInstanceCustomIndexNV idResultType | HitObjectGetInstanceCustomIndexNV) hitObject;
opHitObjectGetWorldRayDirectionNV : (Op HitObjectGetWorldRayDirectionNV idResultType | HitObjectGetWorldRayDirectionNV) hitObject;
opHitObjectGetWorldRayOriginNV : (Op HitObjectGetWorldRayOriginNV idResultType | HitObjectGetWorldRayOriginNV) hitObject;
opHitObjectGetRayTMaxNV : (Op HitObjectGetRayTMaxNV idResultType | HitObjectGetRayTMaxNV) hitObject;
opHitObjectGetRayTMinNV : (Op HitObjectGetRayTMinNV idResultType | HitObjectGetRayTMinNV) hitObject;
opHitObjectIsEmptyNV : (Op HitObjectIsEmptyNV idResultType | HitObjectIsEmptyNV) hitObject;
opHitObjectIsHitNV : (Op HitObjectIsHitNV idResultType | HitObjectIsHitNV) hitObject;
opHitObjectIsMissNV : (Op HitObjectIsMissNV idResultType | HitObjectIsMissNV) hitObject;
opReorderThreadWithHitObjectNV : Op ReorderThreadWithHitObjectNV hitObject hint? bits?;
opReorderThreadWithHintNV : Op ReorderThreadWithHintNV hint bits;
opEmitMeshTasksEXT : Op EmitMeshTasksEXT groupCountX groupCountY groupCountZ payload?;
opSetMeshOutputsEXT : Op SetMeshOutputsEXT vertexCountIdRef primitiveCountIdRef;
opWritePackedPrimitiveIndices4x8NV : Op WritePackedPrimitiveIndices4x8NV indexOffset packedIndices;
opFetchMicroTriangleVertexPositionNV : (Op FetchMicroTriangleVertexPositionNV idResultType | FetchMicroTriangleVertexPositionNV) accel instanceId geometryIndex primitiveIndex barycentric;
opFetchMicroTriangleVertexBarycentricNV : (Op FetchMicroTriangleVertexBarycentricNV idResultType | FetchMicroTriangleVertexBarycentricNV) accel instanceId geometryIndex primitiveIndex barycentric;
opReportIntersectionNV : (Op ReportIntersectionNV idResultType | ReportIntersectionNV) hit hitKind;
opReportIntersectionKHR : (Op ReportIntersectionKHR idResultType | ReportIntersectionKHR) hit hitKind;
opIgnoreIntersectionNV : Op IgnoreIntersectionNV;
opTerminateRayNV : Op TerminateRayNV;
opTraceNV : Op TraceNV accel rayFlagsIdRef cullMask sBTOffset sBTStride missIndex rayOrigin rayTmin rayDirection rayTmax payloadId;
opTraceMotionNV : Op TraceMotionNV accel rayFlagsIdRef cullMask sBTOffset sBTStride missIndex rayOrigin rayTmin rayDirection rayTmax time payloadId;
opTraceRayMotionNV : Op TraceRayMotionNV accel rayFlagsIdRef cullMask sBTOffset sBTStride missIndex rayOrigin rayTmin rayDirection rayTmax time payload;
opRayQueryGetIntersectionTriangleVertexPositionsKHR : (Op RayQueryGetIntersectionTriangleVertexPositionsKHR idResultType | RayQueryGetIntersectionTriangleVertexPositionsKHR) rayQuery intersection;
opExecuteCallableNV : Op ExecuteCallableNV sBTIndex callableDataId;
opCooperativeMatrixLoadNV : (Op CooperativeMatrixLoadNV idResultType | CooperativeMatrixLoadNV) pointer stride columnMajor memoryAccess?;
opCooperativeMatrixStoreNV : Op CooperativeMatrixStoreNV pointer object stride columnMajor memoryAccess?;
opCooperativeMatrixMulAddNV : (Op CooperativeMatrixMulAddNV idResultType | CooperativeMatrixMulAddNV) a b c;
opCooperativeMatrixLengthNV : (Op CooperativeMatrixLengthNV idResultType | CooperativeMatrixLengthNV) type;
opBeginInvocationInterlockEXT : Op BeginInvocationInterlockEXT;
opEndInvocationInterlockEXT : Op EndInvocationInterlockEXT;
opIsHelperInvocationEXT : (Op IsHelperInvocationEXT idResultType | IsHelperInvocationEXT);
opConvertUToImageNV : (Op ConvertUToImageNV idResultType | ConvertUToImageNV) operand;
opConvertUToSamplerNV : (Op ConvertUToSamplerNV idResultType | ConvertUToSamplerNV) operand;
opConvertImageToUNV : (Op ConvertImageToUNV idResultType | ConvertImageToUNV) operand;
opConvertSamplerToUNV : (Op ConvertSamplerToUNV idResultType | ConvertSamplerToUNV) operand;
opConvertUToSampledImageNV : (Op ConvertUToSampledImageNV idResultType | ConvertUToSampledImageNV) operand;
opConvertSampledImageToUNV : (Op ConvertSampledImageToUNV idResultType | ConvertSampledImageToUNV) operand;
opSamplerImageAddressingModeNV : Op SamplerImageAddressingModeNV bitWidth;
opUCountLeadingZerosINTEL : (Op UCountLeadingZerosINTEL idResultType | UCountLeadingZerosINTEL) operand;
opUCountTrailingZerosINTEL : (Op UCountTrailingZerosINTEL idResultType | UCountTrailingZerosINTEL) operand;
opAbsISubINTEL : (Op AbsISubINTEL idResultType | AbsISubINTEL) operand1 operand2;
opAbsUSubINTEL : (Op AbsUSubINTEL idResultType | AbsUSubINTEL) operand1 operand2;
opIAddSatINTEL : (Op IAddSatINTEL idResultType | IAddSatINTEL) operand1 operand2;
opUAddSatINTEL : (Op UAddSatINTEL idResultType | UAddSatINTEL) operand1 operand2;
opIAverageINTEL : (Op IAverageINTEL idResultType | IAverageINTEL) operand1 operand2;
opUAverageINTEL : (Op UAverageINTEL idResultType | UAverageINTEL) operand1 operand2;
opIAverageRoundedINTEL : (Op IAverageRoundedINTEL idResultType | IAverageRoundedINTEL) operand1 operand2;
opUAverageRoundedINTEL : (Op UAverageRoundedINTEL idResultType | UAverageRoundedINTEL) operand1 operand2;
opISubSatINTEL : (Op ISubSatINTEL idResultType | ISubSatINTEL) operand1 operand2;
opUSubSatINTEL : (Op USubSatINTEL idResultType | USubSatINTEL) operand1 operand2;
opIMul32x16INTEL : (Op IMul32x16INTEL idResultType | IMul32x16INTEL) operand1 operand2;
opUMul32x16INTEL : (Op UMul32x16INTEL idResultType | UMul32x16INTEL) operand1 operand2;
opLoopControlINTEL : Op LoopControlINTEL loopControlParameters*;
opFPGARegINTEL : (Op FPGARegINTEL idResultType | FPGARegINTEL) result input;
opRayQueryGetRayTMinKHR : (Op RayQueryGetRayTMinKHR idResultType | RayQueryGetRayTMinKHR) rayQuery;
opRayQueryGetRayFlagsKHR : (Op RayQueryGetRayFlagsKHR idResultType | RayQueryGetRayFlagsKHR) rayQuery;
opRayQueryGetIntersectionTKHR : (Op RayQueryGetIntersectionTKHR idResultType | RayQueryGetIntersectionTKHR) rayQuery intersection;
opRayQueryGetIntersectionInstanceCustomIndexKHR : (Op RayQueryGetIntersectionInstanceCustomIndexKHR idResultType | RayQueryGetIntersectionInstanceCustomIndexKHR) rayQuery intersection;
opRayQueryGetIntersectionInstanceIdKHR : (Op RayQueryGetIntersectionInstanceIdKHR idResultType | RayQueryGetIntersectionInstanceIdKHR) rayQuery intersection;
opRayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR : (Op RayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR idResultType | RayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR) rayQuery intersection;
opRayQueryGetIntersectionGeometryIndexKHR : (Op RayQueryGetIntersectionGeometryIndexKHR idResultType | RayQueryGetIntersectionGeometryIndexKHR) rayQuery intersection;
opRayQueryGetIntersectionPrimitiveIndexKHR : (Op RayQueryGetIntersectionPrimitiveIndexKHR idResultType | RayQueryGetIntersectionPrimitiveIndexKHR) rayQuery intersection;
opRayQueryGetIntersectionBarycentricsKHR : (Op RayQueryGetIntersectionBarycentricsKHR idResultType | RayQueryGetIntersectionBarycentricsKHR) rayQuery intersection;
opRayQueryGetIntersectionFrontFaceKHR : (Op RayQueryGetIntersectionFrontFaceKHR idResultType | RayQueryGetIntersectionFrontFaceKHR) rayQuery intersection;
opRayQueryGetIntersectionCandidateAABBOpaqueKHR : (Op RayQueryGetIntersectionCandidateAABBOpaqueKHR idResultType | RayQueryGetIntersectionCandidateAABBOpaqueKHR) rayQuery;
opRayQueryGetIntersectionObjectRayDirectionKHR : (Op RayQueryGetIntersectionObjectRayDirectionKHR idResultType | RayQueryGetIntersectionObjectRayDirectionKHR) rayQuery intersection;
opRayQueryGetIntersectionObjectRayOriginKHR : (Op RayQueryGetIntersectionObjectRayOriginKHR idResultType | RayQueryGetIntersectionObjectRayOriginKHR) rayQuery intersection;
opRayQueryGetWorldRayDirectionKHR : (Op RayQueryGetWorldRayDirectionKHR idResultType | RayQueryGetWorldRayDirectionKHR) rayQuery;
opRayQueryGetWorldRayOriginKHR : (Op RayQueryGetWorldRayOriginKHR idResultType | RayQueryGetWorldRayOriginKHR) rayQuery;
opRayQueryGetIntersectionObjectToWorldKHR : (Op RayQueryGetIntersectionObjectToWorldKHR idResultType | RayQueryGetIntersectionObjectToWorldKHR) rayQuery intersection;
opRayQueryGetIntersectionWorldToObjectKHR : (Op RayQueryGetIntersectionWorldToObjectKHR idResultType | RayQueryGetIntersectionWorldToObjectKHR) rayQuery intersection;

// Type-Declaration Operations
opTypeVoid : (Op TypeVoid  | TypeVoid);
opTypeBool : (Op TypeBool  | TypeBool);
opTypeInt : (Op TypeInt  | TypeInt) widthLiteralInteger signedness;
opTypeFloat : (Op TypeFloat  | TypeFloat) widthLiteralInteger;
opTypeVector : (Op TypeVector  | TypeVector) componentType componentCount;
opTypeMatrix : (Op TypeMatrix  | TypeMatrix) columnType columnCount;
opTypeImage : (Op TypeImage  | TypeImage) sampledType dim depthLiteralInteger arrayed mS sampled imageFormat accessQualifier?;
opTypeSampler : (Op TypeSampler  | TypeSampler);
opTypeSampledImage : (Op TypeSampledImage  | TypeSampledImage) imageType;
opTypeArray : (Op TypeArray  | TypeArray) elementType length;
opTypeRuntimeArray : (Op TypeRuntimeArray  | TypeRuntimeArray) elementType;
opTypeStruct : (Op TypeStruct  | TypeStruct) memberType*;
opTypeOpaque : (Op TypeOpaque  | TypeOpaque) theNameOfTheOpaqueType;
opTypePointer : (Op TypePointer  | TypePointer) storageClass type;
opTypeFunction : (Op TypeFunction  | TypeFunction) returnType parameterType*;
opTypeEvent : (Op TypeEvent  | TypeEvent);
opTypeDeviceEvent : (Op TypeDeviceEvent  | TypeDeviceEvent);
opTypeReserveId : (Op TypeReserveId  | TypeReserveId);
opTypeQueue : (Op TypeQueue  | TypeQueue);
opTypePipe : (Op TypePipe  | TypePipe) qualifier;
opTypeForwardPointer : Op TypeForwardPointer pointerType storageClass;
opTypePipeStorage : (Op TypePipeStorage  | TypePipeStorage);
opTypeNamedBarrier : (Op TypeNamedBarrier  | TypeNamedBarrier);
opTypeCooperativeMatrixKHR : (Op TypeCooperativeMatrixKHR  | TypeCooperativeMatrixKHR) componentType scopeIdScope rows columns use;
opTypeRayQueryKHR : (Op TypeRayQueryKHR  | TypeRayQueryKHR);
opTypeHitObjectNV : (Op TypeHitObjectNV  | TypeHitObjectNV);
opTypeAccelerationStructureNV : (Op TypeAccelerationStructureNV  | TypeAccelerationStructureNV);
opTypeAccelerationStructureKHR : (Op TypeAccelerationStructureKHR  | TypeAccelerationStructureKHR);
opTypeCooperativeMatrixNV : (Op TypeCooperativeMatrixNV  | TypeCooperativeMatrixNV) componentType execution rows columns;
opTypeBufferSurfaceINTEL : (Op TypeBufferSurfaceINTEL  | TypeBufferSurfaceINTEL) accessQualifier;
opTypeStructContinuedINTEL : Op TypeStructContinuedINTEL memberType*;

// exclude Operations
opConstantFunctionPointerINTEL : (Op ConstantFunctionPointerINTEL idResultType | ConstantFunctionPointerINTEL) function;
opFunctionPointerCallINTEL : (Op FunctionPointerCallINTEL idResultType | FunctionPointerCallINTEL) operand1*;
opAsmTargetINTEL : (Op AsmTargetINTEL idResultType | AsmTargetINTEL) asmTarget;
opAsmINTEL : (Op AsmINTEL idResultType | AsmINTEL) asmType targetIdRef asmInstructions constraints;
opAsmCallINTEL : (Op AsmCallINTEL idResultType | AsmCallINTEL) asm argument0*;
opVmeImageINTEL : (Op VmeImageINTEL idResultType | VmeImageINTEL) imageType sampler;
opTypeVmeImageINTEL : (Op TypeVmeImageINTEL  | TypeVmeImageINTEL) imageType;
opTypeAvcImePayloadINTEL : (Op TypeAvcImePayloadINTEL  | TypeAvcImePayloadINTEL);
opTypeAvcRefPayloadINTEL : (Op TypeAvcRefPayloadINTEL  | TypeAvcRefPayloadINTEL);
opTypeAvcSicPayloadINTEL : (Op TypeAvcSicPayloadINTEL  | TypeAvcSicPayloadINTEL);
opTypeAvcMcePayloadINTEL : (Op TypeAvcMcePayloadINTEL  | TypeAvcMcePayloadINTEL);
opTypeAvcMceResultINTEL : (Op TypeAvcMceResultINTEL  | TypeAvcMceResultINTEL);
opTypeAvcImeResultINTEL : (Op TypeAvcImeResultINTEL  | TypeAvcImeResultINTEL);
opTypeAvcImeResultSingleReferenceStreamoutINTEL : (Op TypeAvcImeResultSingleReferenceStreamoutINTEL  | TypeAvcImeResultSingleReferenceStreamoutINTEL);
opTypeAvcImeResultDualReferenceStreamoutINTEL : (Op TypeAvcImeResultDualReferenceStreamoutINTEL  | TypeAvcImeResultDualReferenceStreamoutINTEL);
opTypeAvcImeSingleReferenceStreaminINTEL : (Op TypeAvcImeSingleReferenceStreaminINTEL  | TypeAvcImeSingleReferenceStreaminINTEL);
opTypeAvcImeDualReferenceStreaminINTEL : (Op TypeAvcImeDualReferenceStreaminINTEL  | TypeAvcImeDualReferenceStreaminINTEL);
opTypeAvcRefResultINTEL : (Op TypeAvcRefResultINTEL  | TypeAvcRefResultINTEL);
opTypeAvcSicResultINTEL : (Op TypeAvcSicResultINTEL  | TypeAvcSicResultINTEL);
opSubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL : (Op SubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL idResultType | SubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL) sliceType qp;
opSubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL : (Op SubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL idResultType | SubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL) referenceBasePenalty payload;
opSubgroupAvcMceGetDefaultInterShapePenaltyINTEL : (Op SubgroupAvcMceGetDefaultInterShapePenaltyINTEL idResultType | SubgroupAvcMceGetDefaultInterShapePenaltyINTEL) sliceType qp;
opSubgroupAvcMceSetInterShapePenaltyINTEL : (Op SubgroupAvcMceSetInterShapePenaltyINTEL idResultType | SubgroupAvcMceSetInterShapePenaltyINTEL) packedShapePenalty payload;
opSubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL : (Op SubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL idResultType | SubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL) sliceType qp;
opSubgroupAvcMceSetInterDirectionPenaltyINTEL : (Op SubgroupAvcMceSetInterDirectionPenaltyINTEL idResultType | SubgroupAvcMceSetInterDirectionPenaltyINTEL) directionCost payload;
opSubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL : (Op SubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL idResultType | SubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL) sliceType qp;
opSubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL : (Op SubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL idResultType | SubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL) sliceType qp;
opSubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL : (Op SubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL idResultType | SubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL);
opSubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL : (Op SubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL idResultType | SubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL);
opSubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL : (Op SubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL idResultType | SubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL);
opSubgroupAvcMceSetMotionVectorCostFunctionINTEL : (Op SubgroupAvcMceSetMotionVectorCostFunctionINTEL idResultType | SubgroupAvcMceSetMotionVectorCostFunctionINTEL) packedCostCenterDelta packedCostTable costPrecision payload;
opSubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL : (Op SubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL idResultType | SubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL) sliceType qp;
opSubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL : (Op SubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL idResultType | SubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL);
opSubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL : (Op SubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL idResultType | SubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL);
opSubgroupAvcMceSetAcOnlyHaarINTEL : (Op SubgroupAvcMceSetAcOnlyHaarINTEL idResultType | SubgroupAvcMceSetAcOnlyHaarINTEL) payload;
opSubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL : (Op SubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL idResultType | SubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL) sourceFieldPolarity payload;
opSubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL : (Op SubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL idResultType | SubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL) referenceFieldPolarity payload;
opSubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL : (Op SubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL idResultType | SubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL) forwardReferenceFieldPolarity backwardReferenceFieldPolarity payload;
opSubgroupAvcMceConvertToImePayloadINTEL : (Op SubgroupAvcMceConvertToImePayloadINTEL idResultType | SubgroupAvcMceConvertToImePayloadINTEL) payload;
opSubgroupAvcMceConvertToImeResultINTEL : (Op SubgroupAvcMceConvertToImeResultINTEL idResultType | SubgroupAvcMceConvertToImeResultINTEL) payload;
opSubgroupAvcMceConvertToRefPayloadINTEL : (Op SubgroupAvcMceConvertToRefPayloadINTEL idResultType | SubgroupAvcMceConvertToRefPayloadINTEL) payload;
opSubgroupAvcMceConvertToRefResultINTEL : (Op SubgroupAvcMceConvertToRefResultINTEL idResultType | SubgroupAvcMceConvertToRefResultINTEL) payload;
opSubgroupAvcMceConvertToSicPayloadINTEL : (Op SubgroupAvcMceConvertToSicPayloadINTEL idResultType | SubgroupAvcMceConvertToSicPayloadINTEL) payload;
opSubgroupAvcMceConvertToSicResultINTEL : (Op SubgroupAvcMceConvertToSicResultINTEL idResultType | SubgroupAvcMceConvertToSicResultINTEL) payload;
opSubgroupAvcMceGetMotionVectorsINTEL : (Op SubgroupAvcMceGetMotionVectorsINTEL idResultType | SubgroupAvcMceGetMotionVectorsINTEL) payload;
opSubgroupAvcMceGetInterDistortionsINTEL : (Op SubgroupAvcMceGetInterDistortionsINTEL idResultType | SubgroupAvcMceGetInterDistortionsINTEL) payload;
opSubgroupAvcMceGetBestInterDistortionsINTEL : (Op SubgroupAvcMceGetBestInterDistortionsINTEL idResultType | SubgroupAvcMceGetBestInterDistortionsINTEL) payload;
opSubgroupAvcMceGetInterMajorShapeINTEL : (Op SubgroupAvcMceGetInterMajorShapeINTEL idResultType | SubgroupAvcMceGetInterMajorShapeINTEL) payload;
opSubgroupAvcMceGetInterMinorShapeINTEL : (Op SubgroupAvcMceGetInterMinorShapeINTEL idResultType | SubgroupAvcMceGetInterMinorShapeINTEL) payload;
opSubgroupAvcMceGetInterDirectionsINTEL : (Op SubgroupAvcMceGetInterDirectionsINTEL idResultType | SubgroupAvcMceGetInterDirectionsINTEL) payload;
opSubgroupAvcMceGetInterMotionVectorCountINTEL : (Op SubgroupAvcMceGetInterMotionVectorCountINTEL idResultType | SubgroupAvcMceGetInterMotionVectorCountINTEL) payload;
opSubgroupAvcMceGetInterReferenceIdsINTEL : (Op SubgroupAvcMceGetInterReferenceIdsINTEL idResultType | SubgroupAvcMceGetInterReferenceIdsINTEL) payload;
opSubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL : (Op SubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL idResultType | SubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL) packedReferenceIds packedReferenceParameterFieldPolarities payload;
opSubgroupAvcImeInitializeINTEL : (Op SubgroupAvcImeInitializeINTEL idResultType | SubgroupAvcImeInitializeINTEL) srcCoord partitionMask sADAdjustment;
opSubgroupAvcImeSetSingleReferenceINTEL : (Op SubgroupAvcImeSetSingleReferenceINTEL idResultType | SubgroupAvcImeSetSingleReferenceINTEL) refOffset searchWindowConfig payload;
opSubgroupAvcImeSetDualReferenceINTEL : (Op SubgroupAvcImeSetDualReferenceINTEL idResultType | SubgroupAvcImeSetDualReferenceINTEL) fwdRefOffset bwdRefOffset id payload;
opSubgroupAvcImeRefWindowSizeINTEL : (Op SubgroupAvcImeRefWindowSizeINTEL idResultType | SubgroupAvcImeRefWindowSizeINTEL) searchWindowConfig dualRef;
opSubgroupAvcImeAdjustRefOffsetINTEL : (Op SubgroupAvcImeAdjustRefOffsetINTEL idResultType | SubgroupAvcImeAdjustRefOffsetINTEL) refOffset srcCoord refWindowSize imageSize;
opSubgroupAvcImeConvertToMcePayloadINTEL : (Op SubgroupAvcImeConvertToMcePayloadINTEL idResultType | SubgroupAvcImeConvertToMcePayloadINTEL) payload;
opSubgroupAvcImeSetMaxMotionVectorCountINTEL : (Op SubgroupAvcImeSetMaxMotionVectorCountINTEL idResultType | SubgroupAvcImeSetMaxMotionVectorCountINTEL) maxMotionVectorCount payload;
opSubgroupAvcImeSetUnidirectionalMixDisableINTEL : (Op SubgroupAvcImeSetUnidirectionalMixDisableINTEL idResultType | SubgroupAvcImeSetUnidirectionalMixDisableINTEL) payload;
opSubgroupAvcImeSetEarlySearchTerminationThresholdINTEL : (Op SubgroupAvcImeSetEarlySearchTerminationThresholdINTEL idResultType | SubgroupAvcImeSetEarlySearchTerminationThresholdINTEL) threshold payload;
opSubgroupAvcImeSetWeightedSadINTEL : (Op SubgroupAvcImeSetWeightedSadINTEL idResultType | SubgroupAvcImeSetWeightedSadINTEL) packedSadWeights payload;
opSubgroupAvcImeEvaluateWithSingleReferenceINTEL : (Op SubgroupAvcImeEvaluateWithSingleReferenceINTEL idResultType | SubgroupAvcImeEvaluateWithSingleReferenceINTEL) srcImage refImage payload;
opSubgroupAvcImeEvaluateWithDualReferenceINTEL : (Op SubgroupAvcImeEvaluateWithDualReferenceINTEL idResultType | SubgroupAvcImeEvaluateWithDualReferenceINTEL) srcImage fwdRefImage bwdRefImage payload;
opSubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL : (Op SubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL idResultType | SubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL) srcImage refImage payload streaminComponents;
opSubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL : (Op SubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL idResultType | SubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL) srcImage fwdRefImage bwdRefImage payload streaminComponents;
opSubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL : (Op SubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL idResultType | SubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL) srcImage refImage payload;
opSubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL : (Op SubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL idResultType | SubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL) srcImage fwdRefImage bwdRefImage payload;
opSubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL : (Op SubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL idResultType | SubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL) srcImage refImage payload streaminComponents;
opSubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL : (Op SubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL idResultType | SubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL) srcImage fwdRefImage bwdRefImage payload streaminComponents;
opSubgroupAvcImeConvertToMceResultINTEL : (Op SubgroupAvcImeConvertToMceResultINTEL idResultType | SubgroupAvcImeConvertToMceResultINTEL) payload;
opSubgroupAvcImeGetSingleReferenceStreaminINTEL : (Op SubgroupAvcImeGetSingleReferenceStreaminINTEL idResultType | SubgroupAvcImeGetSingleReferenceStreaminINTEL) payload;
opSubgroupAvcImeGetDualReferenceStreaminINTEL : (Op SubgroupAvcImeGetDualReferenceStreaminINTEL idResultType | SubgroupAvcImeGetDualReferenceStreaminINTEL) payload;
opSubgroupAvcImeStripSingleReferenceStreamoutINTEL : (Op SubgroupAvcImeStripSingleReferenceStreamoutINTEL idResultType | SubgroupAvcImeStripSingleReferenceStreamoutINTEL) payload;
opSubgroupAvcImeStripDualReferenceStreamoutINTEL : (Op SubgroupAvcImeStripDualReferenceStreamoutINTEL idResultType | SubgroupAvcImeStripDualReferenceStreamoutINTEL) payload;
opSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL : (Op SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL idResultType | SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL) payload majorShape;
opSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL : (Op SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL idResultType | SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL) payload majorShape;
opSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL : (Op SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL idResultType | SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL) payload majorShape;
opSubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL : (Op SubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL idResultType | SubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL) payload majorShape direction;
opSubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL : (Op SubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL idResultType | SubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL) payload majorShape direction;
opSubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL : (Op SubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL idResultType | SubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL) payload majorShape direction;
opSubgroupAvcImeGetBorderReachedINTEL : (Op SubgroupAvcImeGetBorderReachedINTEL idResultType | SubgroupAvcImeGetBorderReachedINTEL) imageSelect payload;
opSubgroupAvcImeGetTruncatedSearchIndicationINTEL : (Op SubgroupAvcImeGetTruncatedSearchIndicationINTEL idResultType | SubgroupAvcImeGetTruncatedSearchIndicationINTEL) payload;
opSubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL : (Op SubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL idResultType | SubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL) payload;
opSubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL : (Op SubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL idResultType | SubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL) payload;
opSubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL : (Op SubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL idResultType | SubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL) payload;
opSubgroupAvcFmeInitializeINTEL : (Op SubgroupAvcFmeInitializeINTEL idResultType | SubgroupAvcFmeInitializeINTEL) srcCoord motionVectors majorShapes minorShapes direction pixelResolution sADAdjustment;
opSubgroupAvcBmeInitializeINTEL : (Op SubgroupAvcBmeInitializeINTEL idResultType | SubgroupAvcBmeInitializeINTEL) srcCoord motionVectors majorShapes minorShapes direction pixelResolution bidirectionalWeight sADAdjustment;
opSubgroupAvcRefConvertToMcePayloadINTEL : (Op SubgroupAvcRefConvertToMcePayloadINTEL idResultType | SubgroupAvcRefConvertToMcePayloadINTEL) payload;
opSubgroupAvcRefSetBidirectionalMixDisableINTEL : (Op SubgroupAvcRefSetBidirectionalMixDisableINTEL idResultType | SubgroupAvcRefSetBidirectionalMixDisableINTEL) payload;
opSubgroupAvcRefSetBilinearFilterEnableINTEL : (Op SubgroupAvcRefSetBilinearFilterEnableINTEL idResultType | SubgroupAvcRefSetBilinearFilterEnableINTEL) payload;
opSubgroupAvcRefEvaluateWithSingleReferenceINTEL : (Op SubgroupAvcRefEvaluateWithSingleReferenceINTEL idResultType | SubgroupAvcRefEvaluateWithSingleReferenceINTEL) srcImage refImage payload;
opSubgroupAvcRefEvaluateWithDualReferenceINTEL : (Op SubgroupAvcRefEvaluateWithDualReferenceINTEL idResultType | SubgroupAvcRefEvaluateWithDualReferenceINTEL) srcImage fwdRefImage bwdRefImage payload;
opSubgroupAvcRefEvaluateWithMultiReferenceINTEL : (Op SubgroupAvcRefEvaluateWithMultiReferenceINTEL idResultType | SubgroupAvcRefEvaluateWithMultiReferenceINTEL) srcImage packedReferenceIds payload;
opSubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL : (Op SubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL idResultType | SubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL) srcImage packedReferenceIds packedReferenceFieldPolarities payload;
opSubgroupAvcRefConvertToMceResultINTEL : (Op SubgroupAvcRefConvertToMceResultINTEL idResultType | SubgroupAvcRefConvertToMceResultINTEL) payload;
opSubgroupAvcSicInitializeINTEL : (Op SubgroupAvcSicInitializeINTEL idResultType | SubgroupAvcSicInitializeINTEL) srcCoord;
opSubgroupAvcSicConfigureSkcINTEL : (Op SubgroupAvcSicConfigureSkcINTEL idResultType | SubgroupAvcSicConfigureSkcINTEL) skipBlockPartitionType skipMotionVectorMask motionVectors bidirectionalWeight sADAdjustment payload;
opSubgroupAvcSicConfigureIpeLumaINTEL : (Op SubgroupAvcSicConfigureIpeLumaINTEL idResultType | SubgroupAvcSicConfigureIpeLumaINTEL) lumaIntraPartitionMask intraNeighbourAvailabilty leftEdgeLumaPixels upperLeftCornerLumaPixel upperEdgeLumaPixels upperRightEdgeLumaPixels sADAdjustment payload;
opSubgroupAvcSicConfigureIpeLumaChromaINTEL : (Op SubgroupAvcSicConfigureIpeLumaChromaINTEL idResultType | SubgroupAvcSicConfigureIpeLumaChromaINTEL) lumaIntraPartitionMask intraNeighbourAvailabilty leftEdgeLumaPixels upperLeftCornerLumaPixel upperEdgeLumaPixels upperRightEdgeLumaPixels leftEdgeChromaPixels upperLeftCornerChromaPixel upperEdgeChromaPixels sADAdjustment payload;
opSubgroupAvcSicGetMotionVectorMaskINTEL : (Op SubgroupAvcSicGetMotionVectorMaskINTEL idResultType | SubgroupAvcSicGetMotionVectorMaskINTEL) skipBlockPartitionType direction;
opSubgroupAvcSicConvertToMcePayloadINTEL : (Op SubgroupAvcSicConvertToMcePayloadINTEL idResultType | SubgroupAvcSicConvertToMcePayloadINTEL) payload;
opSubgroupAvcSicSetIntraLumaShapePenaltyINTEL : (Op SubgroupAvcSicSetIntraLumaShapePenaltyINTEL idResultType | SubgroupAvcSicSetIntraLumaShapePenaltyINTEL) packedShapePenalty payload;
opSubgroupAvcSicSetIntraLumaModeCostFunctionINTEL : (Op SubgroupAvcSicSetIntraLumaModeCostFunctionINTEL idResultType | SubgroupAvcSicSetIntraLumaModeCostFunctionINTEL) lumaModePenalty lumaPackedNeighborModes lumaPackedNonDcPenalty payload;
opSubgroupAvcSicSetIntraChromaModeCostFunctionINTEL : (Op SubgroupAvcSicSetIntraChromaModeCostFunctionINTEL idResultType | SubgroupAvcSicSetIntraChromaModeCostFunctionINTEL) chromaModeBasePenalty payload;
opSubgroupAvcSicSetBilinearFilterEnableINTEL : (Op SubgroupAvcSicSetBilinearFilterEnableINTEL idResultType | SubgroupAvcSicSetBilinearFilterEnableINTEL) payload;
opSubgroupAvcSicSetSkcForwardTransformEnableINTEL : (Op SubgroupAvcSicSetSkcForwardTransformEnableINTEL idResultType | SubgroupAvcSicSetSkcForwardTransformEnableINTEL) packedSadCoefficients payload;
opSubgroupAvcSicSetBlockBasedRawSkipSadINTEL : (Op SubgroupAvcSicSetBlockBasedRawSkipSadINTEL idResultType | SubgroupAvcSicSetBlockBasedRawSkipSadINTEL) blockBasedSkipType payload;
opSubgroupAvcSicEvaluateIpeINTEL : (Op SubgroupAvcSicEvaluateIpeINTEL idResultType | SubgroupAvcSicEvaluateIpeINTEL) srcImage payload;
opSubgroupAvcSicEvaluateWithSingleReferenceINTEL : (Op SubgroupAvcSicEvaluateWithSingleReferenceINTEL idResultType | SubgroupAvcSicEvaluateWithSingleReferenceINTEL) srcImage refImage payload;
opSubgroupAvcSicEvaluateWithDualReferenceINTEL : (Op SubgroupAvcSicEvaluateWithDualReferenceINTEL idResultType | SubgroupAvcSicEvaluateWithDualReferenceINTEL) srcImage fwdRefImage bwdRefImage payload;
opSubgroupAvcSicEvaluateWithMultiReferenceINTEL : (Op SubgroupAvcSicEvaluateWithMultiReferenceINTEL idResultType | SubgroupAvcSicEvaluateWithMultiReferenceINTEL) srcImage packedReferenceIds payload;
opSubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL : (Op SubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL idResultType | SubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL) srcImage packedReferenceIds packedReferenceFieldPolarities payload;
opSubgroupAvcSicConvertToMceResultINTEL : (Op SubgroupAvcSicConvertToMceResultINTEL idResultType | SubgroupAvcSicConvertToMceResultINTEL) payload;
opSubgroupAvcSicGetIpeLumaShapeINTEL : (Op SubgroupAvcSicGetIpeLumaShapeINTEL idResultType | SubgroupAvcSicGetIpeLumaShapeINTEL) payload;
opSubgroupAvcSicGetBestIpeLumaDistortionINTEL : (Op SubgroupAvcSicGetBestIpeLumaDistortionINTEL idResultType | SubgroupAvcSicGetBestIpeLumaDistortionINTEL) payload;
opSubgroupAvcSicGetBestIpeChromaDistortionINTEL : (Op SubgroupAvcSicGetBestIpeChromaDistortionINTEL idResultType | SubgroupAvcSicGetBestIpeChromaDistortionINTEL) payload;
opSubgroupAvcSicGetPackedIpeLumaModesINTEL : (Op SubgroupAvcSicGetPackedIpeLumaModesINTEL idResultType | SubgroupAvcSicGetPackedIpeLumaModesINTEL) payload;
opSubgroupAvcSicGetIpeChromaModeINTEL : (Op SubgroupAvcSicGetIpeChromaModeINTEL idResultType | SubgroupAvcSicGetIpeChromaModeINTEL) payload;
opSubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL : (Op SubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL idResultType | SubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL) payload;
opSubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL : (Op SubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL idResultType | SubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL) payload;
opSubgroupAvcSicGetInterRawSadsINTEL : (Op SubgroupAvcSicGetInterRawSadsINTEL idResultType | SubgroupAvcSicGetInterRawSadsINTEL) payload;
opVariableLengthArrayINTEL : (Op VariableLengthArrayINTEL idResultType | VariableLengthArrayINTEL) lenght;
opSaveMemoryINTEL : (Op SaveMemoryINTEL idResultType | SaveMemoryINTEL);
opRestoreMemoryINTEL : Op RestoreMemoryINTEL ptr;
opArbitraryFloatSinCosPiINTEL : (Op ArbitraryFloatSinCosPiINTEL idResultType | ArbitraryFloatSinCosPiINTEL) a m1 mout fromSign enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCastINTEL : (Op ArbitraryFloatCastINTEL idResultType | ArbitraryFloatCastINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCastFromIntINTEL : (Op ArbitraryFloatCastFromIntINTEL idResultType | ArbitraryFloatCastFromIntINTEL) a mout fromSign enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCastToIntINTEL : (Op ArbitraryFloatCastToIntINTEL idResultType | ArbitraryFloatCastToIntINTEL) a m1 enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatAddINTEL : (Op ArbitraryFloatAddINTEL idResultType | ArbitraryFloatAddINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatSubINTEL : (Op ArbitraryFloatSubINTEL idResultType | ArbitraryFloatSubINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatMulINTEL : (Op ArbitraryFloatMulINTEL idResultType | ArbitraryFloatMulINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatDivINTEL : (Op ArbitraryFloatDivINTEL idResultType | ArbitraryFloatDivINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatGTINTEL : (Op ArbitraryFloatGTINTEL idResultType | ArbitraryFloatGTINTEL) a m1 b m2;
opArbitraryFloatGEINTEL : (Op ArbitraryFloatGEINTEL idResultType | ArbitraryFloatGEINTEL) a m1 b m2;
opArbitraryFloatLTINTEL : (Op ArbitraryFloatLTINTEL idResultType | ArbitraryFloatLTINTEL) a m1 b m2;
opArbitraryFloatLEINTEL : (Op ArbitraryFloatLEINTEL idResultType | ArbitraryFloatLEINTEL) a m1 b m2;
opArbitraryFloatEQINTEL : (Op ArbitraryFloatEQINTEL idResultType | ArbitraryFloatEQINTEL) a m1 b m2;
opArbitraryFloatRecipINTEL : (Op ArbitraryFloatRecipINTEL idResultType | ArbitraryFloatRecipINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatRSqrtINTEL : (Op ArbitraryFloatRSqrtINTEL idResultType | ArbitraryFloatRSqrtINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCbrtINTEL : (Op ArbitraryFloatCbrtINTEL idResultType | ArbitraryFloatCbrtINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatHypotINTEL : (Op ArbitraryFloatHypotINTEL idResultType | ArbitraryFloatHypotINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatSqrtINTEL : (Op ArbitraryFloatSqrtINTEL idResultType | ArbitraryFloatSqrtINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatLogINTEL : (Op ArbitraryFloatLogINTEL idResultType | ArbitraryFloatLogINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatLog2INTEL : (Op ArbitraryFloatLog2INTEL idResultType | ArbitraryFloatLog2INTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatLog10INTEL : (Op ArbitraryFloatLog10INTEL idResultType | ArbitraryFloatLog10INTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatLog1pINTEL : (Op ArbitraryFloatLog1pINTEL idResultType | ArbitraryFloatLog1pINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatExpINTEL : (Op ArbitraryFloatExpINTEL idResultType | ArbitraryFloatExpINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatExp2INTEL : (Op ArbitraryFloatExp2INTEL idResultType | ArbitraryFloatExp2INTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatExp10INTEL : (Op ArbitraryFloatExp10INTEL idResultType | ArbitraryFloatExp10INTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatExpm1INTEL : (Op ArbitraryFloatExpm1INTEL idResultType | ArbitraryFloatExpm1INTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatSinINTEL : (Op ArbitraryFloatSinINTEL idResultType | ArbitraryFloatSinINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCosINTEL : (Op ArbitraryFloatCosINTEL idResultType | ArbitraryFloatCosINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatSinCosINTEL : (Op ArbitraryFloatSinCosINTEL idResultType | ArbitraryFloatSinCosINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatSinPiINTEL : (Op ArbitraryFloatSinPiINTEL idResultType | ArbitraryFloatSinPiINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCosPiINTEL : (Op ArbitraryFloatCosPiINTEL idResultType | ArbitraryFloatCosPiINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatASinINTEL : (Op ArbitraryFloatASinINTEL idResultType | ArbitraryFloatASinINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatASinPiINTEL : (Op ArbitraryFloatASinPiINTEL idResultType | ArbitraryFloatASinPiINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatACosINTEL : (Op ArbitraryFloatACosINTEL idResultType | ArbitraryFloatACosINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatACosPiINTEL : (Op ArbitraryFloatACosPiINTEL idResultType | ArbitraryFloatACosPiINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatATanINTEL : (Op ArbitraryFloatATanINTEL idResultType | ArbitraryFloatATanINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatATanPiINTEL : (Op ArbitraryFloatATanPiINTEL idResultType | ArbitraryFloatATanPiINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatATan2INTEL : (Op ArbitraryFloatATan2INTEL idResultType | ArbitraryFloatATan2INTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatPowINTEL : (Op ArbitraryFloatPowINTEL idResultType | ArbitraryFloatPowINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatPowRINTEL : (Op ArbitraryFloatPowRINTEL idResultType | ArbitraryFloatPowRINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatPowNINTEL : (Op ArbitraryFloatPowNINTEL idResultType | ArbitraryFloatPowNINTEL) a m1 b mout enableSubnormals roundingMode roundingAccuracy;
opAliasDomainDeclINTEL : (Op AliasDomainDeclINTEL  | AliasDomainDeclINTEL) nameIdRef?;
opAliasScopeDeclINTEL : (Op AliasScopeDeclINTEL  | AliasScopeDeclINTEL) aliasDomain nameIdRef?;
opAliasScopeListDeclINTEL : (Op AliasScopeListDeclINTEL  | AliasScopeListDeclINTEL) aliasScope*;
opFixedSqrtINTEL : (Op FixedSqrtINTEL idResultType | FixedSqrtINTEL) inputType input s i rI q o;
opFixedRecipINTEL : (Op FixedRecipINTEL idResultType | FixedRecipINTEL) inputType input s i rI q o;
opFixedRsqrtINTEL : (Op FixedRsqrtINTEL idResultType | FixedRsqrtINTEL) inputType input s i rI q o;
opFixedSinINTEL : (Op FixedSinINTEL idResultType | FixedSinINTEL) inputType input s i rI q o;
opFixedCosINTEL : (Op FixedCosINTEL idResultType | FixedCosINTEL) inputType input s i rI q o;
opFixedSinCosINTEL : (Op FixedSinCosINTEL idResultType | FixedSinCosINTEL) inputType input s i rI q o;
opFixedSinPiINTEL : (Op FixedSinPiINTEL idResultType | FixedSinPiINTEL) inputType input s i rI q o;
opFixedCosPiINTEL : (Op FixedCosPiINTEL idResultType | FixedCosPiINTEL) inputType input s i rI q o;
opFixedSinCosPiINTEL : (Op FixedSinCosPiINTEL idResultType | FixedSinCosPiINTEL) inputType input s i rI q o;
opFixedLogINTEL : (Op FixedLogINTEL idResultType | FixedLogINTEL) inputType input s i rI q o;
opFixedExpINTEL : (Op FixedExpINTEL idResultType | FixedExpINTEL) inputType input s i rI q o;
opPtrCastToCrossWorkgroupINTEL : (Op PtrCastToCrossWorkgroupINTEL idResultType | PtrCastToCrossWorkgroupINTEL) pointer;
opCrossWorkgroupCastToPtrINTEL : (Op CrossWorkgroupCastToPtrINTEL idResultType | CrossWorkgroupCastToPtrINTEL) pointer;

// Operation groups
op
    :   opAssumeTrueKHR
    |   opAtomicFlagClear
    |   opAtomicStore
    |   opBeginInvocationInterlockEXT
    |   opBranch
    |   opBranchConditional
    |   opCapability
    |   opCaptureEventProfilingInfo
    |   opCommitReadPipe
    |   opCommitWritePipe
    |   opConstantCompositeContinuedINTEL
    |   opControlBarrier
    |   opControlBarrierArriveINTEL
    |   opControlBarrierWaitINTEL
    |   opCooperativeMatrixStoreKHR
    |   opCooperativeMatrixStoreNV
    |   opCopyMemory
    |   opCopyMemorySized
    |   opDecorate
    |   opDecorateId
    |   opDecorateString
    |   opDecorateStringGOOGLE
    |   opDemoteToHelperInvocation
    |   opDemoteToHelperInvocationEXT
    |   opEmitMeshTasksEXT
    |   opEmitStreamVertex
    |   opEmitVertex
    |   opEndInvocationInterlockEXT
    |   opEndPrimitive
    |   opEndStreamPrimitive
    |   opEntryPoint
    |   opExecuteCallableKHR
    |   opExecuteCallableNV
    |   opExecutionMode
    |   opExecutionModeId
    |   opExtension
    |   opFinalizeNodePayloadsAMDX
    |   opFunctionEnd
    |   opGroupCommitReadPipe
    |   opGroupCommitWritePipe
    |   opGroupDecorate
    |   opGroupMemberDecorate
    |   opGroupWaitEvents
    |   opHitObjectExecuteShaderNV
    |   opHitObjectGetAttributesNV
    |   opHitObjectRecordEmptyNV
    |   opHitObjectRecordHitMotionNV
    |   opHitObjectRecordHitNV
    |   opHitObjectRecordHitWithIndexMotionNV
    |   opHitObjectRecordHitWithIndexNV
    |   opHitObjectRecordMissMotionNV
    |   opHitObjectRecordMissNV
    |   opHitObjectTraceRayMotionNV
    |   opHitObjectTraceRayNV
    |   opIgnoreIntersectionKHR
    |   opIgnoreIntersectionNV
    |   opImageWrite
    |   opInitializeNodePayloadsAMDX
    |   opKill
    |   opLifetimeStart
    |   opLifetimeStop
    |   opLine
    |   opLoopControlINTEL
    |   opLoopMerge
    |   opMaskedScatterINTEL
    |   opMemberDecorate
    |   opMemberDecorateString
    |   opMemberDecorateStringGOOGLE
    |   opMemberName
    |   opMemoryBarrier
    |   opMemoryModel
    |   opMemoryNamedBarrier
    |   opModuleProcessed
    |   opName
    |   opNoLine
    |   opNop
    |   opRayQueryConfirmIntersectionKHR
    |   opRayQueryGenerateIntersectionKHR
    |   opRayQueryInitializeKHR
    |   opRayQueryTerminateKHR
    |   opReleaseEvent
    |   opReorderThreadWithHintNV
    |   opReorderThreadWithHitObjectNV
    |   opRestoreMemoryINTEL
    |   opRetainEvent
    |   opReturn
    |   opReturnValue
    |   opSamplerImageAddressingModeNV
    |   opSelectionMerge
    |   opSetMeshOutputsEXT
    |   opSetUserEventStatus
    |   opSource
    |   opSourceContinued
    |   opSourceExtension
    |   opSpecConstantCompositeContinuedINTEL
    |   opStore
    |   opSubgroupBlockWriteINTEL
    |   opSubgroupImageBlockWriteINTEL
    |   opSubgroupImageMediaBlockWriteINTEL
    |   opSwitch
    |   opTerminateInvocation
    |   opTerminateRayKHR
    |   opTerminateRayNV
    |   opTraceMotionNV
    |   opTraceNV
    |   opTraceRayKHR
    |   opTraceRayMotionNV
    |   opTypeForwardPointer
    |   opTypeStructContinuedINTEL
    |   opUnreachable
    |   opWritePackedPrimitiveIndices4x8NV
    ;

opWithRet
    :   opAbsISubINTEL
    |   opAbsUSubINTEL
    |   opAccessChain
    |   opAliasDomainDeclINTEL
    |   opAliasScopeDeclINTEL
    |   opAliasScopeListDeclINTEL
    |   opAll
    |   opAny
    |   opArbitraryFloatACosINTEL
    |   opArbitraryFloatACosPiINTEL
    |   opArbitraryFloatASinINTEL
    |   opArbitraryFloatASinPiINTEL
    |   opArbitraryFloatATan2INTEL
    |   opArbitraryFloatATanINTEL
    |   opArbitraryFloatATanPiINTEL
    |   opArbitraryFloatAddINTEL
    |   opArbitraryFloatCastFromIntINTEL
    |   opArbitraryFloatCastINTEL
    |   opArbitraryFloatCastToIntINTEL
    |   opArbitraryFloatCbrtINTEL
    |   opArbitraryFloatCosINTEL
    |   opArbitraryFloatCosPiINTEL
    |   opArbitraryFloatDivINTEL
    |   opArbitraryFloatEQINTEL
    |   opArbitraryFloatExp10INTEL
    |   opArbitraryFloatExp2INTEL
    |   opArbitraryFloatExpINTEL
    |   opArbitraryFloatExpm1INTEL
    |   opArbitraryFloatGEINTEL
    |   opArbitraryFloatGTINTEL
    |   opArbitraryFloatHypotINTEL
    |   opArbitraryFloatLEINTEL
    |   opArbitraryFloatLTINTEL
    |   opArbitraryFloatLog10INTEL
    |   opArbitraryFloatLog1pINTEL
    |   opArbitraryFloatLog2INTEL
    |   opArbitraryFloatLogINTEL
    |   opArbitraryFloatMulINTEL
    |   opArbitraryFloatPowINTEL
    |   opArbitraryFloatPowNINTEL
    |   opArbitraryFloatPowRINTEL
    |   opArbitraryFloatRSqrtINTEL
    |   opArbitraryFloatRecipINTEL
    |   opArbitraryFloatSinCosINTEL
    |   opArbitraryFloatSinCosPiINTEL
    |   opArbitraryFloatSinINTEL
    |   opArbitraryFloatSinPiINTEL
    |   opArbitraryFloatSqrtINTEL
    |   opArbitraryFloatSubINTEL
    |   opArrayLength
    |   opAsmCallINTEL
    |   opAsmINTEL
    |   opAsmTargetINTEL
    |   opAtomicAnd
    |   opAtomicCompareExchange
    |   opAtomicCompareExchangeWeak
    |   opAtomicExchange
    |   opAtomicFAddEXT
    |   opAtomicFMaxEXT
    |   opAtomicFMinEXT
    |   opAtomicFlagTestAndSet
    |   opAtomicIAdd
    |   opAtomicIDecrement
    |   opAtomicIIncrement
    |   opAtomicISub
    |   opAtomicLoad
    |   opAtomicOr
    |   opAtomicSMax
    |   opAtomicSMin
    |   opAtomicUMax
    |   opAtomicUMin
    |   opAtomicXor
    |   opBitCount
    |   opBitFieldInsert
    |   opBitFieldSExtract
    |   opBitFieldUExtract
    |   opBitReverse
    |   opBitcast
    |   opBitwiseAnd
    |   opBitwiseOr
    |   opBitwiseXor
    |   opBuildNDRange
    |   opColorAttachmentReadEXT
    |   opCompositeConstruct
    |   opCompositeConstructContinuedINTEL
    |   opCompositeExtract
    |   opCompositeInsert
    |   opConstant
    |   opConstantComposite
    |   opConstantFalse
    |   opConstantFunctionPointerINTEL
    |   opConstantNull
    |   opConstantPipeStorage
    |   opConstantSampler
    |   opConstantTrue
    |   opConvertBF16ToFINTEL
    |   opConvertFToBF16INTEL
    |   opConvertFToS
    |   opConvertFToU
    |   opConvertImageToUNV
    |   opConvertPtrToU
    |   opConvertSToF
    |   opConvertSampledImageToUNV
    |   opConvertSamplerToUNV
    |   opConvertUToAccelerationStructureKHR
    |   opConvertUToF
    |   opConvertUToImageNV
    |   opConvertUToPtr
    |   opConvertUToSampledImageNV
    |   opConvertUToSamplerNV
    |   opCooperativeMatrixLengthKHR
    |   opCooperativeMatrixLengthNV
    |   opCooperativeMatrixLoadKHR
    |   opCooperativeMatrixLoadNV
    |   opCooperativeMatrixMulAddKHR
    |   opCooperativeMatrixMulAddNV
    |   opCopyLogical
    |   opCopyObject
    |   opCreatePipeFromPipeStorage
    |   opCreateUserEvent
    |   opCrossWorkgroupCastToPtrINTEL
    |   opDPdx
    |   opDPdxCoarse
    |   opDPdxFine
    |   opDPdy
    |   opDPdyCoarse
    |   opDPdyFine
    |   opDecorationGroup
    |   opDepthAttachmentReadEXT
    |   opDot
    |   opEnqueueKernel
    |   opEnqueueMarker
    |   opExpectKHR
    |   opExtInst
    |   opExtInstImport
    |   opFAdd
    |   opFConvert
    |   opFDiv
    |   opFMod
    |   opFMul
    |   opFNegate
    |   opFOrdEqual
    |   opFOrdGreaterThan
    |   opFOrdGreaterThanEqual
    |   opFOrdLessThan
    |   opFOrdLessThanEqual
    |   opFOrdNotEqual
    |   opFPGARegINTEL
    |   opFRem
    |   opFSub
    |   opFUnordEqual
    |   opFUnordGreaterThan
    |   opFUnordGreaterThanEqual
    |   opFUnordLessThan
    |   opFUnordLessThanEqual
    |   opFUnordNotEqual
    |   opFetchMicroTriangleVertexBarycentricNV
    |   opFetchMicroTriangleVertexPositionNV
    |   opFinishWritingNodePayloadAMDX
    |   opFixedCosINTEL
    |   opFixedCosPiINTEL
    |   opFixedExpINTEL
    |   opFixedLogINTEL
    |   opFixedRecipINTEL
    |   opFixedRsqrtINTEL
    |   opFixedSinCosINTEL
    |   opFixedSinCosPiINTEL
    |   opFixedSinINTEL
    |   opFixedSinPiINTEL
    |   opFixedSqrtINTEL
    |   opFragmentFetchAMD
    |   opFragmentMaskFetchAMD
    |   opFunction
    |   opFunctionCall
    |   opFunctionParameter
    |   opFunctionPointerCallINTEL
    |   opFwidth
    |   opFwidthCoarse
    |   opFwidthFine
    |   opGenericCastToPtr
    |   opGenericCastToPtrExplicit
    |   opGenericPtrMemSemantics
    |   opGetDefaultQueue
    |   opGetKernelLocalSizeForSubgroupCount
    |   opGetKernelMaxNumSubgroups
    |   opGetKernelNDrangeMaxSubGroupSize
    |   opGetKernelNDrangeSubGroupCount
    |   opGetKernelPreferredWorkGroupSizeMultiple
    |   opGetKernelWorkGroupSize
    |   opGetMaxPipePackets
    |   opGetNumPipePackets
    |   opGroupAll
    |   opGroupAny
    |   opGroupAsyncCopy
    |   opGroupBitwiseAndKHR
    |   opGroupBitwiseOrKHR
    |   opGroupBitwiseXorKHR
    |   opGroupBroadcast
    |   opGroupFAdd
    |   opGroupFAddNonUniformAMD
    |   opGroupFMax
    |   opGroupFMaxNonUniformAMD
    |   opGroupFMin
    |   opGroupFMinNonUniformAMD
    |   opGroupFMulKHR
    |   opGroupIAdd
    |   opGroupIAddNonUniformAMD
    |   opGroupIMulKHR
    |   opGroupLogicalAndKHR
    |   opGroupLogicalOrKHR
    |   opGroupLogicalXorKHR
    |   opGroupNonUniformAll
    |   opGroupNonUniformAllEqual
    |   opGroupNonUniformAny
    |   opGroupNonUniformBallot
    |   opGroupNonUniformBallotBitCount
    |   opGroupNonUniformBallotBitExtract
    |   opGroupNonUniformBallotFindLSB
    |   opGroupNonUniformBallotFindMSB
    |   opGroupNonUniformBitwiseAnd
    |   opGroupNonUniformBitwiseOr
    |   opGroupNonUniformBitwiseXor
    |   opGroupNonUniformBroadcast
    |   opGroupNonUniformBroadcastFirst
    |   opGroupNonUniformElect
    |   opGroupNonUniformFAdd
    |   opGroupNonUniformFMax
    |   opGroupNonUniformFMin
    |   opGroupNonUniformFMul
    |   opGroupNonUniformIAdd
    |   opGroupNonUniformIMul
    |   opGroupNonUniformInverseBallot
    |   opGroupNonUniformLogicalAnd
    |   opGroupNonUniformLogicalOr
    |   opGroupNonUniformLogicalXor
    |   opGroupNonUniformPartitionNV
    |   opGroupNonUniformQuadBroadcast
    |   opGroupNonUniformQuadSwap
    |   opGroupNonUniformRotateKHR
    |   opGroupNonUniformSMax
    |   opGroupNonUniformSMin
    |   opGroupNonUniformShuffle
    |   opGroupNonUniformShuffleDown
    |   opGroupNonUniformShuffleUp
    |   opGroupNonUniformShuffleXor
    |   opGroupNonUniformUMax
    |   opGroupNonUniformUMin
    |   opGroupReserveReadPipePackets
    |   opGroupReserveWritePipePackets
    |   opGroupSMax
    |   opGroupSMaxNonUniformAMD
    |   opGroupSMin
    |   opGroupSMinNonUniformAMD
    |   opGroupUMax
    |   opGroupUMaxNonUniformAMD
    |   opGroupUMin
    |   opGroupUMinNonUniformAMD
    |   opHitObjectGetCurrentTimeNV
    |   opHitObjectGetGeometryIndexNV
    |   opHitObjectGetHitKindNV
    |   opHitObjectGetInstanceCustomIndexNV
    |   opHitObjectGetInstanceIdNV
    |   opHitObjectGetObjectRayDirectionNV
    |   opHitObjectGetObjectRayOriginNV
    |   opHitObjectGetObjectToWorldNV
    |   opHitObjectGetPrimitiveIndexNV
    |   opHitObjectGetRayTMaxNV
    |   opHitObjectGetRayTMinNV
    |   opHitObjectGetShaderBindingTableRecordIndexNV
    |   opHitObjectGetShaderRecordBufferHandleNV
    |   opHitObjectGetWorldRayDirectionNV
    |   opHitObjectGetWorldRayOriginNV
    |   opHitObjectGetWorldToObjectNV
    |   opHitObjectIsEmptyNV
    |   opHitObjectIsHitNV
    |   opHitObjectIsMissNV
    |   opIAdd
    |   opIAddCarry
    |   opIAddSatINTEL
    |   opIAverageINTEL
    |   opIAverageRoundedINTEL
    |   opIEqual
    |   opIMul
    |   opIMul32x16INTEL
    |   opINotEqual
    |   opISub
    |   opISubBorrow
    |   opISubSatINTEL
    |   opImage
    |   opImageBlockMatchSADQCOM
    |   opImageBlockMatchSSDQCOM
    |   opImageBoxFilterQCOM
    |   opImageDrefGather
    |   opImageFetch
    |   opImageGather
    |   opImageQueryFormat
    |   opImageQueryLevels
    |   opImageQueryLod
    |   opImageQueryOrder
    |   opImageQuerySamples
    |   opImageQuerySize
    |   opImageQuerySizeLod
    |   opImageRead
    |   opImageSampleDrefExplicitLod
    |   opImageSampleDrefImplicitLod
    |   opImageSampleExplicitLod
    |   opImageSampleFootprintNV
    |   opImageSampleImplicitLod
    |   opImageSampleProjDrefExplicitLod
    |   opImageSampleProjDrefImplicitLod
    |   opImageSampleProjExplicitLod
    |   opImageSampleProjImplicitLod
    |   opImageSampleWeightedQCOM
    |   opImageSparseDrefGather
    |   opImageSparseFetch
    |   opImageSparseGather
    |   opImageSparseRead
    |   opImageSparseSampleDrefExplicitLod
    |   opImageSparseSampleDrefImplicitLod
    |   opImageSparseSampleExplicitLod
    |   opImageSparseSampleImplicitLod
    |   opImageSparseSampleProjDrefExplicitLod
    |   opImageSparseSampleProjDrefImplicitLod
    |   opImageSparseSampleProjExplicitLod
    |   opImageSparseSampleProjImplicitLod
    |   opImageSparseTexelsResident
    |   opImageTexelPointer
    |   opInBoundsAccessChain
    |   opInBoundsPtrAccessChain
    |   opIsFinite
    |   opIsHelperInvocationEXT
    |   opIsInf
    |   opIsNan
    |   opIsNormal
    |   opIsValidEvent
    |   opIsValidReserveId
    |   opLabel
    |   opLessOrGreater
    |   opLoad
    |   opLogicalAnd
    |   opLogicalEqual
    |   opLogicalNot
    |   opLogicalNotEqual
    |   opLogicalOr
    |   opMaskedGatherINTEL
    |   opMatrixTimesMatrix
    |   opMatrixTimesScalar
    |   opMatrixTimesVector
    |   opNamedBarrierInitialize
    |   opNot
    |   opOrdered
    |   opOuterProduct
    |   opPhi
    |   opPtrAccessChain
    |   opPtrCastToCrossWorkgroupINTEL
    |   opPtrCastToGeneric
    |   opPtrDiff
    |   opPtrEqual
    |   opPtrNotEqual
    |   opQuantizeToF16
    |   opRayQueryGetIntersectionBarycentricsKHR
    |   opRayQueryGetIntersectionCandidateAABBOpaqueKHR
    |   opRayQueryGetIntersectionFrontFaceKHR
    |   opRayQueryGetIntersectionGeometryIndexKHR
    |   opRayQueryGetIntersectionInstanceCustomIndexKHR
    |   opRayQueryGetIntersectionInstanceIdKHR
    |   opRayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR
    |   opRayQueryGetIntersectionObjectRayDirectionKHR
    |   opRayQueryGetIntersectionObjectRayOriginKHR
    |   opRayQueryGetIntersectionObjectToWorldKHR
    |   opRayQueryGetIntersectionPrimitiveIndexKHR
    |   opRayQueryGetIntersectionTKHR
    |   opRayQueryGetIntersectionTriangleVertexPositionsKHR
    |   opRayQueryGetIntersectionTypeKHR
    |   opRayQueryGetIntersectionWorldToObjectKHR
    |   opRayQueryGetRayFlagsKHR
    |   opRayQueryGetRayTMinKHR
    |   opRayQueryGetWorldRayDirectionKHR
    |   opRayQueryGetWorldRayOriginKHR
    |   opRayQueryProceedKHR
    |   opReadClockKHR
    |   opReadPipe
    |   opReadPipeBlockingINTEL
    |   opReportIntersectionKHR
    |   opReportIntersectionNV
    |   opReserveReadPipePackets
    |   opReserveWritePipePackets
    |   opReservedReadPipe
    |   opReservedWritePipe
    |   opSConvert
    |   opSDiv
    |   opSDot
    |   opSDotAccSat
    |   opSDotAccSatKHR
    |   opSDotKHR
    |   opSGreaterThan
    |   opSGreaterThanEqual
    |   opSLessThan
    |   opSLessThanEqual
    |   opSMod
    |   opSMulExtended
    |   opSNegate
    |   opSRem
    |   opSUDot
    |   opSUDotAccSat
    |   opSUDotAccSatKHR
    |   opSUDotKHR
    |   opSampledImage
    |   opSatConvertSToU
    |   opSatConvertUToS
    |   opSaveMemoryINTEL
    |   opSelect
    |   opShiftLeftLogical
    |   opShiftRightArithmetic
    |   opShiftRightLogical
    |   opSignBitSet
    |   opSizeOf
    |   opSpecConstant
    |   opSpecConstantComposite
    |   opSpecConstantFalse
    |   opSpecConstantOp
    |   opSpecConstantTrue
    |   opStencilAttachmentReadEXT
    |   opString
    |   opSubgroupAllEqualKHR
    |   opSubgroupAllKHR
    |   opSubgroupAnyKHR
    |   opSubgroupAvcBmeInitializeINTEL
    |   opSubgroupAvcFmeInitializeINTEL
    |   opSubgroupAvcImeAdjustRefOffsetINTEL
    |   opSubgroupAvcImeConvertToMcePayloadINTEL
    |   opSubgroupAvcImeConvertToMceResultINTEL
    |   opSubgroupAvcImeEvaluateWithDualReferenceINTEL
    |   opSubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL
    |   opSubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL
    |   opSubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL
    |   opSubgroupAvcImeEvaluateWithSingleReferenceINTEL
    |   opSubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL
    |   opSubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL
    |   opSubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL
    |   opSubgroupAvcImeGetBorderReachedINTEL
    |   opSubgroupAvcImeGetDualReferenceStreaminINTEL
    |   opSubgroupAvcImeGetSingleReferenceStreaminINTEL
    |   opSubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL
    |   opSubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL
    |   opSubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL
    |   opSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL
    |   opSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL
    |   opSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL
    |   opSubgroupAvcImeGetTruncatedSearchIndicationINTEL
    |   opSubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL
    |   opSubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL
    |   opSubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL
    |   opSubgroupAvcImeInitializeINTEL
    |   opSubgroupAvcImeRefWindowSizeINTEL
    |   opSubgroupAvcImeSetDualReferenceINTEL
    |   opSubgroupAvcImeSetEarlySearchTerminationThresholdINTEL
    |   opSubgroupAvcImeSetMaxMotionVectorCountINTEL
    |   opSubgroupAvcImeSetSingleReferenceINTEL
    |   opSubgroupAvcImeSetUnidirectionalMixDisableINTEL
    |   opSubgroupAvcImeSetWeightedSadINTEL
    |   opSubgroupAvcImeStripDualReferenceStreamoutINTEL
    |   opSubgroupAvcImeStripSingleReferenceStreamoutINTEL
    |   opSubgroupAvcMceConvertToImePayloadINTEL
    |   opSubgroupAvcMceConvertToImeResultINTEL
    |   opSubgroupAvcMceConvertToRefPayloadINTEL
    |   opSubgroupAvcMceConvertToRefResultINTEL
    |   opSubgroupAvcMceConvertToSicPayloadINTEL
    |   opSubgroupAvcMceConvertToSicResultINTEL
    |   opSubgroupAvcMceGetBestInterDistortionsINTEL
    |   opSubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL
    |   opSubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL
    |   opSubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL
    |   opSubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL
    |   opSubgroupAvcMceGetDefaultInterShapePenaltyINTEL
    |   opSubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL
    |   opSubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL
    |   opSubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL
    |   opSubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL
    |   opSubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL
    |   opSubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL
    |   opSubgroupAvcMceGetInterDirectionsINTEL
    |   opSubgroupAvcMceGetInterDistortionsINTEL
    |   opSubgroupAvcMceGetInterMajorShapeINTEL
    |   opSubgroupAvcMceGetInterMinorShapeINTEL
    |   opSubgroupAvcMceGetInterMotionVectorCountINTEL
    |   opSubgroupAvcMceGetInterReferenceIdsINTEL
    |   opSubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL
    |   opSubgroupAvcMceGetMotionVectorsINTEL
    |   opSubgroupAvcMceSetAcOnlyHaarINTEL
    |   opSubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL
    |   opSubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL
    |   opSubgroupAvcMceSetInterDirectionPenaltyINTEL
    |   opSubgroupAvcMceSetInterShapePenaltyINTEL
    |   opSubgroupAvcMceSetMotionVectorCostFunctionINTEL
    |   opSubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL
    |   opSubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL
    |   opSubgroupAvcRefConvertToMcePayloadINTEL
    |   opSubgroupAvcRefConvertToMceResultINTEL
    |   opSubgroupAvcRefEvaluateWithDualReferenceINTEL
    |   opSubgroupAvcRefEvaluateWithMultiReferenceINTEL
    |   opSubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL
    |   opSubgroupAvcRefEvaluateWithSingleReferenceINTEL
    |   opSubgroupAvcRefSetBidirectionalMixDisableINTEL
    |   opSubgroupAvcRefSetBilinearFilterEnableINTEL
    |   opSubgroupAvcSicConfigureIpeLumaChromaINTEL
    |   opSubgroupAvcSicConfigureIpeLumaINTEL
    |   opSubgroupAvcSicConfigureSkcINTEL
    |   opSubgroupAvcSicConvertToMcePayloadINTEL
    |   opSubgroupAvcSicConvertToMceResultINTEL
    |   opSubgroupAvcSicEvaluateIpeINTEL
    |   opSubgroupAvcSicEvaluateWithDualReferenceINTEL
    |   opSubgroupAvcSicEvaluateWithMultiReferenceINTEL
    |   opSubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL
    |   opSubgroupAvcSicEvaluateWithSingleReferenceINTEL
    |   opSubgroupAvcSicGetBestIpeChromaDistortionINTEL
    |   opSubgroupAvcSicGetBestIpeLumaDistortionINTEL
    |   opSubgroupAvcSicGetInterRawSadsINTEL
    |   opSubgroupAvcSicGetIpeChromaModeINTEL
    |   opSubgroupAvcSicGetIpeLumaShapeINTEL
    |   opSubgroupAvcSicGetMotionVectorMaskINTEL
    |   opSubgroupAvcSicGetPackedIpeLumaModesINTEL
    |   opSubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL
    |   opSubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL
    |   opSubgroupAvcSicInitializeINTEL
    |   opSubgroupAvcSicSetBilinearFilterEnableINTEL
    |   opSubgroupAvcSicSetBlockBasedRawSkipSadINTEL
    |   opSubgroupAvcSicSetIntraChromaModeCostFunctionINTEL
    |   opSubgroupAvcSicSetIntraLumaModeCostFunctionINTEL
    |   opSubgroupAvcSicSetIntraLumaShapePenaltyINTEL
    |   opSubgroupAvcSicSetSkcForwardTransformEnableINTEL
    |   opSubgroupBallotKHR
    |   opSubgroupBlockReadINTEL
    |   opSubgroupFirstInvocationKHR
    |   opSubgroupImageBlockReadINTEL
    |   opSubgroupImageMediaBlockReadINTEL
    |   opSubgroupReadInvocationKHR
    |   opSubgroupShuffleDownINTEL
    |   opSubgroupShuffleINTEL
    |   opSubgroupShuffleUpINTEL
    |   opSubgroupShuffleXorINTEL
    |   opTranspose
    |   opTypeAccelerationStructureKHR
    |   opTypeAccelerationStructureNV
    |   opTypeArray
    |   opTypeAvcImeDualReferenceStreaminINTEL
    |   opTypeAvcImePayloadINTEL
    |   opTypeAvcImeResultDualReferenceStreamoutINTEL
    |   opTypeAvcImeResultINTEL
    |   opTypeAvcImeResultSingleReferenceStreamoutINTEL
    |   opTypeAvcImeSingleReferenceStreaminINTEL
    |   opTypeAvcMcePayloadINTEL
    |   opTypeAvcMceResultINTEL
    |   opTypeAvcRefPayloadINTEL
    |   opTypeAvcRefResultINTEL
    |   opTypeAvcSicPayloadINTEL
    |   opTypeAvcSicResultINTEL
    |   opTypeBool
    |   opTypeBufferSurfaceINTEL
    |   opTypeCooperativeMatrixKHR
    |   opTypeCooperativeMatrixNV
    |   opTypeDeviceEvent
    |   opTypeEvent
    |   opTypeFloat
    |   opTypeFunction
    |   opTypeHitObjectNV
    |   opTypeImage
    |   opTypeInt
    |   opTypeMatrix
    |   opTypeNamedBarrier
    |   opTypeOpaque
    |   opTypePipe
    |   opTypePipeStorage
    |   opTypePointer
    |   opTypeQueue
    |   opTypeRayQueryKHR
    |   opTypeReserveId
    |   opTypeRuntimeArray
    |   opTypeSampledImage
    |   opTypeSampler
    |   opTypeStruct
    |   opTypeVector
    |   opTypeVmeImageINTEL
    |   opTypeVoid
    |   opUAddSatINTEL
    |   opUAverageINTEL
    |   opUAverageRoundedINTEL
    |   opUConvert
    |   opUCountLeadingZerosINTEL
    |   opUCountTrailingZerosINTEL
    |   opUDiv
    |   opUDot
    |   opUDotAccSat
    |   opUDotAccSatKHR
    |   opUDotKHR
    |   opUGreaterThan
    |   opUGreaterThanEqual
    |   opULessThan
    |   opULessThanEqual
    |   opUMod
    |   opUMul32x16INTEL
    |   opUMulExtended
    |   opUSubSatINTEL
    |   opUndef
    |   opUnordered
    |   opVariable
    |   opVariableLengthArrayINTEL
    |   opVectorExtractDynamic
    |   opVectorInsertDynamic
    |   opVectorShuffle
    |   opVectorTimesMatrix
    |   opVectorTimesScalar
    |   opVmeImageINTEL
    |   opWritePipe
    |   opWritePipeBlockingINTEL
    ;

// Alias types
a : idRef;
accel : idRef;
accelerationStructure : idRef;
access : hostAccessQualifier;
accumulator : idRef;
addressWidth : literalInteger;
aliasDomain : idRef;
aliasScope : idRef;
aliasingScopesList : idRef;
alignmentIdRef : idRef;
alignmentLiteralInteger : literalInteger;
argument : idRef;
argument0 : idRef;
arrayMember : literalInteger;
arrayStride : literalInteger;
arrayed : literalInteger;
asm : idRef;
asmInstructions : literalString;
asmTarget : literalString;
asmType : idRef;
attachment : idRef;
attachmentIndex : literalInteger;
b : idRef;
bFloat16Value : idRef;
backwardReferenceFieldPolarity : idRef;
bankBits : literalInteger;
bankWidth : literalInteger;
banks : literalInteger;
barrierCount : literalInteger;
barycentric : idRef;
base : idRef;
bidirectionalWeight : idRef;
bindingPoint : literalInteger;
bitWidth : literalInteger;
bits : idRef;
blockBasedSkipType : idRef;
blockSize : idRef;
boxSize : idRef;
branchWeights : literalInteger;
bufferLocationID : literalInteger;
bwdRefImage : idRef;
bwdRefOffset : idRef;
byteOffset : literalInteger;
c : idRef;
cacheControlLoadCacheControl : loadCacheControl;
cacheControlStoreCacheControl : storeCacheControl;
cacheLevel : literalInteger;
cacheSizeInBytes : literalInteger;
callableData : idRef;
callableDataId : idRef;
capacity : literalInteger;
chromaModeBasePenalty : idRef;
clusterSize : idRef;
coarse : idRef;
column : literalInteger;
columnCount : literalInteger;
columnMajor : idRef;
columnType : idRef;
columns : idRef;
comparator : idRef;
componentCount : literalInteger;
componentIdRef : idRef;
componentLiteralInteger : literalInteger;
componentType : idRef;
components : literalInteger;
composite : idRef;
condition : idRef;
constituents : idRef;
constraints : literalString;
continueTarget : idRef;
continuedSource : literalString;
controlType : literalInteger;
coordinate : idRef;
coordinates : idRef;
costPrecision : idRef;
count : idRef;
counterBuffer : idRef;
cullMask : idRef;
current : idRef;
currentTime : idRef;
cycles : literalInteger;
d : idRef;
data : idRef;
dataWidth : literalInteger;
decorationGroup : idRef;
default : idRef;
delta : idRef;
depthLiteralInteger : literalInteger;
descriptorSet : literalInteger;
destination : idRef;
direction : idRef;
directionCost : idRef;
dualRef : idRef;
element : idRef;
elementType : idRef;
enable : literalInteger;
enableSubnormals : literalInteger;
entryPoint : idRef;
equal : idMemorySemantics;
event : idRef;
eventsList : idRef;
execution : idScope;
expectedValue : idRef;
extension : literalString;
falseLabel : idRef;
fast : fPFastMathMode;
file : idRef;
fillEmpty : idRef;
flags : idRef;
floatValue : idRef;
floating : fPRoundingMode;
forceKey : literalInteger;
forwardReferenceFieldPolarity : idRef;
fragmentIndex : idRef;
fromSign : literalInteger;
function : idRef;
functionType : idRef;
fwdRefImage : idRef;
fwdRefOffset : idRef;
geometryIndex : idRef;
globalWorkOffset : idRef;
globalWorkSize : idRef;
granularity : idRef;
groupCountX : idRef;
groupCountY : idRef;
groupCountZ : idRef;
height : idRef;
hint : idRef;
hit : idRef;
hitKind : idRef;
hitObject : idRef;
hitObjectAttribute : idRef;
hitObjectAttributes : idRef;
hitT : idRef;
i : literalInteger;
iOPipeID : literalInteger;
id : idRef;
image : idRef;
imageSelect : idRef;
imageSize : idRef;
imageType : idRef;
indexIdRef : idRef;
indexLiteralInteger : literalInteger;
indexOffset : idRef;
indexesIdRef : idRef;
indexesLiteralInteger : literalInteger;
initializer : idRef;
input : idRef;
inputType : idRef;
inputVector : idRef;
insert : idRef;
instanceId : idRef;
instruction : literalExtInstInteger;
integerValue : idRef;
interface : idRef;
intersection : idRef;
intraNeighbourAvailabilty : idRef;
invocationId : idRef;
invocations : literalInteger;
invoke : idRef;
kind : literalInteger;
latency : literalInteger;
latencyLabel : literalInteger;
leftEdgeChromaPixels : idRef;
leftEdgeLumaPixels : idRef;
leftMatrix : idRef;
lenght : idRef;
length : idRef;
levelOfDetail : idRef;
line : literalInteger;
localId : idRef;
localSize : idRef;
localWorkSize : idRef;
location : literalInteger;
loopControlParameters : literalInteger;
lumaIntraPartitionMask : idRef;
lumaModePenalty : idRef;
lumaPackedNeighborModes : idRef;
lumaPackedNonDcPenalty : idRef;
m1 : literalInteger;
m2 : literalInteger;
mS : literalInteger;
majorShape : idRef;
majorShapes : idRef;
mask : idRef;
matrix : idRef;
matrixStride : literalInteger;
max : literalInteger;
maxBurstCount : literalInteger;
maxByteOffsetIdRef : idRef;
maxByteOffsetLiteralInteger : literalInteger;
maxError : literalFloat;
maxMotionVectorCount : idRef;
maxNumberOfPayloads : idRef;
maximumCopies : literalInteger;
maximumReplicates : literalInteger;
member : literalInteger;
memberType : idRef;
memory : idScope;
memoryLayout : idRef;
memoryOperand : memoryAccess;
memoryType : literalString;
mergeBlock : idRef;
mergeKey : literalString;
mergeType : literalString;
minorShapes : idRef;
missIndex : idRef;
modeExecutionMode : executionMode;
modeLiteralInteger : literalInteger;
motionVectors : idRef;
mout : literalInteger;
n : literalInteger;
nDRange : idRef;
nameIdRef : idRef;
nameLiteralString : literalString;
namedBarrier : idRef;
next : idRef;
nodeIndex : idRef;
nodeName : literalString;
numElements : idRef;
numEvents : idRef;
numPackets : idRef;
numberOf : literalInteger;
numberOfRecursions : idRef;
o : literalInteger;
object : idRef;
object1 : idRef;
object2 : idRef;
offsetIdRef : idRef;
offsetLiteralInteger : literalInteger;
opcode : literalSpecConstantOpInteger;
operand : idRef;
operand1 : idRef;
operand2 : idRef;
operation : groupOperation;
origin : idRef;
p : idRef;
packedCostCenterDelta : idRef;
packedCostTable : idRef;
packedIndices : idRef;
packedReferenceFieldPolarities : idRef;
packedReferenceIds : idRef;
packedReferenceParameterFieldPolarities : idRef;
packedSadCoefficients : idRef;
packedSadWeights : idRef;
packedShapePenalty : idRef;
packetAlignmentIdRef : idRef;
packetAlignmentLiteralInteger : literalInteger;
packetSizeIdRef : idRef;
packetSizeLiteralInteger : literalInteger;
paramAlign : idRef;
paramIdRef : idRef;
paramLiteralInteger : literalInteger;
paramSize : idRef;
parameterType : idRef;
partitionMask : idRef;
payload : idRef;
payloadArray : idRef;
payloadCount : idRef;
payloadId : idRef;
pipe : idRef;
pipeStorage : idRef;
pixelResolution : idRef;
pointer : idRef;
pointerType : idRef;
predicate : idRef;
prefetcherSizeInBytes : literalInteger;
previous : idRef;
primitiveCountIdRef : idRef;
primitiveCountLiteralInteger : literalInteger;
primitiveId : idRef;
primitiveIndex : idRef;
process : literalString;
profilingInfo : idRef;
propagate : literalInteger;
ptr : idRef;
ptrVector : idRef;
q : literalInteger;
qp : idRef;
qualifier : accessQualifier;
queue : idRef;
rI : literalInteger;
rayDirection : idRef;
rayFlagsIdRef : idRef;
rayOrigin : idRef;
rayQuery : idRef;
rayTmax : idRef;
rayTmin : idRef;
readWriteMode : accessQualifier;
refImage : idRef;
refOffset : idRef;
refWindowSize : idRef;
reference : idRef;
referenceBasePenalty : idRef;
referenceCoordinates : idRef;
referenceFieldPolarity : idRef;
register : literalString;
relativeCycle : literalInteger;
relativeTo : literalInteger;
reserveId : idRef;
residentCode : idRef;
result : idRef;
retEvent : idRef;
returnType : idRef;
rightMatrix : idRef;
roundingAccuracy : literalInteger;
roundingMode : literalInteger;
rows : idRef;
s : literalInteger;
sADAdjustment : idRef;
sBTIndex : idRef;
sBTOffset : idRef;
sBTRecordIndex : idRef;
sBTRecordOffset : idRef;
sBTRecordStride : idRef;
sBTStride : idRef;
sample : idRef;
sampled : literalInteger;
sampledImage : idRef;
sampledType : idRef;
sampler : idRef;
scalar : idRef;
scopeIdScope : idScope;
searchWindowConfig : idRef;
selector : idRef;
semantic : literalString;
semantics : idMemorySemantics;
set : idRef;
shaderIndex : idRef;
shift : idRef;
signedValue : idRef;
signedness : literalInteger;
sizeIdRef : idRef;
sizeLiteralInteger : literalInteger;
skipBlockPartitionType : idRef;
skipMotionVectorMask : idRef;
sliceType : idRef;
sourceFieldPolarity : idRef;
sourceIdRef : idRef;
sourceLiteralString : literalString;
specializationConstantID : literalInteger;
srcCoord : idRef;
srcImage : idRef;
stallFreeReturn : literalInteger;
status : idRef;
storage : storageClass;
stream : idRef;
streamNumber : literalInteger;
streaminComponents : idRef;
stride : idRef;
strideSize : literalInteger;
string : literalString;
structType : idRef;
structure : idRef;
structureType : idRef;
subgroupCount : idRef;
subgroupSize : literalInteger;
subgroupsPerWorkgroupIdRef : idRef;
subgroupsPerWorkgroupLiteralInteger : literalInteger;
tMax : idRef;
tMin : idRef;
targetCoordinates : idRef;
targetIdRef : idRef;
targetLabel : idRef;
targetLiteralInteger : literalInteger;
targetPairLiteralIntegerIdRef : pairLiteralIntegerIdRef;
targetWidth : literalInteger;
targetsIdRef : idRef;
targetsPairIdRefLiteralInteger : pairIdRefLiteralInteger;
texel : idRef;
texture : idRef;
theNameOfTheOpaqueType : literalString;
threshold : idRef;
time : idRef;
trigger : initializationModeQualifier;
trueLabel : idRef;
type : idRef;
unequal : idMemorySemantics;
unsignedValue : idRef;
upperEdgeChromaPixels : idRef;
upperEdgeLumaPixels : idRef;
upperLeftCornerChromaPixel : idRef;
upperLeftCornerLumaPixel : idRef;
upperRightEdgeLumaPixels : idRef;
use : idRef;
userType : literalString;
valueIdRef : idRef;
valueLiteralContextDependentNumber : literalContextDependentNumber;
valueLiteralInteger : literalInteger;
variable : pairIdRefIdRef;
vector1 : idRef;
vector2 : idRef;
vectorIdRef : idRef;
vectorLiteralInteger : literalInteger;
vectorType : literalInteger;
version : literalInteger;
vertexCountIdRef : idRef;
vertexCountLiteralInteger : literalInteger;
visibility : idScope;
waitEvents : idRef;
waitForDoneWrite : literalInteger;
waitrequest : literalInteger;
weights : idRef;
widthIdRef : idRef;
widthLiteralInteger : literalInteger;
wordSize : literalInteger;
x : idRef;
xFBBufferNumber : literalInteger;
xFBStride : literalInteger;
xSizeHint : idRef;
xSizeIdRef : idRef;
xSizeLiteralInteger : literalInteger;
y : idRef;
ySizeHint : idRef;
ySizeIdRef : idRef;
ySizeLiteralInteger : literalInteger;
zSizeHint : idRef;
zSizeIdRef : idRef;
zSizeLiteralInteger : literalInteger;

// Types
accessQualifier
    :   ReadOnly
    |   ReadWrite
    |   WriteOnly
    ;

addressingModel
    :   Logical
    |   Physical32
    |   Physical64
    |   PhysicalStorageBuffer64
    |   PhysicalStorageBuffer64EXT
    ;

builtIn
    :   BaryCoordKHR
    |   BaryCoordNV
    |   BaryCoordNoPerspAMD
    |   BaryCoordNoPerspCentroidAMD
    |   BaryCoordNoPerspKHR
    |   BaryCoordNoPerspNV
    |   BaryCoordNoPerspSampleAMD
    |   BaryCoordPullModelAMD
    |   BaryCoordSmoothAMD
    |   BaryCoordSmoothCentroidAMD
    |   BaryCoordSmoothSampleAMD
    |   BaseInstance
    |   BaseVertex
    |   ClipDistance
    |   ClipDistancePerViewNV
    |   CoalescedInputCountAMDX
    |   CoreCountARM
    |   CoreIDARM
    |   CoreMaxIDARM
    |   CullDistance
    |   CullDistancePerViewNV
    |   CullMaskKHR
    |   CullPrimitiveEXT
    |   CurrentRayTimeNV
    |   DeviceIndex
    |   DrawIndex
    |   EnqueuedWorkgroupSize
    |   FragCoord
    |   FragDepth
    |   FragInvocationCountEXT
    |   FragSizeEXT
    |   FragStencilRefEXT
    |   FragmentSizeNV
    |   FrontFacing
    |   FullyCoveredEXT
    |   GlobalInvocationId
    |   GlobalLinearId
    |   GlobalOffset
    |   GlobalSize
    |   HelperInvocation
    |   HitKindBackFacingMicroTriangleNV
    |   HitKindFrontFacingMicroTriangleNV
    |   HitKindKHR
    |   HitKindNV
    |   HitMicroTriangleVertexBarycentricsNV
    |   HitMicroTriangleVertexPositionsNV
    |   HitTNV
    |   HitTriangleVertexPositionsKHR
    |   IncomingRayFlagsKHR
    |   IncomingRayFlagsNV
    |   InstanceCustomIndexKHR
    |   InstanceCustomIndexNV
    |   InstanceId
    |   InstanceIndex
    |   InvocationId
    |   InvocationsPerPixelNV
    |   LaunchIdKHR
    |   LaunchIdNV
    |   LaunchSizeKHR
    |   LaunchSizeNV
    |   Layer
    |   LayerPerViewNV
    |   LocalInvocationId
    |   LocalInvocationIndex
    |   MeshViewCountNV
    |   MeshViewIndicesNV
    |   NumEnqueuedSubgroups
    |   NumSubgroups
    |   NumWorkgroups
    |   ObjectRayDirectionKHR
    |   ObjectRayDirectionNV
    |   ObjectRayOriginKHR
    |   ObjectRayOriginNV
    |   ObjectToWorldKHR
    |   ObjectToWorldNV
    |   PatchVertices
    |   PointCoord
    |   PointSize
    |   Position
    |   PositionPerViewNV
    |   PrimitiveCountNV
    |   PrimitiveId
    |   PrimitiveIndicesNV
    |   PrimitiveLineIndicesEXT
    |   PrimitivePointIndicesEXT
    |   PrimitiveShadingRateKHR
    |   PrimitiveTriangleIndicesEXT
    |   RayGeometryIndexKHR
    |   RayTmaxKHR
    |   RayTmaxNV
    |   RayTminKHR
    |   RayTminNV
    |   SMCountNV
    |   SMIDNV
    |   SampleId
    |   SampleMask
    |   SamplePosition
    |   SecondaryPositionNV
    |   SecondaryViewportMaskNV
    |   ShaderIndexAMDX
    |   ShadingRateKHR
    |   SubgroupEqMask
    |   SubgroupEqMaskKHR
    |   SubgroupGeMask
    |   SubgroupGeMaskKHR
    |   SubgroupGtMask
    |   SubgroupGtMaskKHR
    |   SubgroupId
    |   SubgroupLeMask
    |   SubgroupLeMaskKHR
    |   SubgroupLocalInvocationId
    |   SubgroupLtMask
    |   SubgroupLtMaskKHR
    |   SubgroupMaxSize
    |   SubgroupSize
    |   TaskCountNV
    |   TessCoord
    |   TessLevelInner
    |   TessLevelOuter
    |   VertexId
    |   VertexIndex
    |   ViewIndex
    |   ViewportIndex
    |   ViewportMaskNV
    |   ViewportMaskPerViewNV
    |   WarpIDARM
    |   WarpIDNV
    |   WarpMaxIDARM
    |   WarpsPerSMNV
    |   WorkDim
    |   WorkgroupId
    |   WorkgroupSize
    |   WorldRayDirectionKHR
    |   WorldRayDirectionNV
    |   WorldRayOriginKHR
    |   WorldRayOriginNV
    |   WorldToObjectKHR
    |   WorldToObjectNV
    ;

capability
    :   Addresses
    |   ArbitraryPrecisionFixedPointINTEL
    |   ArbitraryPrecisionFloatingPointINTEL
    |   ArbitraryPrecisionIntegersINTEL
    |   AsmINTEL
    |   AtomicFloat16AddEXT
    |   AtomicFloat16MinMaxEXT
    |   AtomicFloat32AddEXT
    |   AtomicFloat32MinMaxEXT
    |   AtomicFloat64AddEXT
    |   AtomicFloat64MinMaxEXT
    |   AtomicStorage
    |   AtomicStorageOps
    |   BFloat16ConversionINTEL
    |   BindlessTextureNV
    |   BitInstructions
    |   BlockingPipesINTEL
    |   CacheControlsINTEL
    |   ClipDistance
    |   ComputeDerivativeGroupLinearNV
    |   ComputeDerivativeGroupQuadsNV
    |   CooperativeMatrixKHR
    |   CooperativeMatrixNV
    |   CoreBuiltinsARM
    |   CullDistance
    |   DebugInfoModuleINTEL
    |   DemoteToHelperInvocation
    |   DemoteToHelperInvocationEXT
    |   DenormFlushToZero
    |   DenormPreserve
    |   DerivativeControl
    |   DeviceEnqueue
    |   DeviceGroup
    |   DisplacementMicromapNV
    |   DotProduct
    |   DotProductInput4x8Bit
    |   DotProductInput4x8BitKHR
    |   DotProductInput4x8BitPacked
    |   DotProductInput4x8BitPackedKHR
    |   DotProductInputAll
    |   DotProductInputAllKHR
    |   DotProductKHR
    |   DrawParameters
    |   ExpectAssumeKHR
    |   FPFastMathModeINTEL
    |   FPGAArgumentInterfacesINTEL
    |   FPGABufferLocationINTEL
    |   FPGAClusterAttributesINTEL
    |   FPGAClusterAttributesV2INTEL
    |   FPGADSPControlINTEL
    |   FPGAInvocationPipeliningAttributesINTEL
    |   FPGAKernelAttributesINTEL
    |   FPGAKernelAttributesv2INTEL
    |   FPGALatencyControlINTEL
    |   FPGALoopControlsINTEL
    |   FPGAMemoryAccessesINTEL
    |   FPGAMemoryAttributesINTEL
    |   FPGARegINTEL
    |   FPMaxErrorINTEL
    |   Float16
    |   Float16Buffer
    |   Float16ImageAMD
    |   Float64
    |   FloatingPointModeINTEL
    |   FragmentBarycentricKHR
    |   FragmentBarycentricNV
    |   FragmentDensityEXT
    |   FragmentFullyCoveredEXT
    |   FragmentMaskAMD
    |   FragmentShaderPixelInterlockEXT
    |   FragmentShaderSampleInterlockEXT
    |   FragmentShaderShadingRateInterlockEXT
    |   FragmentShadingRateKHR
    |   FunctionFloatControlINTEL
    |   FunctionPointersINTEL
    |   GenericPointer
    |   Geometry
    |   GeometryPointSize
    |   GeometryShaderPassthroughNV
    |   GeometryStreams
    |   GlobalVariableFPGADecorationsINTEL
    |   GlobalVariableHostAccessINTEL
    |   GroupNonUniform
    |   GroupNonUniformArithmetic
    |   GroupNonUniformBallot
    |   GroupNonUniformClustered
    |   GroupNonUniformPartitionedNV
    |   GroupNonUniformQuad
    |   GroupNonUniformRotateKHR
    |   GroupNonUniformShuffle
    |   GroupNonUniformShuffleRelative
    |   GroupNonUniformVote
    |   GroupUniformArithmeticKHR
    |   Groups
    |   IOPipesINTEL
    |   Image1D
    |   ImageBasic
    |   ImageBuffer
    |   ImageCubeArray
    |   ImageFootprintNV
    |   ImageGatherBiasLodAMD
    |   ImageGatherExtended
    |   ImageMSArray
    |   ImageMipmap
    |   ImageQuery
    |   ImageReadWrite
    |   ImageReadWriteLodAMD
    |   ImageRect
    |   IndirectReferencesINTEL
    |   InputAttachment
    |   InputAttachmentArrayDynamicIndexing
    |   InputAttachmentArrayDynamicIndexingEXT
    |   InputAttachmentArrayNonUniformIndexing
    |   InputAttachmentArrayNonUniformIndexingEXT
    |   Int16
    |   Int64
    |   Int64Atomics
    |   Int64ImageEXT
    |   Int8
    |   IntegerFunctions2INTEL
    |   InterpolationFunction
    |   Kernel
    |   KernelAttributesINTEL
    |   Linkage
    |   LiteralSampler
    |   LongCompositesINTEL
    |   LoopFuseINTEL
    |   MaskedGatherScatterINTEL
    |   Matrix
    |   MemoryAccessAliasingINTEL
    |   MeshShadingEXT
    |   MeshShadingNV
    |   MinLod
    |   MultiView
    |   MultiViewport
    |   NamedBarrier
    |   OptNoneINTEL
    |   PerViewAttributesNV
    |   PhysicalStorageBufferAddresses
    |   PhysicalStorageBufferAddressesEXT
    |   PipeStorage
    |   Pipes
    |   RayCullMaskKHR
    |   RayQueryKHR
    |   RayQueryPositionFetchKHR
    |   RayQueryProvisionalKHR
    |   RayTracingDisplacementMicromapNV
    |   RayTracingKHR
    |   RayTracingMotionBlurNV
    |   RayTracingNV
    |   RayTracingOpacityMicromapEXT
    |   RayTracingPositionFetchKHR
    |   RayTracingProvisionalKHR
    |   RayTraversalPrimitiveCullingKHR
    |   RoundToInfinityINTEL
    |   RoundingModeRTE
    |   RoundingModeRTZ
    |   RuntimeAlignedAttributeINTEL
    |   RuntimeDescriptorArray
    |   RuntimeDescriptorArrayEXT
    |   SampleMaskOverrideCoverageNV
    |   SampleMaskPostDepthCoverage
    |   SampleRateShading
    |   Sampled1D
    |   SampledBuffer
    |   SampledCubeArray
    |   SampledImageArrayDynamicIndexing
    |   SampledImageArrayNonUniformIndexing
    |   SampledImageArrayNonUniformIndexingEXT
    |   SampledRect
    |   Shader
    |   ShaderClockKHR
    |   ShaderEnqueueAMDX
    |   ShaderInvocationReorderNV
    |   ShaderLayer
    |   ShaderNonUniform
    |   ShaderNonUniformEXT
    |   ShaderSMBuiltinsNV
    |   ShaderStereoViewNV
    |   ShaderViewportIndex
    |   ShaderViewportIndexLayerEXT
    |   ShaderViewportIndexLayerNV
    |   ShaderViewportMaskNV
    |   ShadingRateNV
    |   SignedZeroInfNanPreserve
    |   SparseResidency
    |   SplitBarrierINTEL
    |   StencilExportEXT
    |   StorageBuffer16BitAccess
    |   StorageBuffer8BitAccess
    |   StorageBufferArrayDynamicIndexing
    |   StorageBufferArrayNonUniformIndexing
    |   StorageBufferArrayNonUniformIndexingEXT
    |   StorageImageArrayDynamicIndexing
    |   StorageImageArrayNonUniformIndexing
    |   StorageImageArrayNonUniformIndexingEXT
    |   StorageImageExtendedFormats
    |   StorageImageMultisample
    |   StorageImageReadWithoutFormat
    |   StorageImageWriteWithoutFormat
    |   StorageInputOutput16
    |   StoragePushConstant16
    |   StoragePushConstant8
    |   StorageTexelBufferArrayDynamicIndexing
    |   StorageTexelBufferArrayDynamicIndexingEXT
    |   StorageTexelBufferArrayNonUniformIndexing
    |   StorageTexelBufferArrayNonUniformIndexingEXT
    |   StorageUniform16
    |   StorageUniformBufferBlock16
    |   SubgroupAvcMotionEstimationChromaINTEL
    |   SubgroupAvcMotionEstimationINTEL
    |   SubgroupAvcMotionEstimationIntraINTEL
    |   SubgroupBallotKHR
    |   SubgroupBufferBlockIOINTEL
    |   SubgroupDispatch
    |   SubgroupImageBlockIOINTEL
    |   SubgroupImageMediaBlockIOINTEL
    |   SubgroupShuffleINTEL
    |   SubgroupVoteKHR
    |   Tessellation
    |   TessellationPointSize
    |   TextureBlockMatchQCOM
    |   TextureBoxFilterQCOM
    |   TextureSampleWeightedQCOM
    |   TileImageColorReadAccessEXT
    |   TileImageDepthReadAccessEXT
    |   TileImageStencilReadAccessEXT
    |   TransformFeedback
    |   USMStorageClassesINTEL
    |   UniformAndStorageBuffer16BitAccess
    |   UniformAndStorageBuffer8BitAccess
    |   UniformBufferArrayDynamicIndexing
    |   UniformBufferArrayNonUniformIndexing
    |   UniformBufferArrayNonUniformIndexingEXT
    |   UniformDecoration
    |   UniformTexelBufferArrayDynamicIndexing
    |   UniformTexelBufferArrayDynamicIndexingEXT
    |   UniformTexelBufferArrayNonUniformIndexing
    |   UniformTexelBufferArrayNonUniformIndexingEXT
    |   UnstructuredLoopControlsINTEL
    |   VariableLengthArrayINTEL
    |   VariablePointers
    |   VariablePointersStorageBuffer
    |   Vector16
    |   VectorAnyINTEL
    |   VectorComputeINTEL
    |   VulkanMemoryModel
    |   VulkanMemoryModelDeviceScope
    |   VulkanMemoryModelDeviceScopeKHR
    |   VulkanMemoryModelKHR
    |   WorkgroupMemoryExplicitLayout16BitAccessKHR
    |   WorkgroupMemoryExplicitLayout8BitAccessKHR
    |   WorkgroupMemoryExplicitLayoutKHR
    ;

cooperativeMatrixLayout
    :   ColumnMajorKHR
    |   RowMajorKHR
    ;

cooperativeMatrixOperands
    :   MatrixASignedComponentsKHR
    |   MatrixBSignedComponentsKHR
    |   MatrixCSignedComponentsKHR
    |   MatrixResultSignedComponentsKHR
    |   NoneKHR
    |   SaturatingAccumulationKHR
    ;

cooperativeMatrixUse
    :   MatrixAKHR
    |   MatrixAccumulatorKHR
    |   MatrixBKHR
    ;

decoration
    :   AliasScopeINTEL aliasingScopesList
    |   Aliased
    |   AliasedPointer
    |   AliasedPointerEXT
    |   Alignment alignmentLiteralInteger
    |   AlignmentId alignmentIdRef
    |   ArrayStride arrayStride
    |   BankBitsINTEL bankBits*
    |   BankwidthINTEL bankWidth
    |   Binding bindingPoint
    |   BindlessImageNV
    |   BindlessSamplerNV
    |   Block
    |   BlockMatchTextureQCOM
    |   BoundImageNV
    |   BoundSamplerNV
    |   BufferBlock
    |   BufferLocationINTEL bufferLocationID
    |   BuiltIn builtIn
    |   BurstCoalesceINTEL
    |   CPacked
    |   CacheControlLoadINTEL cacheLevel cacheControlLoadCacheControl
    |   CacheControlStoreINTEL cacheLevel cacheControlStoreCacheControl
    |   CacheSizeINTEL cacheSizeInBytes
    |   Centroid
    |   ClobberINTEL register
    |   Coherent
    |   ColMajor
    |   Component componentLiteralInteger
    |   ConduitKernelArgumentINTEL
    |   Constant
    |   CounterBuffer counterBuffer
    |   DescriptorSet descriptorSet
    |   DontStaticallyCoalesceINTEL
    |   DoublepumpINTEL
    |   ExplicitInterpAMD
    |   FPFastMathMode fast
    |   FPMaxErrorDecorationINTEL maxError
    |   FPRoundingMode floating
    |   Flat
    |   ForcePow2DepthINTEL forceKey
    |   FuncParamAttr functionParameterAttribute
    |   FuncParamIOKindINTEL kind
    |   FunctionDenormModeINTEL targetWidth fPDenormMode
    |   FunctionFloatingPointModeINTEL targetWidth fPOperationMode
    |   FunctionRoundingModeINTEL targetWidth fPRoundingMode
    |   FuseLoopsInFunctionINTEL
    |   GLSLPacked
    |   GLSLShared
    |   GlobalVariableOffsetINTEL offsetLiteralInteger
    |   HitObjectShaderRecordBufferNV
    |   HlslCounterBufferGOOGLE counterBuffer
    |   HlslSemanticGOOGLE semantic
    |   HostAccessINTEL access nameLiteralString
    |   IOPipeStorageINTEL iOPipeID
    |   ImplementInRegisterMapINTEL valueLiteralInteger
    |   Index indexLiteralInteger
    |   InitModeINTEL trigger
    |   InitiationIntervalINTEL cycles
    |   InputAttachmentIndex attachmentIndex
    |   Invariant
    |   LatencyControlConstraintINTEL relativeTo controlType relativeCycle
    |   LatencyControlLabelINTEL latencyLabel
    |   LinkageAttributes nameLiteralString linkageType
    |   Location location
    |   MMHostInterfaceAddressWidthINTEL addressWidth
    |   MMHostInterfaceDataWidthINTEL dataWidth
    |   MMHostInterfaceLatencyINTEL latency
    |   MMHostInterfaceMaxBurstINTEL maxBurstCount
    |   MMHostInterfaceReadWriteModeINTEL readWriteMode
    |   MMHostInterfaceWaitRequestINTEL waitrequest
    |   MathOpDSPModeINTEL modeLiteralInteger propagate
    |   MatrixStride matrixStride
    |   MaxByteOffset maxByteOffsetLiteralInteger
    |   MaxByteOffsetId maxByteOffsetIdRef
    |   MaxConcurrencyINTEL invocations
    |   MaxPrivateCopiesINTEL maximumCopies
    |   MaxReplicatesINTEL maximumReplicates
    |   MediaBlockIOINTEL
    |   MemoryINTEL memoryType
    |   MergeINTEL mergeKey mergeType
    |   NoAliasINTEL aliasingScopesList
    |   NoContraction
    |   NoPerspective
    |   NoSignedWrap
    |   NoUnsignedWrap
    |   NodeMaxPayloadsAMDX maxNumberOfPayloads
    |   NodeSharesPayloadLimitsWithAMDX payloadArray
    |   NonReadable
    |   NonUniform
    |   NonUniformEXT
    |   NonWritable
    |   NumbanksINTEL banks
    |   Offset byteOffset
    |   OverrideCoverageNV
    |   PassthroughNV
    |   Patch
    |   PayloadNodeNameAMDX nodeName
    |   PerPrimitiveEXT
    |   PerPrimitiveNV
    |   PerTaskNV
    |   PerVertexKHR
    |   PerVertexNV
    |   PerViewNV
    |   PipelineEnableINTEL enable
    |   PrefetchINTEL prefetcherSizeInBytes
    |   ReferencedIndirectlyINTEL
    |   RegisterINTEL
    |   RegisterMapKernelArgumentINTEL
    |   RelaxedPrecision
    |   Restrict
    |   RestrictPointer
    |   RestrictPointerEXT
    |   RowMajor
    |   SIMTCallINTEL n
    |   Sample
    |   SaturatedConversion
    |   SecondaryViewportRelativeNV offsetLiteralInteger
    |   SideEffectsINTEL
    |   SimpleDualPortINTEL
    |   SingleElementVectorINTEL
    |   SinglepumpINTEL
    |   SpecId specializationConstantID
    |   StableKernelArgumentINTEL
    |   StackCallINTEL
    |   StallEnableINTEL
    |   StallFreeINTEL
    |   Stream streamNumber
    |   StridesizeINTEL strideSize
    |   TrackFinishWritingAMDX
    |   TrueDualPortINTEL
    |   Uniform
    |   UniformId execution
    |   UserSemantic semantic
    |   UserTypeGOOGLE userType
    |   VectorComputeCallableFunctionINTEL
    |   VectorComputeFunctionINTEL
    |   VectorComputeVariableINTEL
    |   ViewportRelativeNV
    |   Volatile
    |   WeightTextureQCOM
    |   WordsizeINTEL wordSize
    |   XfbBuffer xFBBufferNumber
    |   XfbStride xFBStride
    ;

dim
    :   Buffer
    |   Cube
    |   Def1D
    |   Def2D
    |   Def3D
    |   Rect
    |   SubpassData
    |   TileImageDataEXT
    ;

executionMode
    :   CoalescingAMDX
    |   ContractionOff
    |   DenormFlushToZero targetWidth
    |   DenormPreserve targetWidth
    |   DepthGreater
    |   DepthLess
    |   DepthReplacing
    |   DepthUnchanged
    |   DerivativeGroupLinearNV
    |   DerivativeGroupQuadsNV
    |   EarlyAndLateFragmentTestsAMD
    |   EarlyFragmentTests
    |   Finalizer
    |   FloatingPointModeALTINTEL targetWidth
    |   FloatingPointModeIEEEINTEL targetWidth
    |   Initializer
    |   InputLines
    |   InputLinesAdjacency
    |   InputPoints
    |   InputTrianglesAdjacency
    |   Invocations numberOf
    |   Isolines
    |   LocalSize xSizeLiteralInteger ySizeLiteralInteger zSizeLiteralInteger
    |   LocalSizeHint xSizeLiteralInteger ySizeLiteralInteger zSizeLiteralInteger
    |   LocalSizeHintId xSizeHint ySizeHint zSizeHint
    |   LocalSizeId xSizeIdRef ySizeIdRef zSizeIdRef
    |   MaxNodeRecursionAMDX numberOfRecursions
    |   MaxNumWorkgroupsAMDX xSizeIdRef ySizeIdRef zSizeIdRef
    |   MaxWorkDimINTEL max
    |   MaxWorkgroupSizeINTEL max max max
    |   NamedBarrierCountINTEL barrierCount
    |   NoGlobalOffsetINTEL
    |   NonCoherentColorAttachmentReadEXT
    |   NonCoherentDepthAttachmentReadEXT
    |   NonCoherentStencilAttachmentReadEXT
    |   NumSIMDWorkitemsINTEL vectorLiteralInteger
    |   OriginLowerLeft
    |   OriginUpperLeft
    |   OutputLineStrip
    |   OutputLinesEXT
    |   OutputLinesNV
    |   OutputPoints
    |   OutputPrimitivesEXT primitiveCountLiteralInteger
    |   OutputPrimitivesNV primitiveCountLiteralInteger
    |   OutputTriangleStrip
    |   OutputTrianglesEXT
    |   OutputTrianglesNV
    |   OutputVertices vertexCountLiteralInteger
    |   PixelCenterInteger
    |   PixelInterlockOrderedEXT
    |   PixelInterlockUnorderedEXT
    |   PointMode
    |   PostDepthCoverage
    |   Quads
    |   RegisterMapInterfaceINTEL waitForDoneWrite
    |   RoundingModeRTE targetWidth
    |   RoundingModeRTNINTEL targetWidth
    |   RoundingModeRTPINTEL targetWidth
    |   RoundingModeRTZ targetWidth
    |   SampleInterlockOrderedEXT
    |   SampleInterlockUnorderedEXT
    |   SchedulerTargetFmaxMhzINTEL targetLiteralInteger
    |   ShaderIndexAMDX shaderIndex
    |   ShadingRateInterlockOrderedEXT
    |   ShadingRateInterlockUnorderedEXT
    |   SharedLocalMemorySizeINTEL sizeLiteralInteger
    |   SignedZeroInfNanPreserve targetWidth
    |   SpacingEqual
    |   SpacingFractionalEven
    |   SpacingFractionalOdd
    |   StaticNumWorkgroupsAMDX xSizeIdRef ySizeIdRef zSizeIdRef
    |   StencilRefGreaterBackAMD
    |   StencilRefGreaterFrontAMD
    |   StencilRefLessBackAMD
    |   StencilRefLessFrontAMD
    |   StencilRefReplacingEXT
    |   StencilRefUnchangedBackAMD
    |   StencilRefUnchangedFrontAMD
    |   StreamingInterfaceINTEL stallFreeReturn
    |   SubgroupSize subgroupSize
    |   SubgroupUniformControlFlowKHR
    |   SubgroupsPerWorkgroup subgroupsPerWorkgroupLiteralInteger
    |   SubgroupsPerWorkgroupId subgroupsPerWorkgroupIdRef
    |   Triangles
    |   VecTypeHint vectorType
    |   VertexOrderCcw
    |   VertexOrderCw
    |   Xfb
    ;

executionModel
    :   AnyHitKHR
    |   AnyHitNV
    |   CallableKHR
    |   CallableNV
    |   ClosestHitKHR
    |   ClosestHitNV
    |   Fragment
    |   GLCompute
    |   Geometry
    |   IntersectionKHR
    |   IntersectionNV
    |   Kernel
    |   MeshEXT
    |   MeshNV
    |   MissKHR
    |   MissNV
    |   RayGenerationKHR
    |   RayGenerationNV
    |   TaskEXT
    |   TaskNV
    |   TessellationControl
    |   TessellationEvaluation
    |   Vertex
    ;

fPDenormMode
    :   FlushToZero
    |   Preserve
    ;

fPFastMathMode
    :   AllowContractFastINTEL
    |   AllowReassocINTEL
    |   AllowRecip
    |   Fast
    |   NSZ
    |   None
    |   NotInf
    |   NotNaN
    ;

fPOperationMode
    :   ALT
    |   IEEE
    ;

fPRoundingMode
    :   RTE
    |   RTN
    |   RTP
    |   RTZ
    ;

fragmentShadingRate
    :   Horizontal2Pixels
    |   Horizontal4Pixels
    |   Vertical2Pixels
    |   Vertical4Pixels
    ;

functionControl
    :   Const
    |   DontInline
    |   Inline
    |   None
    |   OptNoneINTEL
    |   Pure
    ;

functionParameterAttribute
    :   ByVal
    |   NoAlias
    |   NoCapture
    |   NoReadWrite
    |   NoWrite
    |   RuntimeAlignedINTEL
    |   Sext
    |   Sret
    |   Zext
    ;

groupOperation
    :   ClusteredReduce
    |   ExclusiveScan
    |   InclusiveScan
    |   PartitionedExclusiveScanNV
    |   PartitionedInclusiveScanNV
    |   PartitionedReduceNV
    |   Reduce
    ;

hostAccessQualifier
    :   NoneINTEL
    |   ReadINTEL
    |   ReadWriteINTEL
    |   WriteINTEL
    ;

imageChannelDataType
    :   Float
    |   HalfFloat
    |   SignedInt16
    |   SignedInt32
    |   SignedInt8
    |   SnormInt16
    |   SnormInt8
    |   UnormInt101010
    |   UnormInt101010_2
    |   UnormInt16
    |   UnormInt24
    |   UnormInt8
    |   UnormShort555
    |   UnormShort565
    |   UnsignedInt16
    |   UnsignedInt32
    |   UnsignedInt8
    |   UnsignedIntRaw10EXT
    |   UnsignedIntRaw12EXT
    ;

imageChannelOrder
    :   A
    |   ABGR
    |   ARGB
    |   BGRA
    |   Depth
    |   DepthStencil
    |   Intensity
    |   Luminance
    |   R
    |   RA
    |   RG
    |   RGB
    |   RGBA
    |   RGBx
    |   RGx
    |   Rx
    |   SBGRA
    |   SRGB
    |   SRGBA
    |   SRGBx
    ;

imageFormat
    :   R11fG11fB10f
    |   R16
    |   R16Snorm
    |   R16f
    |   R16i
    |   R16ui
    |   R32f
    |   R32i
    |   R32ui
    |   R64i
    |   R64ui
    |   R8
    |   R8Snorm
    |   R8i
    |   R8ui
    |   Rg16
    |   Rg16Snorm
    |   Rg16f
    |   Rg16i
    |   Rg16ui
    |   Rg32f
    |   Rg32i
    |   Rg32ui
    |   Rg8
    |   Rg8Snorm
    |   Rg8i
    |   Rg8ui
    |   Rgb10A2
    |   Rgb10a2ui
    |   Rgba16
    |   Rgba16Snorm
    |   Rgba16f
    |   Rgba16i
    |   Rgba16ui
    |   Rgba32f
    |   Rgba32i
    |   Rgba32ui
    |   Rgba8
    |   Rgba8Snorm
    |   Rgba8i
    |   Rgba8ui
    |   Unknown
    ;

imageOperands
    :   Bias idRef
    |   ConstOffset idRef
    |   ConstOffsets idRef
    |   Grad idRef idRef
    |   Lod idRef
    |   MakeTexelAvailable idScope
    |   MakeTexelAvailableKHR idScope
    |   MakeTexelVisible idScope
    |   MakeTexelVisibleKHR idScope
    |   MinLod idRef
    |   NonPrivateTexel
    |   NonPrivateTexelKHR
    |   None
    |   Nontemporal
    |   Offset idRef
    |   Offsets idRef
    |   Sample idRef
    |   SignExtend
    |   VolatileTexel
    |   VolatileTexelKHR
    |   ZeroExtend
    ;

initializationModeQualifier
    :   InitOnDeviceReprogramINTEL
    |   InitOnDeviceResetINTEL
    ;

kernelEnqueueFlags
    :   NoWait
    |   WaitKernel
    |   WaitWorkGroup
    ;

kernelProfilingInfo
    :   CmdExecTime
    |   None
    ;

linkageType
    :   Export
    |   Import
    |   LinkOnceODR
    ;

loadCacheControl
    :   CachedINTEL
    |   ConstCachedINTEL
    |   InvalidateAfterReadINTEL
    |   StreamingINTEL
    |   UncachedINTEL
    ;

loopControl
    :   DependencyArrayINTEL literalInteger
    |   DependencyInfinite
    |   DependencyLength literalInteger
    |   DontUnroll
    |   InitiationIntervalINTEL literalInteger
    |   IterationMultiple literalInteger
    |   LoopCoalesceINTEL literalInteger
    |   LoopCountINTEL literalInteger
    |   MaxConcurrencyINTEL literalInteger
    |   MaxInterleavingINTEL literalInteger
    |   MaxIterations literalInteger
    |   MaxReinvocationDelayINTEL literalInteger
    |   MinIterations literalInteger
    |   NoFusionINTEL
    |   None
    |   PartialCount literalInteger
    |   PeelCount literalInteger
    |   PipelineEnableINTEL literalInteger
    |   SpeculatedIterationsINTEL literalInteger
    |   Unroll
    ;

memoryAccess
    :   AliasScopeINTELMask idRef
    |   Aligned literalInteger
    |   MakePointerAvailable idScope
    |   MakePointerAvailableKHR idScope
    |   MakePointerVisible idScope
    |   MakePointerVisibleKHR idScope
    |   NoAliasINTELMask idRef
    |   NonPrivatePointer
    |   NonPrivatePointerKHR
    |   None
    |   Nontemporal
    |   Volatile
    ;

memoryModel
    :   GLSL450
    |   OpenCL
    |   Simple
    |   Vulkan
    |   VulkanKHR
    ;

memorySemantics
    :   Acquire
    |   AcquireRelease
    |   AtomicCounterMemory
    |   CrossWorkgroupMemory
    |   ImageMemory
    |   MakeAvailable
    |   MakeAvailableKHR
    |   MakeVisible
    |   MakeVisibleKHR
    |   None
    |   OutputMemory
    |   OutputMemoryKHR
    |   Relaxed
    |   Release
    |   SequentiallyConsistent
    |   SubgroupMemory
    |   UniformMemory
    |   Volatile
    |   WorkgroupMemory
    ;

overflowModes
    :   SAT
    |   SAT_SYM
    |   SAT_ZERO
    |   WRAP
    ;

packedVectorFormat
    :   PackedVectorFormat4x8Bit
    |   PackedVectorFormat4x8BitKHR
    ;

quantizationModes
    :   RND
    |   RND_CONV
    |   RND_CONV_ODD
    |   RND_INF
    |   RND_MIN_INF
    |   RND_ZERO
    |   TRN
    |   TRN_ZERO
    ;

rayFlags
    :   CullBackFacingTrianglesKHR
    |   CullFrontFacingTrianglesKHR
    |   CullNoOpaqueKHR
    |   CullOpaqueKHR
    |   ForceOpacityMicromap2StateEXT
    |   NoOpaqueKHR
    |   NoneKHR
    |   OpaqueKHR
    |   SkipAABBsKHR
    |   SkipClosestHitShaderKHR
    |   SkipTrianglesKHR
    |   TerminateOnFirstHitKHR
    ;

rayQueryCandidateIntersectionType
    :   RayQueryCandidateIntersectionAABBKHR
    |   RayQueryCandidateIntersectionTriangleKHR
    ;

rayQueryCommittedIntersectionType
    :   RayQueryCommittedIntersectionGeneratedKHR
    |   RayQueryCommittedIntersectionNoneKHR
    |   RayQueryCommittedIntersectionTriangleKHR
    ;

rayQueryIntersection
    :   RayQueryCandidateIntersectionKHR
    |   RayQueryCommittedIntersectionKHR
    ;

samplerAddressingMode
    :   Clamp
    |   ClampToEdge
    |   None
    |   Repeat
    |   RepeatMirrored
    ;

samplerFilterMode
    :   Linear
    |   Nearest
    ;

scope
    :   CrossDevice
    |   Device
    |   Invocation
    |   QueueFamily
    |   QueueFamilyKHR
    |   ShaderCallKHR
    |   Subgroup
    |   Workgroup
    ;

selectionControl
    :   DontFlatten
    |   Flatten
    |   None
    ;

sourceLanguage
    :   CPP_for_OpenCL
    |   ESSL
    |   GLSL
    |   HERO_C
    |   HLSL
    |   NZSL
    |   OpenCL_C
    |   OpenCL_CPP
    |   SYCL
    |   Slang
    |   Unknown
    |   WGSL
    ;

storageClass
    :   AtomicCounter
    |   CallableDataKHR
    |   CallableDataNV
    |   CodeSectionINTEL
    |   CrossWorkgroup
    |   DeviceOnlyINTEL
    |   Function
    |   Generic
    |   HitAttributeKHR
    |   HitAttributeNV
    |   HitObjectAttributeNV
    |   HostOnlyINTEL
    |   Image
    |   IncomingCallableDataKHR
    |   IncomingCallableDataNV
    |   IncomingRayPayloadKHR
    |   IncomingRayPayloadNV
    |   Input
    |   NodeOutputPayloadAMDX
    |   NodePayloadAMDX
    |   Output
    |   PhysicalStorageBuffer
    |   PhysicalStorageBufferEXT
    |   Private
    |   PushConstant
    |   RayPayloadKHR
    |   RayPayloadNV
    |   ShaderRecordBufferKHR
    |   ShaderRecordBufferNV
    |   StorageBuffer
    |   TaskPayloadWorkgroupEXT
    |   TileImageEXT
    |   Uniform
    |   UniformConstant
    |   Workgroup
    ;

storeCacheControl
    :   StreamingINTEL
    |   UncachedINTEL
    |   WriteBackINTEL
    |   WriteThroughINTEL
    ;

// Base types
pairIdRefIdRef : idRef idRef;
pairIdRefLiteralInteger : idRef literalInteger;
pairLiteralIntegerIdRef : literalInteger idRef;
literalContextDependentNumber : LiteralUnsignedInteger | LiteralInteger | LiteralFloat;
literalExtInstInteger : LiteralExtInstInteger;
literalFloat : LiteralFloat;
literalInteger : LiteralUnsignedInteger | LiteralInteger;
literalSpecConstantOpInteger : opWithRet;
literalString : LiteralString;
idMemorySemantics : Id;
idRef : Id;
idResult : Id;
idResultType : Id;
idScope : Id;
