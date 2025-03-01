grammar Spirv;

options { tokenVocab = SpirvLexer; }

spv : spvHeaders spvInstructions EOF;
spvInstructions : op*;

// Header
spvHeaders : spvHeader*;
spvHeader
    :   inputHeader
    |   outputHeader
    |   filterHeader
    |   configHeader
    ;

inputHeader : ModeHeader_Input ModeHeader_Colon initList;
outputHeader : ModeHeader_Output ModeHeader_Colon assertionList;
filterHeader : ModeHeader_Filter ModeHeader_Colon assertion;
configHeader : ModeHeader_Config ModeHeader_Colon literanHeaderUnsignedInteger ModeHeader_Comma literanHeaderUnsignedInteger ModeHeader_Comma literanHeaderUnsignedInteger;
initList : init (ModeHeader_Comma init)*;
init : varName ModeHeader_Equal initValue;
initValue
    :   initCollectionValue
    |   initBaseValue
    ;

initCollectionValue : ModeHeader_LBrace initValues ModeHeader_RBrace;
initValues : initValue (ModeHeader_Comma initValue)*;
assertionList
    :   ModeHeader_AssertionExists assertion ModeHeader_Comma?
    |   ModeHeader_AssertionNot ModeHeader_AssertionExists assertion ModeHeader_Comma?
    |   ModeHeader_AssertionForall assertion ModeHeader_Comma?
    ;

assertion
    :   ModeHeader_LPar assertion ModeHeader_RPar       # assertionParenthesis
    |   ModeHeader_AssertionNot assertion               # assertionNot
    |   assertion ModeHeader_AssertionAnd assertion     # assertionAnd
    |   assertion ModeHeader_AssertionOr assertion      # assertionOr
    |   assertionValue assertionCompare assertionValue  # assertionBasic
    ;

assertionCompare
    :   ModeHeader_EqualEqual
    |   ModeHeader_NotEqual
    |   ModeHeader_GreaterEqual
    |   ModeHeader_LessEqual
    |   ModeHeader_Less
    |   ModeHeader_Greater
    ;

assertionValue
    :   varName indexValue*
    |   initBaseValue
    ;

indexValue : ModeHeader_LBracket ModeHeader_PositiveInteger ModeHeader_RBracket;
varName : idResult;

// Operations
op
    :   opAbsISubINTEL
    |   opAbsUSubINTEL
    |   opAccessChain
    |   opAliasDomainDeclINTEL
    |   opAliasScopeDeclINTEL
    |   opAliasScopeListDeclINTEL
    |   opAll
    |   opAllocateNodePayloadsAMDX
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
    |   opArithmeticFenceEXT
    |   opArrayLength
    |   opAsmCallINTEL
    |   opAsmINTEL
    |   opAsmTargetINTEL
    |   opAssumeTrueKHR
    |   opAtomicAnd
    |   opAtomicCompareExchange
    |   opAtomicCompareExchangeWeak
    |   opAtomicExchange
    |   opAtomicFAddEXT
    |   opAtomicFMaxEXT
    |   opAtomicFMinEXT
    |   opAtomicFlagClear
    |   opAtomicFlagTestAndSet
    |   opAtomicIAdd
    |   opAtomicIDecrement
    |   opAtomicIIncrement
    |   opAtomicISub
    |   opAtomicLoad
    |   opAtomicOr
    |   opAtomicSMax
    |   opAtomicSMin
    |   opAtomicStore
    |   opAtomicUMax
    |   opAtomicUMin
    |   opAtomicXor
    |   opBeginInvocationInterlockEXT
    |   opBitCount
    |   opBitFieldInsert
    |   opBitFieldSExtract
    |   opBitFieldUExtract
    |   opBitReverse
    |   opBitcast
    |   opBitwiseAnd
    |   opBitwiseOr
    |   opBitwiseXor
    |   opBranch
    |   opBranchConditional
    |   opBuildNDRange
    |   opCapability
    |   opCaptureEventProfilingInfo
    |   opColorAttachmentReadEXT
    |   opCommitReadPipe
    |   opCommitWritePipe
    |   opCompositeConstruct
    |   opCompositeConstructContinuedINTEL
    |   opCompositeConstructReplicateEXT
    |   opCompositeExtract
    |   opCompositeInsert
    |   opConstant
    |   opConstantComposite
    |   opConstantCompositeContinuedINTEL
    |   opConstantCompositeReplicateEXT
    |   opConstantFalse
    |   opConstantFunctionPointerINTEL
    |   opConstantNull
    |   opConstantPipeStorage
    |   opConstantSampler
    |   opConstantStringAMDX
    |   opConstantTrue
    |   opControlBarrier
    |   opControlBarrierArriveINTEL
    |   opControlBarrierWaitINTEL
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
    |   opCooperativeMatrixConvertNV
    |   opCooperativeMatrixLengthKHR
    |   opCooperativeMatrixLengthNV
    |   opCooperativeMatrixLoadKHR
    |   opCooperativeMatrixLoadNV
    |   opCooperativeMatrixLoadTensorNV
    |   opCooperativeMatrixMulAddKHR
    |   opCooperativeMatrixMulAddNV
    |   opCooperativeMatrixPerElementOpNV
    |   opCooperativeMatrixReduceNV
    |   opCooperativeMatrixStoreKHR
    |   opCooperativeMatrixStoreNV
    |   opCooperativeMatrixStoreTensorNV
    |   opCooperativeMatrixTransposeNV
    |   opCooperativeVectorLoadNV
    |   opCooperativeVectorMatrixMulAddNV
    |   opCooperativeVectorMatrixMulNV
    |   opCooperativeVectorOuterProductAccumulateNV
    |   opCooperativeVectorReduceSumAccumulateNV
    |   opCooperativeVectorStoreNV
    |   opCopyLogical
    |   opCopyMemory
    |   opCopyMemorySized
    |   opCopyObject
    |   opCreatePipeFromPipeStorage
    |   opCreateTensorLayoutNV
    |   opCreateTensorViewNV
    |   opCreateUserEvent
    |   opCrossWorkgroupCastToPtrINTEL
    |   opDPdx
    |   opDPdxCoarse
    |   opDPdxFine
    |   opDPdy
    |   opDPdyCoarse
    |   opDPdyFine
    |   opDecorate
    |   opDecorateId
    |   opDecorateString
    |   opDecorationGroup
    |   opDemoteToHelperInvocation
    |   opDepthAttachmentReadEXT
    |   opDot
    |   opEmitMeshTasksEXT
    |   opEmitStreamVertex
    |   opEmitVertex
    |   opEndInvocationInterlockEXT
    |   opEndPrimitive
    |   opEndStreamPrimitive
    |   opEnqueueKernel
    |   opEnqueueMarker
    |   opEnqueueNodePayloadsAMDX
    |   opEntryPoint
    |   opExecuteCallableKHR
    |   opExecuteCallableNV
    |   opExecutionMode
    |   opExecutionModeId
    |   opExpectKHR
    |   opExtInst
    |   opExtInstImport
    |   opExtension
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
    |   opFunctionEnd
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
    |   opGroupCommitReadPipe
    |   opGroupCommitWritePipe
    |   opGroupDecorate
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
    |   opGroupMemberDecorate
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
    |   opGroupNonUniformQuadAllKHR
    |   opGroupNonUniformQuadAnyKHR
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
    |   opGroupWaitEvents
    |   opHitObjectExecuteShaderNV
    |   opHitObjectGetAttributesNV
    |   opHitObjectGetClusterIdNV
    |   opHitObjectGetCurrentTimeNV
    |   opHitObjectGetGeometryIndexNV
    |   opHitObjectGetHitKindNV
    |   opHitObjectGetInstanceCustomIndexNV
    |   opHitObjectGetInstanceIdNV
    |   opHitObjectGetLSSPositionsNV
    |   opHitObjectGetLSSRadiiNV
    |   opHitObjectGetObjectRayDirectionNV
    |   opHitObjectGetObjectRayOriginNV
    |   opHitObjectGetObjectToWorldNV
    |   opHitObjectGetPrimitiveIndexNV
    |   opHitObjectGetRayTMaxNV
    |   opHitObjectGetRayTMinNV
    |   opHitObjectGetShaderBindingTableRecordIndexNV
    |   opHitObjectGetShaderRecordBufferHandleNV
    |   opHitObjectGetSpherePositionNV
    |   opHitObjectGetSphereRadiusNV
    |   opHitObjectGetWorldRayDirectionNV
    |   opHitObjectGetWorldRayOriginNV
    |   opHitObjectGetWorldToObjectNV
    |   opHitObjectIsEmptyNV
    |   opHitObjectIsHitNV
    |   opHitObjectIsLSSHitNV
    |   opHitObjectIsMissNV
    |   opHitObjectIsSphereHitNV
    |   opHitObjectRecordEmptyNV
    |   opHitObjectRecordHitMotionNV
    |   opHitObjectRecordHitNV
    |   opHitObjectRecordHitWithIndexMotionNV
    |   opHitObjectRecordHitWithIndexNV
    |   opHitObjectRecordMissMotionNV
    |   opHitObjectRecordMissNV
    |   opHitObjectTraceRayMotionNV
    |   opHitObjectTraceRayNV
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
    |   opIgnoreIntersectionKHR
    |   opIgnoreIntersectionNV
    |   opImage
    |   opImageBlockMatchGatherSADQCOM
    |   opImageBlockMatchGatherSSDQCOM
    |   opImageBlockMatchSADQCOM
    |   opImageBlockMatchSSDQCOM
    |   opImageBlockMatchWindowSADQCOM
    |   opImageBlockMatchWindowSSDQCOM
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
    |   opImageWrite
    |   opInBoundsAccessChain
    |   opInBoundsPtrAccessChain
    |   opIsFinite
    |   opIsHelperInvocationEXT
    |   opIsInf
    |   opIsNan
    |   opIsNodePayloadValidAMDX
    |   opIsNormal
    |   opIsValidEvent
    |   opIsValidReserveId
    |   opKill
    |   opLabel
    |   opLessOrGreater
    |   opLifetimeStart
    |   opLifetimeStop
    |   opLine
    |   opLoad
    |   opLogicalAnd
    |   opLogicalEqual
    |   opLogicalNot
    |   opLogicalNotEqual
    |   opLogicalOr
    |   opLoopControlINTEL
    |   opLoopMerge
    |   opMaskedGatherINTEL
    |   opMaskedScatterINTEL
    |   opMatrixTimesMatrix
    |   opMatrixTimesScalar
    |   opMatrixTimesVector
    |   opMemberDecorate
    |   opMemberDecorateString
    |   opMemberName
    |   opMemoryBarrier
    |   opMemoryModel
    |   opMemoryNamedBarrier
    |   opModuleProcessed
    |   opName
    |   opNamedBarrierInitialize
    |   opNoLine
    |   opNodePayloadArrayLengthAMDX
    |   opNop
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
    |   opRawAccessChainNV
    |   opRayQueryConfirmIntersectionKHR
    |   opRayQueryGenerateIntersectionKHR
    |   opRayQueryGetClusterIdNV
    |   opRayQueryGetIntersectionBarycentricsKHR
    |   opRayQueryGetIntersectionCandidateAABBOpaqueKHR
    |   opRayQueryGetIntersectionFrontFaceKHR
    |   opRayQueryGetIntersectionGeometryIndexKHR
    |   opRayQueryGetIntersectionInstanceCustomIndexKHR
    |   opRayQueryGetIntersectionInstanceIdKHR
    |   opRayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR
    |   opRayQueryGetIntersectionLSSHitValueNV
    |   opRayQueryGetIntersectionLSSPositionsNV
    |   opRayQueryGetIntersectionLSSRadiiNV
    |   opRayQueryGetIntersectionObjectRayDirectionKHR
    |   opRayQueryGetIntersectionObjectRayOriginKHR
    |   opRayQueryGetIntersectionObjectToWorldKHR
    |   opRayQueryGetIntersectionPrimitiveIndexKHR
    |   opRayQueryGetIntersectionSpherePositionNV
    |   opRayQueryGetIntersectionSphereRadiusNV
    |   opRayQueryGetIntersectionTKHR
    |   opRayQueryGetIntersectionTriangleVertexPositionsKHR
    |   opRayQueryGetIntersectionTypeKHR
    |   opRayQueryGetIntersectionWorldToObjectKHR
    |   opRayQueryGetRayFlagsKHR
    |   opRayQueryGetRayTMinKHR
    |   opRayQueryGetWorldRayDirectionKHR
    |   opRayQueryGetWorldRayOriginKHR
    |   opRayQueryInitializeKHR
    |   opRayQueryIsLSSHitNV
    |   opRayQueryIsSphereHitNV
    |   opRayQueryProceedKHR
    |   opRayQueryTerminateKHR
    |   opReadClockKHR
    |   opReadPipe
    |   opReadPipeBlockingINTEL
    |   opReleaseEvent
    |   opReorderThreadWithHintNV
    |   opReorderThreadWithHitObjectNV
    |   opReportIntersectionKHR
    |   opReserveReadPipePackets
    |   opReserveWritePipePackets
    |   opReservedReadPipe
    |   opReservedWritePipe
    |   opRestoreMemoryINTEL
    |   opRetainEvent
    |   opReturn
    |   opReturnValue
    |   opSConvert
    |   opSDiv
    |   opSDot
    |   opSDotAccSat
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
    |   opSampledImage
    |   opSamplerImageAddressingModeNV
    |   opSatConvertSToU
    |   opSatConvertUToS
    |   opSaveMemoryINTEL
    |   opSelect
    |   opSelectionMerge
    |   opSetMeshOutputsEXT
    |   opSetUserEventStatus
    |   opShiftLeftLogical
    |   opShiftRightArithmetic
    |   opShiftRightLogical
    |   opSignBitSet
    |   opSizeOf
    |   opSource
    |   opSourceContinued
    |   opSourceExtension
    |   opSpecConstant
    |   opSpecConstantComposite
    |   opSpecConstantCompositeContinuedINTEL
    |   opSpecConstantCompositeReplicateEXT
    |   opSpecConstantFalse
    |   opSpecConstantStringAMDX
    |   opSpecConstantTrue
    |   opStencilAttachmentReadEXT
    |   opStore
    |   opString
    |   opSubgroup2DBlockLoadINTEL
    |   opSubgroup2DBlockLoadTransformINTEL
    |   opSubgroup2DBlockLoadTransposeINTEL
    |   opSubgroup2DBlockPrefetchINTEL
    |   opSubgroup2DBlockStoreINTEL
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
    |   opSubgroupBlockPrefetchINTEL
    |   opSubgroupBlockReadINTEL
    |   opSubgroupBlockWriteINTEL
    |   opSubgroupFirstInvocationKHR
    |   opSubgroupImageBlockReadINTEL
    |   opSubgroupImageBlockWriteINTEL
    |   opSubgroupImageMediaBlockReadINTEL
    |   opSubgroupImageMediaBlockWriteINTEL
    |   opSubgroupMatrixMultiplyAccumulateINTEL
    |   opSubgroupReadInvocationKHR
    |   opSubgroupShuffleDownINTEL
    |   opSubgroupShuffleINTEL
    |   opSubgroupShuffleUpINTEL
    |   opSubgroupShuffleXorINTEL
    |   opSwitch
    |   opTensorLayoutSetBlockSizeNV
    |   opTensorLayoutSetClampValueNV
    |   opTensorLayoutSetDimensionNV
    |   opTensorLayoutSetStrideNV
    |   opTensorLayoutSliceNV
    |   opTensorViewSetClipNV
    |   opTensorViewSetDimensionNV
    |   opTensorViewSetStrideNV
    |   opTerminateInvocation
    |   opTerminateRayKHR
    |   opTerminateRayNV
    |   opTraceMotionNV
    |   opTraceNV
    |   opTraceRayKHR
    |   opTraceRayMotionNV
    |   opTranspose
    |   opTypeAccelerationStructureKHR
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
    |   opTypeCooperativeVectorNV
    |   opTypeDeviceEvent
    |   opTypeEvent
    |   opTypeFloat
    |   opTypeForwardPointer
    |   opTypeFunction
    |   opTypeHitObjectNV
    |   opTypeImage
    |   opTypeInt
    |   opTypeMatrix
    |   opTypeNamedBarrier
    |   opTypeNodePayloadArrayAMDX
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
    |   opTypeStructContinuedINTEL
    |   opTypeTensorLayoutNV
    |   opTypeTensorViewNV
    |   opTypeUntypedPointerKHR
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
    |   opUnreachable
    |   opUntypedAccessChainKHR
    |   opUntypedArrayLengthKHR
    |   opUntypedInBoundsAccessChainKHR
    |   opUntypedInBoundsPtrAccessChainKHR
    |   opUntypedPrefetchKHR
    |   opUntypedPtrAccessChainKHR
    |   opUntypedVariableKHR
    |   opVariable
    |   opVariableLengthArrayINTEL
    |   opVectorExtractDynamic
    |   opVectorInsertDynamic
    |   opVectorShuffle
    |   opVectorTimesMatrix
    |   opVectorTimesScalar
    |   opVmeImageINTEL
    |   opWritePackedPrimitiveIndices4x8NV
    |   opWritePipe
    |   opWritePipeBlockingINTEL
    ;

// Annotation Operations
opDecorate : Op Decorate targetIdRef decoration;
opMemberDecorate : Op MemberDecorate structureType member decoration;
opDecorationGroup : idResult Equals Op (DecorationGroup  | SpecConstantOp  DecorationGroup);
opGroupDecorate : Op GroupDecorate decorationGroup targetsIdRef*;
opGroupMemberDecorate : Op GroupMemberDecorate decorationGroup targetsPairIdRefLiteralInteger*;
opDecorateId : Op DecorateId targetIdRef decoration;
opDecorateString : Op DecorateString targetIdRef decoration;
opMemberDecorateString : Op MemberDecorateString structType member decoration;

// Arithmetic Operations
opSNegate : idResult Equals Op (SNegate idResultType | SpecConstantOp idResultType SNegate) operand;
opFNegate : idResult Equals Op (FNegate idResultType | SpecConstantOp idResultType FNegate) operand;
opIAdd : idResult Equals Op (IAdd idResultType | SpecConstantOp idResultType IAdd) operand1 operand2;
opFAdd : idResult Equals Op (FAdd idResultType | SpecConstantOp idResultType FAdd) operand1 operand2;
opISub : idResult Equals Op (ISub idResultType | SpecConstantOp idResultType ISub) operand1 operand2;
opFSub : idResult Equals Op (FSub idResultType | SpecConstantOp idResultType FSub) operand1 operand2;
opIMul : idResult Equals Op (IMul idResultType | SpecConstantOp idResultType IMul) operand1 operand2;
opFMul : idResult Equals Op (FMul idResultType | SpecConstantOp idResultType FMul) operand1 operand2;
opUDiv : idResult Equals Op (UDiv idResultType | SpecConstantOp idResultType UDiv) operand1 operand2;
opSDiv : idResult Equals Op (SDiv idResultType | SpecConstantOp idResultType SDiv) operand1 operand2;
opFDiv : idResult Equals Op (FDiv idResultType | SpecConstantOp idResultType FDiv) operand1 operand2;
opUMod : idResult Equals Op (UMod idResultType | SpecConstantOp idResultType UMod) operand1 operand2;
opSRem : idResult Equals Op (SRem idResultType | SpecConstantOp idResultType SRem) operand1 operand2;
opSMod : idResult Equals Op (SMod idResultType | SpecConstantOp idResultType SMod) operand1 operand2;
opFRem : idResult Equals Op (FRem idResultType | SpecConstantOp idResultType FRem) operand1 operand2;
opFMod : idResult Equals Op (FMod idResultType | SpecConstantOp idResultType FMod) operand1 operand2;
opVectorTimesScalar : idResult Equals Op (VectorTimesScalar idResultType | SpecConstantOp idResultType VectorTimesScalar) vectorIdRef scalar;
opMatrixTimesScalar : idResult Equals Op (MatrixTimesScalar idResultType | SpecConstantOp idResultType MatrixTimesScalar) matrix scalar;
opVectorTimesMatrix : idResult Equals Op (VectorTimesMatrix idResultType | SpecConstantOp idResultType VectorTimesMatrix) vectorIdRef matrix;
opMatrixTimesVector : idResult Equals Op (MatrixTimesVector idResultType | SpecConstantOp idResultType MatrixTimesVector) matrix vectorIdRef;
opMatrixTimesMatrix : idResult Equals Op (MatrixTimesMatrix idResultType | SpecConstantOp idResultType MatrixTimesMatrix) leftMatrix rightMatrix;
opOuterProduct : idResult Equals Op (OuterProduct idResultType | SpecConstantOp idResultType OuterProduct) vector1 vector2;
opDot : idResult Equals Op (Dot idResultType | SpecConstantOp idResultType Dot) vector1 vector2;
opIAddCarry : idResult Equals Op (IAddCarry idResultType | SpecConstantOp idResultType IAddCarry) operand1 operand2;
opISubBorrow : idResult Equals Op (ISubBorrow idResultType | SpecConstantOp idResultType ISubBorrow) operand1 operand2;
opUMulExtended : idResult Equals Op (UMulExtended idResultType | SpecConstantOp idResultType UMulExtended) operand1 operand2;
opSMulExtended : idResult Equals Op (SMulExtended idResultType | SpecConstantOp idResultType SMulExtended) operand1 operand2;
opSDot : idResult Equals Op (SDot idResultType | SpecConstantOp idResultType SDot) vector1 vector2 packedVectorFormat?;
opUDot : idResult Equals Op (UDot idResultType | SpecConstantOp idResultType UDot) vector1 vector2 packedVectorFormat?;
opSUDot : idResult Equals Op (SUDot idResultType | SpecConstantOp idResultType SUDot) vector1 vector2 packedVectorFormat?;
opSDotAccSat : idResult Equals Op (SDotAccSat idResultType | SpecConstantOp idResultType SDotAccSat) vector1 vector2 accumulator packedVectorFormat?;
opUDotAccSat : idResult Equals Op (UDotAccSat idResultType | SpecConstantOp idResultType UDotAccSat) vector1 vector2 accumulator packedVectorFormat?;
opSUDotAccSat : idResult Equals Op (SUDotAccSat idResultType | SpecConstantOp idResultType SUDotAccSat) vector1 vector2 accumulator packedVectorFormat?;
opCooperativeMatrixMulAddKHR : idResult Equals Op (CooperativeMatrixMulAddKHR idResultType | SpecConstantOp idResultType CooperativeMatrixMulAddKHR) a b c cooperativeMatrixOperands?;
opCooperativeMatrixReduceNV : idResult Equals Op (CooperativeMatrixReduceNV idResultType | SpecConstantOp idResultType CooperativeMatrixReduceNV) matrix reduce combineFunc;

// Atomic Operations
opAtomicLoad : idResult Equals Op (AtomicLoad idResultType | SpecConstantOp idResultType AtomicLoad) pointer memory semantics;
opAtomicStore : Op AtomicStore pointer memory semantics valueIdRef;
opAtomicExchange : idResult Equals Op (AtomicExchange idResultType | SpecConstantOp idResultType AtomicExchange) pointer memory semantics valueIdRef;
opAtomicCompareExchange : idResult Equals Op (AtomicCompareExchange idResultType | SpecConstantOp idResultType AtomicCompareExchange) pointer memory equal unequal valueIdRef comparator;
opAtomicCompareExchangeWeak : idResult Equals Op (AtomicCompareExchangeWeak idResultType | SpecConstantOp idResultType AtomicCompareExchangeWeak) pointer memory equal unequal valueIdRef comparator;
opAtomicIIncrement : idResult Equals Op (AtomicIIncrement idResultType | SpecConstantOp idResultType AtomicIIncrement) pointer memory semantics;
opAtomicIDecrement : idResult Equals Op (AtomicIDecrement idResultType | SpecConstantOp idResultType AtomicIDecrement) pointer memory semantics;
opAtomicIAdd : idResult Equals Op (AtomicIAdd idResultType | SpecConstantOp idResultType AtomicIAdd) pointer memory semantics valueIdRef;
opAtomicISub : idResult Equals Op (AtomicISub idResultType | SpecConstantOp idResultType AtomicISub) pointer memory semantics valueIdRef;
opAtomicSMin : idResult Equals Op (AtomicSMin idResultType | SpecConstantOp idResultType AtomicSMin) pointer memory semantics valueIdRef;
opAtomicUMin : idResult Equals Op (AtomicUMin idResultType | SpecConstantOp idResultType AtomicUMin) pointer memory semantics valueIdRef;
opAtomicSMax : idResult Equals Op (AtomicSMax idResultType | SpecConstantOp idResultType AtomicSMax) pointer memory semantics valueIdRef;
opAtomicUMax : idResult Equals Op (AtomicUMax idResultType | SpecConstantOp idResultType AtomicUMax) pointer memory semantics valueIdRef;
opAtomicAnd : idResult Equals Op (AtomicAnd idResultType | SpecConstantOp idResultType AtomicAnd) pointer memory semantics valueIdRef;
opAtomicOr : idResult Equals Op (AtomicOr idResultType | SpecConstantOp idResultType AtomicOr) pointer memory semantics valueIdRef;
opAtomicXor : idResult Equals Op (AtomicXor idResultType | SpecConstantOp idResultType AtomicXor) pointer memory semantics valueIdRef;
opAtomicFlagTestAndSet : idResult Equals Op (AtomicFlagTestAndSet idResultType | SpecConstantOp idResultType AtomicFlagTestAndSet) pointer memory semantics;
opAtomicFlagClear : Op AtomicFlagClear pointer memory semantics;
opAtomicFMinEXT : idResult Equals Op (AtomicFMinEXT idResultType | SpecConstantOp idResultType AtomicFMinEXT) pointer memory semantics valueIdRef;
opAtomicFMaxEXT : idResult Equals Op (AtomicFMaxEXT idResultType | SpecConstantOp idResultType AtomicFMaxEXT) pointer memory semantics valueIdRef;
opAtomicFAddEXT : idResult Equals Op (AtomicFAddEXT idResultType | SpecConstantOp idResultType AtomicFAddEXT) pointer memory semantics valueIdRef;

// Barrier Operations
opControlBarrier : Op ControlBarrier execution memory semantics;
opMemoryBarrier : Op MemoryBarrier memory semantics;
opNamedBarrierInitialize : idResult Equals Op (NamedBarrierInitialize idResultType | SpecConstantOp idResultType NamedBarrierInitialize) subgroupCount;
opMemoryNamedBarrier : Op MemoryNamedBarrier namedBarrier memory semantics;
opControlBarrierArriveINTEL : Op ControlBarrierArriveINTEL execution memory semantics;
opControlBarrierWaitINTEL : Op ControlBarrierWaitINTEL execution memory semantics;

// Bit Operations
opShiftRightLogical : idResult Equals Op (ShiftRightLogical idResultType | SpecConstantOp idResultType ShiftRightLogical) base shift;
opShiftRightArithmetic : idResult Equals Op (ShiftRightArithmetic idResultType | SpecConstantOp idResultType ShiftRightArithmetic) base shift;
opShiftLeftLogical : idResult Equals Op (ShiftLeftLogical idResultType | SpecConstantOp idResultType ShiftLeftLogical) base shift;
opBitwiseOr : idResult Equals Op (BitwiseOr idResultType | SpecConstantOp idResultType BitwiseOr) operand1 operand2;
opBitwiseXor : idResult Equals Op (BitwiseXor idResultType | SpecConstantOp idResultType BitwiseXor) operand1 operand2;
opBitwiseAnd : idResult Equals Op (BitwiseAnd idResultType | SpecConstantOp idResultType BitwiseAnd) operand1 operand2;
opNot : idResult Equals Op (Not idResultType | SpecConstantOp idResultType Not) operand;
opBitFieldInsert : idResult Equals Op (BitFieldInsert idResultType | SpecConstantOp idResultType BitFieldInsert) base insert offsetIdRef count;
opBitFieldSExtract : idResult Equals Op (BitFieldSExtract idResultType | SpecConstantOp idResultType BitFieldSExtract) base offsetIdRef count;
opBitFieldUExtract : idResult Equals Op (BitFieldUExtract idResultType | SpecConstantOp idResultType BitFieldUExtract) base offsetIdRef count;
opBitReverse : idResult Equals Op (BitReverse idResultType | SpecConstantOp idResultType BitReverse) base;
opBitCount : idResult Equals Op (BitCount idResultType | SpecConstantOp idResultType BitCount) base;

// Composite Operations
opVectorExtractDynamic : idResult Equals Op (VectorExtractDynamic idResultType | SpecConstantOp idResultType VectorExtractDynamic) vectorIdRef indexIdRef;
opVectorInsertDynamic : idResult Equals Op (VectorInsertDynamic idResultType | SpecConstantOp idResultType VectorInsertDynamic) vectorIdRef componentIdRef indexIdRef;
opVectorShuffle : idResult Equals Op (VectorShuffle idResultType | SpecConstantOp idResultType VectorShuffle) vector1 vector2 components*;
opCompositeConstruct : idResult Equals Op (CompositeConstruct idResultType | SpecConstantOp idResultType CompositeConstruct) constituents*;
opCompositeExtract : idResult Equals Op (CompositeExtract idResultType | SpecConstantOp idResultType CompositeExtract) composite indexesLiteralInteger*;
opCompositeInsert : idResult Equals Op (CompositeInsert idResultType | SpecConstantOp idResultType CompositeInsert) object composite indexesLiteralInteger*;
opCopyObject : idResult Equals Op (CopyObject idResultType | SpecConstantOp idResultType CopyObject) operand;
opTranspose : idResult Equals Op (Transpose idResultType | SpecConstantOp idResultType Transpose) matrix;
opCopyLogical : idResult Equals Op (CopyLogical idResultType | SpecConstantOp idResultType CopyLogical) operand;
opCompositeConstructReplicateEXT : idResult Equals Op (CompositeConstructReplicateEXT idResultType | SpecConstantOp idResultType CompositeConstructReplicateEXT) valueIdRef;
opCompositeConstructContinuedINTEL : idResult Equals Op (CompositeConstructContinuedINTEL idResultType | SpecConstantOp idResultType CompositeConstructContinuedINTEL) constituents*;

// Constant-Creation Operations
opConstantTrue : idResult Equals Op (ConstantTrue idResultType | SpecConstantOp idResultType ConstantTrue);
opConstantFalse : idResult Equals Op (ConstantFalse idResultType | SpecConstantOp idResultType ConstantFalse);
opConstant : idResult Equals Op (Constant idResultType | SpecConstantOp idResultType Constant) valueLiteralContextDependentNumber;
opConstantComposite : idResult Equals Op (ConstantComposite idResultType | SpecConstantOp idResultType ConstantComposite) constituents*;
opConstantSampler : idResult Equals Op (ConstantSampler idResultType | SpecConstantOp idResultType ConstantSampler) samplerAddressingMode paramLiteralInteger samplerFilterMode;
opConstantNull : idResult Equals Op (ConstantNull idResultType | SpecConstantOp idResultType ConstantNull);
opSpecConstantTrue : idResult Equals Op (SpecConstantTrue idResultType | SpecConstantOp idResultType SpecConstantTrue);
opSpecConstantFalse : idResult Equals Op (SpecConstantFalse idResultType | SpecConstantOp idResultType SpecConstantFalse);
opSpecConstant : idResult Equals Op (SpecConstant idResultType | SpecConstantOp idResultType SpecConstant) valueLiteralContextDependentNumber;
opSpecConstantComposite : idResult Equals Op (SpecConstantComposite idResultType | SpecConstantOp idResultType SpecConstantComposite) constituents*;
opConstantCompositeReplicateEXT : idResult Equals Op (ConstantCompositeReplicateEXT idResultType | SpecConstantOp idResultType ConstantCompositeReplicateEXT) valueIdRef;
opSpecConstantCompositeReplicateEXT : idResult Equals Op (SpecConstantCompositeReplicateEXT idResultType | SpecConstantOp idResultType SpecConstantCompositeReplicateEXT) valueIdRef;
opConstantCompositeContinuedINTEL : Op ConstantCompositeContinuedINTEL constituents*;
opSpecConstantCompositeContinuedINTEL : Op SpecConstantCompositeContinuedINTEL constituents*;

// Control-Flow Operations
opPhi : idResult Equals Op (Phi idResultType | SpecConstantOp idResultType Phi) variable*;
opLoopMerge : Op LoopMerge mergeBlock continueTarget loopControl;
opSelectionMerge : Op SelectionMerge mergeBlock selectionControl;
opLabel : idResult Equals Op (Label  | SpecConstantOp  Label);
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

// Conversion Operations
opConvertFToU : idResult Equals Op (ConvertFToU idResultType | SpecConstantOp idResultType ConvertFToU) floatValue;
opConvertFToS : idResult Equals Op (ConvertFToS idResultType | SpecConstantOp idResultType ConvertFToS) floatValue;
opConvertSToF : idResult Equals Op (ConvertSToF idResultType | SpecConstantOp idResultType ConvertSToF) signedValue;
opConvertUToF : idResult Equals Op (ConvertUToF idResultType | SpecConstantOp idResultType ConvertUToF) unsignedValue;
opUConvert : idResult Equals Op (UConvert idResultType | SpecConstantOp idResultType UConvert) unsignedValue;
opSConvert : idResult Equals Op (SConvert idResultType | SpecConstantOp idResultType SConvert) signedValue;
opFConvert : idResult Equals Op (FConvert idResultType | SpecConstantOp idResultType FConvert) floatValue;
opQuantizeToF16 : idResult Equals Op (QuantizeToF16 idResultType | SpecConstantOp idResultType QuantizeToF16) valueIdRef;
opConvertPtrToU : idResult Equals Op (ConvertPtrToU idResultType | SpecConstantOp idResultType ConvertPtrToU) pointer;
opSatConvertSToU : idResult Equals Op (SatConvertSToU idResultType | SpecConstantOp idResultType SatConvertSToU) signedValue;
opSatConvertUToS : idResult Equals Op (SatConvertUToS idResultType | SpecConstantOp idResultType SatConvertUToS) unsignedValue;
opConvertUToPtr : idResult Equals Op (ConvertUToPtr idResultType | SpecConstantOp idResultType ConvertUToPtr) integerValue;
opPtrCastToGeneric : idResult Equals Op (PtrCastToGeneric idResultType | SpecConstantOp idResultType PtrCastToGeneric) pointer;
opGenericCastToPtr : idResult Equals Op (GenericCastToPtr idResultType | SpecConstantOp idResultType GenericCastToPtr) pointer;
opGenericCastToPtrExplicit : idResult Equals Op (GenericCastToPtrExplicit idResultType | SpecConstantOp idResultType GenericCastToPtrExplicit) pointer storage;
opBitcast : idResult Equals Op (Bitcast idResultType | SpecConstantOp idResultType Bitcast) operand;
opCooperativeMatrixConvertNV : idResult Equals Op (CooperativeMatrixConvertNV idResultType | SpecConstantOp idResultType CooperativeMatrixConvertNV) matrix;
opCooperativeMatrixTransposeNV : idResult Equals Op (CooperativeMatrixTransposeNV idResultType | SpecConstantOp idResultType CooperativeMatrixTransposeNV) matrix;
opConvertFToBF16INTEL : idResult Equals Op (ConvertFToBF16INTEL idResultType | SpecConstantOp idResultType ConvertFToBF16INTEL) floatValue;
opConvertBF16ToFINTEL : idResult Equals Op (ConvertBF16ToFINTEL idResultType | SpecConstantOp idResultType ConvertBF16ToFINTEL) bFloat16Value;

// Debug Operations
opSourceContinued : Op SourceContinued continuedSource;
opSource : Op Source sourceLanguage version file? sourceLiteralString?;
opSourceExtension : Op SourceExtension extension;
opName : Op Name targetIdRef nameLiteralString;
opMemberName : Op MemberName type member nameLiteralString;
opString : idResult Equals Op (String  | SpecConstantOp  String) string;
opLine : Op Line file line column;
opNoLine : Op NoLine;
opModuleProcessed : Op ModuleProcessed process;

// Derivative Operations
opDPdx : idResult Equals Op (DPdx idResultType | SpecConstantOp idResultType DPdx) p;
opDPdy : idResult Equals Op (DPdy idResultType | SpecConstantOp idResultType DPdy) p;
opFwidth : idResult Equals Op (Fwidth idResultType | SpecConstantOp idResultType Fwidth) p;
opDPdxFine : idResult Equals Op (DPdxFine idResultType | SpecConstantOp idResultType DPdxFine) p;
opDPdyFine : idResult Equals Op (DPdyFine idResultType | SpecConstantOp idResultType DPdyFine) p;
opFwidthFine : idResult Equals Op (FwidthFine idResultType | SpecConstantOp idResultType FwidthFine) p;
opDPdxCoarse : idResult Equals Op (DPdxCoarse idResultType | SpecConstantOp idResultType DPdxCoarse) p;
opDPdyCoarse : idResult Equals Op (DPdyCoarse idResultType | SpecConstantOp idResultType DPdyCoarse) p;
opFwidthCoarse : idResult Equals Op (FwidthCoarse idResultType | SpecConstantOp idResultType FwidthCoarse) p;

// Device-Side_Enqueue Operations
opEnqueueMarker : idResult Equals Op (EnqueueMarker idResultType | SpecConstantOp idResultType EnqueueMarker) queue numEvents waitEvents retEvent;
opEnqueueKernel : idResult Equals Op (EnqueueKernel idResultType | SpecConstantOp idResultType EnqueueKernel) queue flags nDRange numEvents waitEvents retEvent invoke paramIdRef paramSize paramAlign localSize*;
opGetKernelNDrangeSubGroupCount : idResult Equals Op (GetKernelNDrangeSubGroupCount idResultType | SpecConstantOp idResultType GetKernelNDrangeSubGroupCount) nDRange invoke paramIdRef paramSize paramAlign;
opGetKernelNDrangeMaxSubGroupSize : idResult Equals Op (GetKernelNDrangeMaxSubGroupSize idResultType | SpecConstantOp idResultType GetKernelNDrangeMaxSubGroupSize) nDRange invoke paramIdRef paramSize paramAlign;
opGetKernelWorkGroupSize : idResult Equals Op (GetKernelWorkGroupSize idResultType | SpecConstantOp idResultType GetKernelWorkGroupSize) invoke paramIdRef paramSize paramAlign;
opGetKernelPreferredWorkGroupSizeMultiple : idResult Equals Op (GetKernelPreferredWorkGroupSizeMultiple idResultType | SpecConstantOp idResultType GetKernelPreferredWorkGroupSizeMultiple) invoke paramIdRef paramSize paramAlign;
opRetainEvent : Op RetainEvent event;
opReleaseEvent : Op ReleaseEvent event;
opCreateUserEvent : idResult Equals Op (CreateUserEvent idResultType | SpecConstantOp idResultType CreateUserEvent);
opIsValidEvent : idResult Equals Op (IsValidEvent idResultType | SpecConstantOp idResultType IsValidEvent) event;
opSetUserEventStatus : Op SetUserEventStatus event status;
opCaptureEventProfilingInfo : Op CaptureEventProfilingInfo event profilingInfo valueIdRef;
opGetDefaultQueue : idResult Equals Op (GetDefaultQueue idResultType | SpecConstantOp idResultType GetDefaultQueue);
opBuildNDRange : idResult Equals Op (BuildNDRange idResultType | SpecConstantOp idResultType BuildNDRange) globalWorkSize localWorkSize globalWorkOffset;
opGetKernelLocalSizeForSubgroupCount : idResult Equals Op (GetKernelLocalSizeForSubgroupCount idResultType | SpecConstantOp idResultType GetKernelLocalSizeForSubgroupCount) subgroupCount invoke paramIdRef paramSize paramAlign;
opGetKernelMaxNumSubgroups : idResult Equals Op (GetKernelMaxNumSubgroups idResultType | SpecConstantOp idResultType GetKernelMaxNumSubgroups) invoke paramIdRef paramSize paramAlign;

// Extension Operations
opExtension : Op Extension nameLiteralString;
opExtInstImport : idResult Equals Op (ExtInstImport  | SpecConstantOp  ExtInstImport) nameLiteralString;
opExtInst : idResult Equals Op (ExtInst idResultType | SpecConstantOp idResultType ExtInst) set instruction;

// Function Operations
opFunction : idResult Equals Op (Function idResultType | SpecConstantOp idResultType Function) functionControl (Pipe functionControl)* functionType;
opFunctionParameter : idResult Equals Op (FunctionParameter idResultType | SpecConstantOp idResultType FunctionParameter);
opFunctionEnd : Op FunctionEnd;
opFunctionCall : idResult Equals Op (FunctionCall idResultType | SpecConstantOp idResultType FunctionCall) function argument*;
opCooperativeMatrixPerElementOpNV : idResult Equals Op (CooperativeMatrixPerElementOpNV idResultType | SpecConstantOp idResultType CooperativeMatrixPerElementOpNV) matrix func operands*;

// Group Operations
opGroupAsyncCopy : idResult Equals Op (GroupAsyncCopy idResultType | SpecConstantOp idResultType GroupAsyncCopy) execution destination sourceIdRef numElements stride event;
opGroupWaitEvents : Op GroupWaitEvents execution numEvents eventsList;
opGroupAll : idResult Equals Op (GroupAll idResultType | SpecConstantOp idResultType GroupAll) execution predicate;
opGroupAny : idResult Equals Op (GroupAny idResultType | SpecConstantOp idResultType GroupAny) execution predicate;
opGroupBroadcast : idResult Equals Op (GroupBroadcast idResultType | SpecConstantOp idResultType GroupBroadcast) execution valueIdRef localId;
opGroupIAdd : idResult Equals Op (GroupIAdd idResultType | SpecConstantOp idResultType GroupIAdd) execution operation x;
opGroupFAdd : idResult Equals Op (GroupFAdd idResultType | SpecConstantOp idResultType GroupFAdd) execution operation x;
opGroupFMin : idResult Equals Op (GroupFMin idResultType | SpecConstantOp idResultType GroupFMin) execution operation x;
opGroupUMin : idResult Equals Op (GroupUMin idResultType | SpecConstantOp idResultType GroupUMin) execution operation x;
opGroupSMin : idResult Equals Op (GroupSMin idResultType | SpecConstantOp idResultType GroupSMin) execution operation x;
opGroupFMax : idResult Equals Op (GroupFMax idResultType | SpecConstantOp idResultType GroupFMax) execution operation x;
opGroupUMax : idResult Equals Op (GroupUMax idResultType | SpecConstantOp idResultType GroupUMax) execution operation x;
opGroupSMax : idResult Equals Op (GroupSMax idResultType | SpecConstantOp idResultType GroupSMax) execution operation x;
opSubgroupBallotKHR : idResult Equals Op (SubgroupBallotKHR idResultType | SpecConstantOp idResultType SubgroupBallotKHR) predicate;
opSubgroupFirstInvocationKHR : idResult Equals Op (SubgroupFirstInvocationKHR idResultType | SpecConstantOp idResultType SubgroupFirstInvocationKHR) valueIdRef;
opSubgroupAllKHR : idResult Equals Op (SubgroupAllKHR idResultType | SpecConstantOp idResultType SubgroupAllKHR) predicate;
opSubgroupAnyKHR : idResult Equals Op (SubgroupAnyKHR idResultType | SpecConstantOp idResultType SubgroupAnyKHR) predicate;
opSubgroupAllEqualKHR : idResult Equals Op (SubgroupAllEqualKHR idResultType | SpecConstantOp idResultType SubgroupAllEqualKHR) predicate;
opGroupNonUniformRotateKHR : idResult Equals Op (GroupNonUniformRotateKHR idResultType | SpecConstantOp idResultType GroupNonUniformRotateKHR) execution valueIdRef delta clusterSize?;
opSubgroupReadInvocationKHR : idResult Equals Op (SubgroupReadInvocationKHR idResultType | SpecConstantOp idResultType SubgroupReadInvocationKHR) valueIdRef indexIdRef;
opGroupIAddNonUniformAMD : idResult Equals Op (GroupIAddNonUniformAMD idResultType | SpecConstantOp idResultType GroupIAddNonUniformAMD) execution operation x;
opGroupFAddNonUniformAMD : idResult Equals Op (GroupFAddNonUniformAMD idResultType | SpecConstantOp idResultType GroupFAddNonUniformAMD) execution operation x;
opGroupFMinNonUniformAMD : idResult Equals Op (GroupFMinNonUniformAMD idResultType | SpecConstantOp idResultType GroupFMinNonUniformAMD) execution operation x;
opGroupUMinNonUniformAMD : idResult Equals Op (GroupUMinNonUniformAMD idResultType | SpecConstantOp idResultType GroupUMinNonUniformAMD) execution operation x;
opGroupSMinNonUniformAMD : idResult Equals Op (GroupSMinNonUniformAMD idResultType | SpecConstantOp idResultType GroupSMinNonUniformAMD) execution operation x;
opGroupFMaxNonUniformAMD : idResult Equals Op (GroupFMaxNonUniformAMD idResultType | SpecConstantOp idResultType GroupFMaxNonUniformAMD) execution operation x;
opGroupUMaxNonUniformAMD : idResult Equals Op (GroupUMaxNonUniformAMD idResultType | SpecConstantOp idResultType GroupUMaxNonUniformAMD) execution operation x;
opGroupSMaxNonUniformAMD : idResult Equals Op (GroupSMaxNonUniformAMD idResultType | SpecConstantOp idResultType GroupSMaxNonUniformAMD) execution operation x;
opSubgroupShuffleINTEL : idResult Equals Op (SubgroupShuffleINTEL idResultType | SpecConstantOp idResultType SubgroupShuffleINTEL) data invocationId;
opSubgroupShuffleDownINTEL : idResult Equals Op (SubgroupShuffleDownINTEL idResultType | SpecConstantOp idResultType SubgroupShuffleDownINTEL) current next delta;
opSubgroupShuffleUpINTEL : idResult Equals Op (SubgroupShuffleUpINTEL idResultType | SpecConstantOp idResultType SubgroupShuffleUpINTEL) previous current delta;
opSubgroupShuffleXorINTEL : idResult Equals Op (SubgroupShuffleXorINTEL idResultType | SpecConstantOp idResultType SubgroupShuffleXorINTEL) data valueIdRef;
opSubgroupBlockReadINTEL : idResult Equals Op (SubgroupBlockReadINTEL idResultType | SpecConstantOp idResultType SubgroupBlockReadINTEL) ptr;
opSubgroupBlockWriteINTEL : Op SubgroupBlockWriteINTEL ptr data;
opSubgroupImageBlockReadINTEL : idResult Equals Op (SubgroupImageBlockReadINTEL idResultType | SpecConstantOp idResultType SubgroupImageBlockReadINTEL) image coordinate;
opSubgroupImageBlockWriteINTEL : Op SubgroupImageBlockWriteINTEL image coordinate data;
opSubgroupImageMediaBlockReadINTEL : idResult Equals Op (SubgroupImageMediaBlockReadINTEL idResultType | SpecConstantOp idResultType SubgroupImageMediaBlockReadINTEL) image coordinate widthIdRef height;
opSubgroupImageMediaBlockWriteINTEL : Op SubgroupImageMediaBlockWriteINTEL image coordinate widthIdRef height data;
opSubgroupBlockPrefetchINTEL : Op SubgroupBlockPrefetchINTEL ptr numBytes memoryAccess?;
opSubgroup2DBlockLoadINTEL : Op Subgroup2DBlockLoadINTEL elementSize blockWidth blockHeight blockCount srcBasePointer memoryWidth memoryHeight memoryPitch coordinate dstPointer;
opSubgroup2DBlockLoadTransformINTEL : Op Subgroup2DBlockLoadTransformINTEL elementSize blockWidth blockHeight blockCount srcBasePointer memoryWidth memoryHeight memoryPitch coordinate dstPointer;
opSubgroup2DBlockLoadTransposeINTEL : Op Subgroup2DBlockLoadTransposeINTEL elementSize blockWidth blockHeight blockCount srcBasePointer memoryWidth memoryHeight memoryPitch coordinate dstPointer;
opSubgroup2DBlockPrefetchINTEL : Op Subgroup2DBlockPrefetchINTEL elementSize blockWidth blockHeight blockCount srcBasePointer memoryWidth memoryHeight memoryPitch coordinate;
opSubgroup2DBlockStoreINTEL : Op Subgroup2DBlockStoreINTEL elementSize blockWidth blockHeight blockCount srcPointer dstBasePointer memoryWidth memoryHeight memoryPitch coordinate;
opSubgroupMatrixMultiplyAccumulateINTEL : idResult Equals Op (SubgroupMatrixMultiplyAccumulateINTEL idResultType | SpecConstantOp idResultType SubgroupMatrixMultiplyAccumulateINTEL) kDim matrixA matrixB matrixC matrixMultiplyAccumulateOperands?;
opGroupIMulKHR : idResult Equals Op (GroupIMulKHR idResultType | SpecConstantOp idResultType GroupIMulKHR) execution operation x;
opGroupFMulKHR : idResult Equals Op (GroupFMulKHR idResultType | SpecConstantOp idResultType GroupFMulKHR) execution operation x;
opGroupBitwiseAndKHR : idResult Equals Op (GroupBitwiseAndKHR idResultType | SpecConstantOp idResultType GroupBitwiseAndKHR) execution operation x;
opGroupBitwiseOrKHR : idResult Equals Op (GroupBitwiseOrKHR idResultType | SpecConstantOp idResultType GroupBitwiseOrKHR) execution operation x;
opGroupBitwiseXorKHR : idResult Equals Op (GroupBitwiseXorKHR idResultType | SpecConstantOp idResultType GroupBitwiseXorKHR) execution operation x;
opGroupLogicalAndKHR : idResult Equals Op (GroupLogicalAndKHR idResultType | SpecConstantOp idResultType GroupLogicalAndKHR) execution operation x;
opGroupLogicalOrKHR : idResult Equals Op (GroupLogicalOrKHR idResultType | SpecConstantOp idResultType GroupLogicalOrKHR) execution operation x;
opGroupLogicalXorKHR : idResult Equals Op (GroupLogicalXorKHR idResultType | SpecConstantOp idResultType GroupLogicalXorKHR) execution operation x;

// Image Operations
opSampledImage : idResult Equals Op (SampledImage idResultType | SpecConstantOp idResultType SampledImage) image sampler;
opImageSampleImplicitLod : idResult Equals Op (ImageSampleImplicitLod idResultType | SpecConstantOp idResultType ImageSampleImplicitLod) sampledImage coordinate imageOperands?;
opImageSampleExplicitLod : idResult Equals Op (ImageSampleExplicitLod idResultType | SpecConstantOp idResultType ImageSampleExplicitLod) sampledImage coordinate imageOperands;
opImageSampleDrefImplicitLod : idResult Equals Op (ImageSampleDrefImplicitLod idResultType | SpecConstantOp idResultType ImageSampleDrefImplicitLod) sampledImage coordinate d imageOperands?;
opImageSampleDrefExplicitLod : idResult Equals Op (ImageSampleDrefExplicitLod idResultType | SpecConstantOp idResultType ImageSampleDrefExplicitLod) sampledImage coordinate d imageOperands;
opImageSampleProjImplicitLod : idResult Equals Op (ImageSampleProjImplicitLod idResultType | SpecConstantOp idResultType ImageSampleProjImplicitLod) sampledImage coordinate imageOperands?;
opImageSampleProjExplicitLod : idResult Equals Op (ImageSampleProjExplicitLod idResultType | SpecConstantOp idResultType ImageSampleProjExplicitLod) sampledImage coordinate imageOperands;
opImageSampleProjDrefImplicitLod : idResult Equals Op (ImageSampleProjDrefImplicitLod idResultType | SpecConstantOp idResultType ImageSampleProjDrefImplicitLod) sampledImage coordinate d imageOperands?;
opImageSampleProjDrefExplicitLod : idResult Equals Op (ImageSampleProjDrefExplicitLod idResultType | SpecConstantOp idResultType ImageSampleProjDrefExplicitLod) sampledImage coordinate d imageOperands;
opImageFetch : idResult Equals Op (ImageFetch idResultType | SpecConstantOp idResultType ImageFetch) image coordinate imageOperands?;
opImageGather : idResult Equals Op (ImageGather idResultType | SpecConstantOp idResultType ImageGather) sampledImage coordinate componentIdRef imageOperands?;
opImageDrefGather : idResult Equals Op (ImageDrefGather idResultType | SpecConstantOp idResultType ImageDrefGather) sampledImage coordinate d imageOperands?;
opImageRead : idResult Equals Op (ImageRead idResultType | SpecConstantOp idResultType ImageRead) image coordinate imageOperands?;
opImageWrite : Op ImageWrite image coordinate texel imageOperands?;
opImage : idResult Equals Op (Image idResultType | SpecConstantOp idResultType Image) sampledImage;
opImageQueryFormat : idResult Equals Op (ImageQueryFormat idResultType | SpecConstantOp idResultType ImageQueryFormat) image;
opImageQueryOrder : idResult Equals Op (ImageQueryOrder idResultType | SpecConstantOp idResultType ImageQueryOrder) image;
opImageQuerySizeLod : idResult Equals Op (ImageQuerySizeLod idResultType | SpecConstantOp idResultType ImageQuerySizeLod) image levelOfDetail;
opImageQuerySize : idResult Equals Op (ImageQuerySize idResultType | SpecConstantOp idResultType ImageQuerySize) image;
opImageQueryLod : idResult Equals Op (ImageQueryLod idResultType | SpecConstantOp idResultType ImageQueryLod) sampledImage coordinate;
opImageQueryLevels : idResult Equals Op (ImageQueryLevels idResultType | SpecConstantOp idResultType ImageQueryLevels) image;
opImageQuerySamples : idResult Equals Op (ImageQuerySamples idResultType | SpecConstantOp idResultType ImageQuerySamples) image;
opImageSparseSampleImplicitLod : idResult Equals Op (ImageSparseSampleImplicitLod idResultType | SpecConstantOp idResultType ImageSparseSampleImplicitLod) sampledImage coordinate imageOperands?;
opImageSparseSampleExplicitLod : idResult Equals Op (ImageSparseSampleExplicitLod idResultType | SpecConstantOp idResultType ImageSparseSampleExplicitLod) sampledImage coordinate imageOperands;
opImageSparseSampleDrefImplicitLod : idResult Equals Op (ImageSparseSampleDrefImplicitLod idResultType | SpecConstantOp idResultType ImageSparseSampleDrefImplicitLod) sampledImage coordinate d imageOperands?;
opImageSparseSampleDrefExplicitLod : idResult Equals Op (ImageSparseSampleDrefExplicitLod idResultType | SpecConstantOp idResultType ImageSparseSampleDrefExplicitLod) sampledImage coordinate d imageOperands;
opImageSparseSampleProjImplicitLod : idResult Equals Op (ImageSparseSampleProjImplicitLod idResultType | SpecConstantOp idResultType ImageSparseSampleProjImplicitLod) sampledImage coordinate imageOperands?;
opImageSparseSampleProjExplicitLod : idResult Equals Op (ImageSparseSampleProjExplicitLod idResultType | SpecConstantOp idResultType ImageSparseSampleProjExplicitLod) sampledImage coordinate imageOperands;
opImageSparseSampleProjDrefImplicitLod : idResult Equals Op (ImageSparseSampleProjDrefImplicitLod idResultType | SpecConstantOp idResultType ImageSparseSampleProjDrefImplicitLod) sampledImage coordinate d imageOperands?;
opImageSparseSampleProjDrefExplicitLod : idResult Equals Op (ImageSparseSampleProjDrefExplicitLod idResultType | SpecConstantOp idResultType ImageSparseSampleProjDrefExplicitLod) sampledImage coordinate d imageOperands;
opImageSparseFetch : idResult Equals Op (ImageSparseFetch idResultType | SpecConstantOp idResultType ImageSparseFetch) image coordinate imageOperands?;
opImageSparseGather : idResult Equals Op (ImageSparseGather idResultType | SpecConstantOp idResultType ImageSparseGather) sampledImage coordinate componentIdRef imageOperands?;
opImageSparseDrefGather : idResult Equals Op (ImageSparseDrefGather idResultType | SpecConstantOp idResultType ImageSparseDrefGather) sampledImage coordinate d imageOperands?;
opImageSparseTexelsResident : idResult Equals Op (ImageSparseTexelsResident idResultType | SpecConstantOp idResultType ImageSparseTexelsResident) residentCode;
opImageSparseRead : idResult Equals Op (ImageSparseRead idResultType | SpecConstantOp idResultType ImageSparseRead) image coordinate imageOperands?;
opColorAttachmentReadEXT : idResult Equals Op (ColorAttachmentReadEXT idResultType | SpecConstantOp idResultType ColorAttachmentReadEXT) attachment sample?;
opDepthAttachmentReadEXT : idResult Equals Op (DepthAttachmentReadEXT idResultType | SpecConstantOp idResultType DepthAttachmentReadEXT) sample?;
opStencilAttachmentReadEXT : idResult Equals Op (StencilAttachmentReadEXT idResultType | SpecConstantOp idResultType StencilAttachmentReadEXT) sample?;
opImageSampleWeightedQCOM : idResult Equals Op (ImageSampleWeightedQCOM idResultType | SpecConstantOp idResultType ImageSampleWeightedQCOM) texture coordinates weights;
opImageBoxFilterQCOM : idResult Equals Op (ImageBoxFilterQCOM idResultType | SpecConstantOp idResultType ImageBoxFilterQCOM) texture coordinates boxSize;
opImageBlockMatchSSDQCOM : idResult Equals Op (ImageBlockMatchSSDQCOM idResultType | SpecConstantOp idResultType ImageBlockMatchSSDQCOM) targetIdRef targetCoordinates reference referenceCoordinates blockSize;
opImageBlockMatchSADQCOM : idResult Equals Op (ImageBlockMatchSADQCOM idResultType | SpecConstantOp idResultType ImageBlockMatchSADQCOM) targetIdRef targetCoordinates reference referenceCoordinates blockSize;
opImageBlockMatchWindowSSDQCOM : idResult Equals Op (ImageBlockMatchWindowSSDQCOM idResultType | SpecConstantOp idResultType ImageBlockMatchWindowSSDQCOM) targetSampledImage targetCoordinates referenceSampledImage referenceCoordinates blockSize;
opImageBlockMatchWindowSADQCOM : idResult Equals Op (ImageBlockMatchWindowSADQCOM idResultType | SpecConstantOp idResultType ImageBlockMatchWindowSADQCOM) targetSampledImage targetCoordinates referenceSampledImage referenceCoordinates blockSize;
opImageBlockMatchGatherSSDQCOM : idResult Equals Op (ImageBlockMatchGatherSSDQCOM idResultType | SpecConstantOp idResultType ImageBlockMatchGatherSSDQCOM) targetSampledImage targetCoordinates referenceSampledImage referenceCoordinates blockSize;
opImageBlockMatchGatherSADQCOM : idResult Equals Op (ImageBlockMatchGatherSADQCOM idResultType | SpecConstantOp idResultType ImageBlockMatchGatherSADQCOM) targetSampledImage targetCoordinates referenceSampledImage referenceCoordinates blockSize;
opImageSampleFootprintNV : idResult Equals Op (ImageSampleFootprintNV idResultType | SpecConstantOp idResultType ImageSampleFootprintNV) sampledImage coordinate granularity coarse imageOperands?;

// Memory Operations
opVariable : idResult Equals Op (Variable idResultType | SpecConstantOp idResultType Variable) storageClass initializer?;
opImageTexelPointer : idResult Equals Op (ImageTexelPointer idResultType | SpecConstantOp idResultType ImageTexelPointer) image coordinate sample;
opLoad : idResult Equals Op (Load idResultType | SpecConstantOp idResultType Load) pointer memoryAccess?;
opStore : Op Store pointer object memoryAccess?;
opCopyMemory : Op CopyMemory targetIdRef sourceIdRef (memoryAccess memoryAccess?)?;
opCopyMemorySized : Op CopyMemorySized targetIdRef sourceIdRef sizeIdRef (memoryAccess memoryAccess?)?;
opAccessChain : idResult Equals Op (AccessChain idResultType | SpecConstantOp idResultType AccessChain) base indexesIdRef*;
opInBoundsAccessChain : idResult Equals Op (InBoundsAccessChain idResultType | SpecConstantOp idResultType InBoundsAccessChain) base indexesIdRef*;
opPtrAccessChain : idResult Equals Op (PtrAccessChain idResultType | SpecConstantOp idResultType PtrAccessChain) base element indexesIdRef*;
opArrayLength : idResult Equals Op (ArrayLength idResultType | SpecConstantOp idResultType ArrayLength) structure arrayMember;
opGenericPtrMemSemantics : idResult Equals Op (GenericPtrMemSemantics idResultType | SpecConstantOp idResultType GenericPtrMemSemantics) pointer;
opInBoundsPtrAccessChain : idResult Equals Op (InBoundsPtrAccessChain idResultType | SpecConstantOp idResultType InBoundsPtrAccessChain) base element indexesIdRef*;
opPtrEqual : idResult Equals Op (PtrEqual idResultType | SpecConstantOp idResultType PtrEqual) operand1 operand2;
opPtrNotEqual : idResult Equals Op (PtrNotEqual idResultType | SpecConstantOp idResultType PtrNotEqual) operand1 operand2;
opPtrDiff : idResult Equals Op (PtrDiff idResultType | SpecConstantOp idResultType PtrDiff) operand1 operand2;
opUntypedVariableKHR : idResult Equals Op (UntypedVariableKHR idResultType | SpecConstantOp idResultType UntypedVariableKHR) storageClass (dataType initializer?)?;
opUntypedAccessChainKHR : idResult Equals Op (UntypedAccessChainKHR idResultType | SpecConstantOp idResultType UntypedAccessChainKHR) baseType base indexesIdRef*;
opUntypedInBoundsAccessChainKHR : idResult Equals Op (UntypedInBoundsAccessChainKHR idResultType | SpecConstantOp idResultType UntypedInBoundsAccessChainKHR) baseType base indexesIdRef*;
opUntypedPtrAccessChainKHR : idResult Equals Op (UntypedPtrAccessChainKHR idResultType | SpecConstantOp idResultType UntypedPtrAccessChainKHR) baseType base element indexesIdRef*;
opUntypedInBoundsPtrAccessChainKHR : idResult Equals Op (UntypedInBoundsPtrAccessChainKHR idResultType | SpecConstantOp idResultType UntypedInBoundsPtrAccessChainKHR) baseType base element indexesIdRef*;
opUntypedArrayLengthKHR : idResult Equals Op (UntypedArrayLengthKHR idResultType | SpecConstantOp idResultType UntypedArrayLengthKHR) structure pointer arrayMember;
opUntypedPrefetchKHR : Op UntypedPrefetchKHR pointerType numBytes (rW (locality cacheType?)?)?;
opCooperativeMatrixLoadKHR : idResult Equals Op (CooperativeMatrixLoadKHR idResultType | SpecConstantOp idResultType CooperativeMatrixLoadKHR) pointer memoryLayout stride? memoryOperand?;
opCooperativeMatrixStoreKHR : Op CooperativeMatrixStoreKHR pointer object memoryLayout stride? memoryOperand?;
opCooperativeVectorLoadNV : idResult Equals Op (CooperativeVectorLoadNV idResultType | SpecConstantOp idResultType CooperativeVectorLoadNV) pointer offsetIdRef memoryAccess?;
opCooperativeVectorStoreNV : Op CooperativeVectorStoreNV pointer offsetIdRef object memoryAccess?;
opCooperativeMatrixLoadTensorNV : idResult Equals Op (CooperativeMatrixLoadTensorNV idResultType | SpecConstantOp idResultType CooperativeMatrixLoadTensorNV) pointer object tensorLayout memoryOperand tensorAddressingOperands;
opCooperativeMatrixStoreTensorNV : Op CooperativeMatrixStoreTensorNV pointer object tensorLayout memoryOperand tensorAddressingOperands;
opRawAccessChainNV : idResult Equals Op (RawAccessChainNV idResultType | SpecConstantOp idResultType RawAccessChainNV) base byteStride elementIndex byteOffsetIdRef rawAccessChainOperands?;
opMaskedGatherINTEL : idResult Equals Op (MaskedGatherINTEL idResultType | SpecConstantOp idResultType MaskedGatherINTEL) ptrVector alignmentLiteralInteger mask fillEmpty;
opMaskedScatterINTEL : Op MaskedScatterINTEL inputVector ptrVector alignmentLiteralInteger mask;

// Miscellaneous Operations
opNop : Op Nop;
opUndef : idResult Equals Op (Undef idResultType | SpecConstantOp idResultType Undef);
opSizeOf : idResult Equals Op (SizeOf idResultType | SpecConstantOp idResultType SizeOf) pointer;
opCooperativeMatrixLengthKHR : idResult Equals Op (CooperativeMatrixLengthKHR idResultType | SpecConstantOp idResultType CooperativeMatrixLengthKHR) type;
opAssumeTrueKHR : Op AssumeTrueKHR condition;
opExpectKHR : idResult Equals Op (ExpectKHR idResultType | SpecConstantOp idResultType ExpectKHR) valueIdRef expectedValue;
opArithmeticFenceEXT : idResult Equals Op (ArithmeticFenceEXT idResultType | SpecConstantOp idResultType ArithmeticFenceEXT) targetIdRef;

// Mode-Setting Operations
opMemoryModel : Op MemoryModel addressingModel memoryModel;
opEntryPoint : Op EntryPoint executionModel entryPoint nameLiteralString interface*;
opExecutionMode : Op ExecutionMode entryPoint modeExecutionMode;
opCapability : Op Capability capability;
opExecutionModeId : Op ExecutionModeId entryPoint modeExecutionMode;

// Non-Uniform Operations
opGroupNonUniformElect : idResult Equals Op (GroupNonUniformElect idResultType | SpecConstantOp idResultType GroupNonUniformElect) execution;
opGroupNonUniformAll : idResult Equals Op (GroupNonUniformAll idResultType | SpecConstantOp idResultType GroupNonUniformAll) execution predicate;
opGroupNonUniformAny : idResult Equals Op (GroupNonUniformAny idResultType | SpecConstantOp idResultType GroupNonUniformAny) execution predicate;
opGroupNonUniformAllEqual : idResult Equals Op (GroupNonUniformAllEqual idResultType | SpecConstantOp idResultType GroupNonUniformAllEqual) execution valueIdRef;
opGroupNonUniformBroadcast : idResult Equals Op (GroupNonUniformBroadcast idResultType | SpecConstantOp idResultType GroupNonUniformBroadcast) execution valueIdRef id;
opGroupNonUniformBroadcastFirst : idResult Equals Op (GroupNonUniformBroadcastFirst idResultType | SpecConstantOp idResultType GroupNonUniformBroadcastFirst) execution valueIdRef;
opGroupNonUniformBallot : idResult Equals Op (GroupNonUniformBallot idResultType | SpecConstantOp idResultType GroupNonUniformBallot) execution predicate;
opGroupNonUniformInverseBallot : idResult Equals Op (GroupNonUniformInverseBallot idResultType | SpecConstantOp idResultType GroupNonUniformInverseBallot) execution valueIdRef;
opGroupNonUniformBallotBitExtract : idResult Equals Op (GroupNonUniformBallotBitExtract idResultType | SpecConstantOp idResultType GroupNonUniformBallotBitExtract) execution valueIdRef indexIdRef;
opGroupNonUniformBallotBitCount : idResult Equals Op (GroupNonUniformBallotBitCount idResultType | SpecConstantOp idResultType GroupNonUniformBallotBitCount) execution operation valueIdRef;
opGroupNonUniformBallotFindLSB : idResult Equals Op (GroupNonUniformBallotFindLSB idResultType | SpecConstantOp idResultType GroupNonUniformBallotFindLSB) execution valueIdRef;
opGroupNonUniformBallotFindMSB : idResult Equals Op (GroupNonUniformBallotFindMSB idResultType | SpecConstantOp idResultType GroupNonUniformBallotFindMSB) execution valueIdRef;
opGroupNonUniformShuffle : idResult Equals Op (GroupNonUniformShuffle idResultType | SpecConstantOp idResultType GroupNonUniformShuffle) execution valueIdRef id;
opGroupNonUniformShuffleXor : idResult Equals Op (GroupNonUniformShuffleXor idResultType | SpecConstantOp idResultType GroupNonUniformShuffleXor) execution valueIdRef mask;
opGroupNonUniformShuffleUp : idResult Equals Op (GroupNonUniformShuffleUp idResultType | SpecConstantOp idResultType GroupNonUniformShuffleUp) execution valueIdRef delta;
opGroupNonUniformShuffleDown : idResult Equals Op (GroupNonUniformShuffleDown idResultType | SpecConstantOp idResultType GroupNonUniformShuffleDown) execution valueIdRef delta;
opGroupNonUniformIAdd : idResult Equals Op (GroupNonUniformIAdd idResultType | SpecConstantOp idResultType GroupNonUniformIAdd) execution operation valueIdRef clusterSize?;
opGroupNonUniformFAdd : idResult Equals Op (GroupNonUniformFAdd idResultType | SpecConstantOp idResultType GroupNonUniformFAdd) execution operation valueIdRef clusterSize?;
opGroupNonUniformIMul : idResult Equals Op (GroupNonUniformIMul idResultType | SpecConstantOp idResultType GroupNonUniformIMul) execution operation valueIdRef clusterSize?;
opGroupNonUniformFMul : idResult Equals Op (GroupNonUniformFMul idResultType | SpecConstantOp idResultType GroupNonUniformFMul) execution operation valueIdRef clusterSize?;
opGroupNonUniformSMin : idResult Equals Op (GroupNonUniformSMin idResultType | SpecConstantOp idResultType GroupNonUniformSMin) execution operation valueIdRef clusterSize?;
opGroupNonUniformUMin : idResult Equals Op (GroupNonUniformUMin idResultType | SpecConstantOp idResultType GroupNonUniformUMin) execution operation valueIdRef clusterSize?;
opGroupNonUniformFMin : idResult Equals Op (GroupNonUniformFMin idResultType | SpecConstantOp idResultType GroupNonUniformFMin) execution operation valueIdRef clusterSize?;
opGroupNonUniformSMax : idResult Equals Op (GroupNonUniformSMax idResultType | SpecConstantOp idResultType GroupNonUniformSMax) execution operation valueIdRef clusterSize?;
opGroupNonUniformUMax : idResult Equals Op (GroupNonUniformUMax idResultType | SpecConstantOp idResultType GroupNonUniformUMax) execution operation valueIdRef clusterSize?;
opGroupNonUniformFMax : idResult Equals Op (GroupNonUniformFMax idResultType | SpecConstantOp idResultType GroupNonUniformFMax) execution operation valueIdRef clusterSize?;
opGroupNonUniformBitwiseAnd : idResult Equals Op (GroupNonUniformBitwiseAnd idResultType | SpecConstantOp idResultType GroupNonUniformBitwiseAnd) execution operation valueIdRef clusterSize?;
opGroupNonUniformBitwiseOr : idResult Equals Op (GroupNonUniformBitwiseOr idResultType | SpecConstantOp idResultType GroupNonUniformBitwiseOr) execution operation valueIdRef clusterSize?;
opGroupNonUniformBitwiseXor : idResult Equals Op (GroupNonUniformBitwiseXor idResultType | SpecConstantOp idResultType GroupNonUniformBitwiseXor) execution operation valueIdRef clusterSize?;
opGroupNonUniformLogicalAnd : idResult Equals Op (GroupNonUniformLogicalAnd idResultType | SpecConstantOp idResultType GroupNonUniformLogicalAnd) execution operation valueIdRef clusterSize?;
opGroupNonUniformLogicalOr : idResult Equals Op (GroupNonUniformLogicalOr idResultType | SpecConstantOp idResultType GroupNonUniformLogicalOr) execution operation valueIdRef clusterSize?;
opGroupNonUniformLogicalXor : idResult Equals Op (GroupNonUniformLogicalXor idResultType | SpecConstantOp idResultType GroupNonUniformLogicalXor) execution operation valueIdRef clusterSize?;
opGroupNonUniformQuadBroadcast : idResult Equals Op (GroupNonUniformQuadBroadcast idResultType | SpecConstantOp idResultType GroupNonUniformQuadBroadcast) execution valueIdRef indexIdRef;
opGroupNonUniformQuadSwap : idResult Equals Op (GroupNonUniformQuadSwap idResultType | SpecConstantOp idResultType GroupNonUniformQuadSwap) execution valueIdRef direction;
opGroupNonUniformQuadAllKHR : idResult Equals Op (GroupNonUniformQuadAllKHR idResultType | SpecConstantOp idResultType GroupNonUniformQuadAllKHR) predicate;
opGroupNonUniformQuadAnyKHR : idResult Equals Op (GroupNonUniformQuadAnyKHR idResultType | SpecConstantOp idResultType GroupNonUniformQuadAnyKHR) predicate;
opGroupNonUniformPartitionNV : idResult Equals Op (GroupNonUniformPartitionNV idResultType | SpecConstantOp idResultType GroupNonUniformPartitionNV) valueIdRef;

// Pipe Operations
opReadPipe : idResult Equals Op (ReadPipe idResultType | SpecConstantOp idResultType ReadPipe) pipe pointer packetSizeIdRef packetAlignmentIdRef;
opWritePipe : idResult Equals Op (WritePipe idResultType | SpecConstantOp idResultType WritePipe) pipe pointer packetSizeIdRef packetAlignmentIdRef;
opReservedReadPipe : idResult Equals Op (ReservedReadPipe idResultType | SpecConstantOp idResultType ReservedReadPipe) pipe reserveId indexIdRef pointer packetSizeIdRef packetAlignmentIdRef;
opReservedWritePipe : idResult Equals Op (ReservedWritePipe idResultType | SpecConstantOp idResultType ReservedWritePipe) pipe reserveId indexIdRef pointer packetSizeIdRef packetAlignmentIdRef;
opReserveReadPipePackets : idResult Equals Op (ReserveReadPipePackets idResultType | SpecConstantOp idResultType ReserveReadPipePackets) pipe numPackets packetSizeIdRef packetAlignmentIdRef;
opReserveWritePipePackets : idResult Equals Op (ReserveWritePipePackets idResultType | SpecConstantOp idResultType ReserveWritePipePackets) pipe numPackets packetSizeIdRef packetAlignmentIdRef;
opCommitReadPipe : Op CommitReadPipe pipe reserveId packetSizeIdRef packetAlignmentIdRef;
opCommitWritePipe : Op CommitWritePipe pipe reserveId packetSizeIdRef packetAlignmentIdRef;
opIsValidReserveId : idResult Equals Op (IsValidReserveId idResultType | SpecConstantOp idResultType IsValidReserveId) reserveId;
opGetNumPipePackets : idResult Equals Op (GetNumPipePackets idResultType | SpecConstantOp idResultType GetNumPipePackets) pipe packetSizeIdRef packetAlignmentIdRef;
opGetMaxPipePackets : idResult Equals Op (GetMaxPipePackets idResultType | SpecConstantOp idResultType GetMaxPipePackets) pipe packetSizeIdRef packetAlignmentIdRef;
opGroupReserveReadPipePackets : idResult Equals Op (GroupReserveReadPipePackets idResultType | SpecConstantOp idResultType GroupReserveReadPipePackets) execution pipe numPackets packetSizeIdRef packetAlignmentIdRef;
opGroupReserveWritePipePackets : idResult Equals Op (GroupReserveWritePipePackets idResultType | SpecConstantOp idResultType GroupReserveWritePipePackets) execution pipe numPackets packetSizeIdRef packetAlignmentIdRef;
opGroupCommitReadPipe : Op GroupCommitReadPipe execution pipe reserveId packetSizeIdRef packetAlignmentIdRef;
opGroupCommitWritePipe : Op GroupCommitWritePipe execution pipe reserveId packetSizeIdRef packetAlignmentIdRef;
opConstantPipeStorage : idResult Equals Op (ConstantPipeStorage idResultType | SpecConstantOp idResultType ConstantPipeStorage) packetSizeLiteralInteger packetAlignmentLiteralInteger capacity;
opCreatePipeFromPipeStorage : idResult Equals Op (CreatePipeFromPipeStorage idResultType | SpecConstantOp idResultType CreatePipeFromPipeStorage) pipeStorage;
opReadPipeBlockingINTEL : idResult Equals Op (ReadPipeBlockingINTEL idResultType | SpecConstantOp idResultType ReadPipeBlockingINTEL) packetSizeIdRef packetAlignmentIdRef;
opWritePipeBlockingINTEL : idResult Equals Op (WritePipeBlockingINTEL idResultType | SpecConstantOp idResultType WritePipeBlockingINTEL) packetSizeIdRef packetAlignmentIdRef;

// Primitive Operations
opEmitVertex : Op EmitVertex;
opEndPrimitive : Op EndPrimitive;
opEmitStreamVertex : Op EmitStreamVertex stream;
opEndStreamPrimitive : Op EndStreamPrimitive stream;

// Relational_and_Logical Operations
opAny : idResult Equals Op (Any idResultType | SpecConstantOp idResultType Any) vectorIdRef;
opAll : idResult Equals Op (All idResultType | SpecConstantOp idResultType All) vectorIdRef;
opIsNan : idResult Equals Op (IsNan idResultType | SpecConstantOp idResultType IsNan) x;
opIsInf : idResult Equals Op (IsInf idResultType | SpecConstantOp idResultType IsInf) x;
opIsFinite : idResult Equals Op (IsFinite idResultType | SpecConstantOp idResultType IsFinite) x;
opIsNormal : idResult Equals Op (IsNormal idResultType | SpecConstantOp idResultType IsNormal) x;
opSignBitSet : idResult Equals Op (SignBitSet idResultType | SpecConstantOp idResultType SignBitSet) x;
opLessOrGreater : idResult Equals Op (LessOrGreater idResultType | SpecConstantOp idResultType LessOrGreater) x y;
opOrdered : idResult Equals Op (Ordered idResultType | SpecConstantOp idResultType Ordered) x y;
opUnordered : idResult Equals Op (Unordered idResultType | SpecConstantOp idResultType Unordered) x y;
opLogicalEqual : idResult Equals Op (LogicalEqual idResultType | SpecConstantOp idResultType LogicalEqual) operand1 operand2;
opLogicalNotEqual : idResult Equals Op (LogicalNotEqual idResultType | SpecConstantOp idResultType LogicalNotEqual) operand1 operand2;
opLogicalOr : idResult Equals Op (LogicalOr idResultType | SpecConstantOp idResultType LogicalOr) operand1 operand2;
opLogicalAnd : idResult Equals Op (LogicalAnd idResultType | SpecConstantOp idResultType LogicalAnd) operand1 operand2;
opLogicalNot : idResult Equals Op (LogicalNot idResultType | SpecConstantOp idResultType LogicalNot) operand;
opSelect : idResult Equals Op (Select idResultType | SpecConstantOp idResultType Select) condition object1 object2;
opIEqual : idResult Equals Op (IEqual idResultType | SpecConstantOp idResultType IEqual) operand1 operand2;
opINotEqual : idResult Equals Op (INotEqual idResultType | SpecConstantOp idResultType INotEqual) operand1 operand2;
opUGreaterThan : idResult Equals Op (UGreaterThan idResultType | SpecConstantOp idResultType UGreaterThan) operand1 operand2;
opSGreaterThan : idResult Equals Op (SGreaterThan idResultType | SpecConstantOp idResultType SGreaterThan) operand1 operand2;
opUGreaterThanEqual : idResult Equals Op (UGreaterThanEqual idResultType | SpecConstantOp idResultType UGreaterThanEqual) operand1 operand2;
opSGreaterThanEqual : idResult Equals Op (SGreaterThanEqual idResultType | SpecConstantOp idResultType SGreaterThanEqual) operand1 operand2;
opULessThan : idResult Equals Op (ULessThan idResultType | SpecConstantOp idResultType ULessThan) operand1 operand2;
opSLessThan : idResult Equals Op (SLessThan idResultType | SpecConstantOp idResultType SLessThan) operand1 operand2;
opULessThanEqual : idResult Equals Op (ULessThanEqual idResultType | SpecConstantOp idResultType ULessThanEqual) operand1 operand2;
opSLessThanEqual : idResult Equals Op (SLessThanEqual idResultType | SpecConstantOp idResultType SLessThanEqual) operand1 operand2;
opFOrdEqual : idResult Equals Op (FOrdEqual idResultType | SpecConstantOp idResultType FOrdEqual) operand1 operand2;
opFUnordEqual : idResult Equals Op (FUnordEqual idResultType | SpecConstantOp idResultType FUnordEqual) operand1 operand2;
opFOrdNotEqual : idResult Equals Op (FOrdNotEqual idResultType | SpecConstantOp idResultType FOrdNotEqual) operand1 operand2;
opFUnordNotEqual : idResult Equals Op (FUnordNotEqual idResultType | SpecConstantOp idResultType FUnordNotEqual) operand1 operand2;
opFOrdLessThan : idResult Equals Op (FOrdLessThan idResultType | SpecConstantOp idResultType FOrdLessThan) operand1 operand2;
opFUnordLessThan : idResult Equals Op (FUnordLessThan idResultType | SpecConstantOp idResultType FUnordLessThan) operand1 operand2;
opFOrdGreaterThan : idResult Equals Op (FOrdGreaterThan idResultType | SpecConstantOp idResultType FOrdGreaterThan) operand1 operand2;
opFUnordGreaterThan : idResult Equals Op (FUnordGreaterThan idResultType | SpecConstantOp idResultType FUnordGreaterThan) operand1 operand2;
opFOrdLessThanEqual : idResult Equals Op (FOrdLessThanEqual idResultType | SpecConstantOp idResultType FOrdLessThanEqual) operand1 operand2;
opFUnordLessThanEqual : idResult Equals Op (FUnordLessThanEqual idResultType | SpecConstantOp idResultType FUnordLessThanEqual) operand1 operand2;
opFOrdGreaterThanEqual : idResult Equals Op (FOrdGreaterThanEqual idResultType | SpecConstantOp idResultType FOrdGreaterThanEqual) operand1 operand2;
opFUnordGreaterThanEqual : idResult Equals Op (FUnordGreaterThanEqual idResultType | SpecConstantOp idResultType FUnordGreaterThanEqual) operand1 operand2;

// Reserved Operations
opTraceRayKHR : Op TraceRayKHR accel rayFlagsIdRef cullMask sBTOffset sBTStride missIndex rayOrigin rayTmin rayDirection rayTmax payload;
opExecuteCallableKHR : Op ExecuteCallableKHR sBTIndex callableData;
opConvertUToAccelerationStructureKHR : idResult Equals Op (ConvertUToAccelerationStructureKHR idResultType | SpecConstantOp idResultType ConvertUToAccelerationStructureKHR) accel;
opIgnoreIntersectionKHR : Op IgnoreIntersectionKHR;
opTerminateRayKHR : Op TerminateRayKHR;
opRayQueryInitializeKHR : Op RayQueryInitializeKHR rayQuery accel rayFlagsIdRef cullMask rayOrigin rayTmin rayDirection rayTmax;
opRayQueryTerminateKHR : Op RayQueryTerminateKHR rayQuery;
opRayQueryGenerateIntersectionKHR : Op RayQueryGenerateIntersectionKHR rayQuery hitT;
opRayQueryConfirmIntersectionKHR : Op RayQueryConfirmIntersectionKHR rayQuery;
opRayQueryProceedKHR : idResult Equals Op (RayQueryProceedKHR idResultType | SpecConstantOp idResultType RayQueryProceedKHR) rayQuery;
opRayQueryGetIntersectionTypeKHR : idResult Equals Op (RayQueryGetIntersectionTypeKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionTypeKHR) rayQuery intersection;
opFragmentMaskFetchAMD : idResult Equals Op (FragmentMaskFetchAMD idResultType | SpecConstantOp idResultType FragmentMaskFetchAMD) image coordinate;
opFragmentFetchAMD : idResult Equals Op (FragmentFetchAMD idResultType | SpecConstantOp idResultType FragmentFetchAMD) image coordinate fragmentIndex;
opReadClockKHR : idResult Equals Op (ReadClockKHR idResultType | SpecConstantOp idResultType ReadClockKHR) scopeIdScope;
opAllocateNodePayloadsAMDX : idResult Equals Op (AllocateNodePayloadsAMDX idResultType | SpecConstantOp idResultType AllocateNodePayloadsAMDX) visibility payloadCount nodeIndex;
opEnqueueNodePayloadsAMDX : Op EnqueueNodePayloadsAMDX payloadArray;
opTypeNodePayloadArrayAMDX : idResult Equals Op (TypeNodePayloadArrayAMDX  | SpecConstantOp  TypeNodePayloadArrayAMDX) payloadType;
opFinishWritingNodePayloadAMDX : idResult Equals Op (FinishWritingNodePayloadAMDX idResultType | SpecConstantOp idResultType FinishWritingNodePayloadAMDX) payload;
opNodePayloadArrayLengthAMDX : idResult Equals Op (NodePayloadArrayLengthAMDX idResultType | SpecConstantOp idResultType NodePayloadArrayLengthAMDX) payloadArray;
opIsNodePayloadValidAMDX : idResult Equals Op (IsNodePayloadValidAMDX idResultType | SpecConstantOp idResultType IsNodePayloadValidAMDX) payloadType nodeIndex;
opConstantStringAMDX : idResult Equals Op (ConstantStringAMDX  | SpecConstantOp  ConstantStringAMDX) literalStringLiteralString;
opSpecConstantStringAMDX : idResult Equals Op (SpecConstantStringAMDX  | SpecConstantOp  SpecConstantStringAMDX) literalStringLiteralString;
opHitObjectRecordHitMotionNV : Op HitObjectRecordHitMotionNV hitObject accelerationStructure instanceId primitiveId geometryIndex hitKind sBTRecordOffset sBTRecordStride origin tMin direction tMax currentTime hitObjectAttributes;
opHitObjectRecordHitWithIndexMotionNV : Op HitObjectRecordHitWithIndexMotionNV hitObject accelerationStructure instanceId primitiveId geometryIndex hitKind sBTRecordIndex origin tMin direction tMax currentTime hitObjectAttributes;
opHitObjectRecordMissMotionNV : Op HitObjectRecordMissMotionNV hitObject sBTIndex origin tMin direction tMax currentTime;
opHitObjectGetWorldToObjectNV : idResult Equals Op (HitObjectGetWorldToObjectNV idResultType | SpecConstantOp idResultType HitObjectGetWorldToObjectNV) hitObject;
opHitObjectGetObjectToWorldNV : idResult Equals Op (HitObjectGetObjectToWorldNV idResultType | SpecConstantOp idResultType HitObjectGetObjectToWorldNV) hitObject;
opHitObjectGetObjectRayDirectionNV : idResult Equals Op (HitObjectGetObjectRayDirectionNV idResultType | SpecConstantOp idResultType HitObjectGetObjectRayDirectionNV) hitObject;
opHitObjectGetObjectRayOriginNV : idResult Equals Op (HitObjectGetObjectRayOriginNV idResultType | SpecConstantOp idResultType HitObjectGetObjectRayOriginNV) hitObject;
opHitObjectTraceRayMotionNV : Op HitObjectTraceRayMotionNV hitObject accelerationStructure rayFlagsIdRef cullMask sBTRecordOffset sBTRecordStride missIndex origin tMin direction tMax time payload;
opHitObjectGetShaderRecordBufferHandleNV : idResult Equals Op (HitObjectGetShaderRecordBufferHandleNV idResultType | SpecConstantOp idResultType HitObjectGetShaderRecordBufferHandleNV) hitObject;
opHitObjectGetShaderBindingTableRecordIndexNV : idResult Equals Op (HitObjectGetShaderBindingTableRecordIndexNV idResultType | SpecConstantOp idResultType HitObjectGetShaderBindingTableRecordIndexNV) hitObject;
opHitObjectRecordEmptyNV : Op HitObjectRecordEmptyNV hitObject;
opHitObjectTraceRayNV : Op HitObjectTraceRayNV hitObject accelerationStructure rayFlagsIdRef cullMask sBTRecordOffset sBTRecordStride missIndex origin tMin direction tMax payload;
opHitObjectRecordHitNV : Op HitObjectRecordHitNV hitObject accelerationStructure instanceId primitiveId geometryIndex hitKind sBTRecordOffset sBTRecordStride origin tMin direction tMax hitObjectAttributes;
opHitObjectRecordHitWithIndexNV : Op HitObjectRecordHitWithIndexNV hitObject accelerationStructure instanceId primitiveId geometryIndex hitKind sBTRecordIndex origin tMin direction tMax hitObjectAttributes;
opHitObjectRecordMissNV : Op HitObjectRecordMissNV hitObject sBTIndex origin tMin direction tMax;
opHitObjectExecuteShaderNV : Op HitObjectExecuteShaderNV hitObject payload;
opHitObjectGetCurrentTimeNV : idResult Equals Op (HitObjectGetCurrentTimeNV idResultType | SpecConstantOp idResultType HitObjectGetCurrentTimeNV) hitObject;
opHitObjectGetAttributesNV : Op HitObjectGetAttributesNV hitObject hitObjectAttribute;
opHitObjectGetHitKindNV : idResult Equals Op (HitObjectGetHitKindNV idResultType | SpecConstantOp idResultType HitObjectGetHitKindNV) hitObject;
opHitObjectGetPrimitiveIndexNV : idResult Equals Op (HitObjectGetPrimitiveIndexNV idResultType | SpecConstantOp idResultType HitObjectGetPrimitiveIndexNV) hitObject;
opHitObjectGetGeometryIndexNV : idResult Equals Op (HitObjectGetGeometryIndexNV idResultType | SpecConstantOp idResultType HitObjectGetGeometryIndexNV) hitObject;
opHitObjectGetInstanceIdNV : idResult Equals Op (HitObjectGetInstanceIdNV idResultType | SpecConstantOp idResultType HitObjectGetInstanceIdNV) hitObject;
opHitObjectGetInstanceCustomIndexNV : idResult Equals Op (HitObjectGetInstanceCustomIndexNV idResultType | SpecConstantOp idResultType HitObjectGetInstanceCustomIndexNV) hitObject;
opHitObjectGetWorldRayDirectionNV : idResult Equals Op (HitObjectGetWorldRayDirectionNV idResultType | SpecConstantOp idResultType HitObjectGetWorldRayDirectionNV) hitObject;
opHitObjectGetWorldRayOriginNV : idResult Equals Op (HitObjectGetWorldRayOriginNV idResultType | SpecConstantOp idResultType HitObjectGetWorldRayOriginNV) hitObject;
opHitObjectGetRayTMaxNV : idResult Equals Op (HitObjectGetRayTMaxNV idResultType | SpecConstantOp idResultType HitObjectGetRayTMaxNV) hitObject;
opHitObjectGetRayTMinNV : idResult Equals Op (HitObjectGetRayTMinNV idResultType | SpecConstantOp idResultType HitObjectGetRayTMinNV) hitObject;
opHitObjectIsEmptyNV : idResult Equals Op (HitObjectIsEmptyNV idResultType | SpecConstantOp idResultType HitObjectIsEmptyNV) hitObject;
opHitObjectIsHitNV : idResult Equals Op (HitObjectIsHitNV idResultType | SpecConstantOp idResultType HitObjectIsHitNV) hitObject;
opHitObjectIsMissNV : idResult Equals Op (HitObjectIsMissNV idResultType | SpecConstantOp idResultType HitObjectIsMissNV) hitObject;
opReorderThreadWithHitObjectNV : Op ReorderThreadWithHitObjectNV hitObject (hint bits?)?;
opReorderThreadWithHintNV : Op ReorderThreadWithHintNV hint bits;
opCooperativeVectorMatrixMulNV : idResult Equals Op (CooperativeVectorMatrixMulNV idResultType | SpecConstantOp idResultType CooperativeVectorMatrixMulNV) input inputInterpretation matrix matrixOffset matrixInterpretation m k memoryLayout transpose matrixStrideIdRef? cooperativeMatrixOperands?;
opCooperativeVectorOuterProductAccumulateNV : Op CooperativeVectorOuterProductAccumulateNV pointer offsetIdRef a b memoryLayout matrixInterpretation matrixStrideIdRef?;
opCooperativeVectorReduceSumAccumulateNV : Op CooperativeVectorReduceSumAccumulateNV pointer offsetIdRef v;
opCooperativeVectorMatrixMulAddNV : idResult Equals Op (CooperativeVectorMatrixMulAddNV idResultType | SpecConstantOp idResultType CooperativeVectorMatrixMulAddNV) input inputInterpretation matrix matrixOffset matrixInterpretation bias biasOffset biasInterpretation m k memoryLayout transpose matrixStrideIdRef? cooperativeMatrixOperands?;
opEmitMeshTasksEXT : Op EmitMeshTasksEXT groupCountX groupCountY groupCountZ payload?;
opSetMeshOutputsEXT : Op SetMeshOutputsEXT vertexCountIdRef primitiveCountIdRef;
opWritePackedPrimitiveIndices4x8NV : Op WritePackedPrimitiveIndices4x8NV indexOffset packedIndices;
opFetchMicroTriangleVertexPositionNV : idResult Equals Op (FetchMicroTriangleVertexPositionNV idResultType | SpecConstantOp idResultType FetchMicroTriangleVertexPositionNV) accel instanceId geometryIndex primitiveIndex barycentric;
opFetchMicroTriangleVertexBarycentricNV : idResult Equals Op (FetchMicroTriangleVertexBarycentricNV idResultType | SpecConstantOp idResultType FetchMicroTriangleVertexBarycentricNV) accel instanceId geometryIndex primitiveIndex barycentric;
opReportIntersectionKHR : idResult Equals Op (ReportIntersectionKHR idResultType | SpecConstantOp idResultType ReportIntersectionKHR) hit hitKind;
opIgnoreIntersectionNV : Op IgnoreIntersectionNV;
opTerminateRayNV : Op TerminateRayNV;
opTraceNV : Op TraceNV accel rayFlagsIdRef cullMask sBTOffset sBTStride missIndex rayOrigin rayTmin rayDirection rayTmax payloadId;
opTraceMotionNV : Op TraceMotionNV accel rayFlagsIdRef cullMask sBTOffset sBTStride missIndex rayOrigin rayTmin rayDirection rayTmax time payloadId;
opTraceRayMotionNV : Op TraceRayMotionNV accel rayFlagsIdRef cullMask sBTOffset sBTStride missIndex rayOrigin rayTmin rayDirection rayTmax time payload;
opRayQueryGetIntersectionTriangleVertexPositionsKHR : idResult Equals Op (RayQueryGetIntersectionTriangleVertexPositionsKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionTriangleVertexPositionsKHR) rayQuery intersection;
opExecuteCallableNV : Op ExecuteCallableNV sBTIndex callableDataId;
opRayQueryGetClusterIdNV : idResult Equals Op (RayQueryGetClusterIdNV idResultType | SpecConstantOp idResultType RayQueryGetClusterIdNV) rayQuery intersection;
opHitObjectGetClusterIdNV : idResult Equals Op (HitObjectGetClusterIdNV idResultType | SpecConstantOp idResultType HitObjectGetClusterIdNV) hitObject;
opCooperativeMatrixLoadNV : idResult Equals Op (CooperativeMatrixLoadNV idResultType | SpecConstantOp idResultType CooperativeMatrixLoadNV) pointer stride columnMajor memoryAccess?;
opCooperativeMatrixStoreNV : Op CooperativeMatrixStoreNV pointer object stride columnMajor memoryAccess?;
opCooperativeMatrixMulAddNV : idResult Equals Op (CooperativeMatrixMulAddNV idResultType | SpecConstantOp idResultType CooperativeMatrixMulAddNV) a b c;
opCooperativeMatrixLengthNV : idResult Equals Op (CooperativeMatrixLengthNV idResultType | SpecConstantOp idResultType CooperativeMatrixLengthNV) type;
opBeginInvocationInterlockEXT : Op BeginInvocationInterlockEXT;
opEndInvocationInterlockEXT : Op EndInvocationInterlockEXT;
opCreateTensorLayoutNV : idResult Equals Op (CreateTensorLayoutNV idResultType | SpecConstantOp idResultType CreateTensorLayoutNV);
opTensorLayoutSetDimensionNV : idResult Equals Op (TensorLayoutSetDimensionNV idResultType | SpecConstantOp idResultType TensorLayoutSetDimensionNV) tensorLayout dimIdRef*;
opTensorLayoutSetStrideNV : idResult Equals Op (TensorLayoutSetStrideNV idResultType | SpecConstantOp idResultType TensorLayoutSetStrideNV) tensorLayout stride*;
opTensorLayoutSliceNV : idResult Equals Op (TensorLayoutSliceNV idResultType | SpecConstantOp idResultType TensorLayoutSliceNV) tensorLayout operands*;
opTensorLayoutSetClampValueNV : idResult Equals Op (TensorLayoutSetClampValueNV idResultType | SpecConstantOp idResultType TensorLayoutSetClampValueNV) tensorLayout valueIdRef;
opCreateTensorViewNV : idResult Equals Op (CreateTensorViewNV idResultType | SpecConstantOp idResultType CreateTensorViewNV);
opTensorViewSetDimensionNV : idResult Equals Op (TensorViewSetDimensionNV idResultType | SpecConstantOp idResultType TensorViewSetDimensionNV) tensorView dimIdRef*;
opTensorViewSetStrideNV : idResult Equals Op (TensorViewSetStrideNV idResultType | SpecConstantOp idResultType TensorViewSetStrideNV) tensorView stride*;
opIsHelperInvocationEXT : idResult Equals Op (IsHelperInvocationEXT idResultType | SpecConstantOp idResultType IsHelperInvocationEXT);
opTensorViewSetClipNV : idResult Equals Op (TensorViewSetClipNV idResultType | SpecConstantOp idResultType TensorViewSetClipNV) tensorView clipRowOffset clipRowSpan clipColOffset clipColSpan;
opTensorLayoutSetBlockSizeNV : idResult Equals Op (TensorLayoutSetBlockSizeNV idResultType | SpecConstantOp idResultType TensorLayoutSetBlockSizeNV) tensorLayout blockSize*;
opConvertUToImageNV : idResult Equals Op (ConvertUToImageNV idResultType | SpecConstantOp idResultType ConvertUToImageNV) operand;
opConvertUToSamplerNV : idResult Equals Op (ConvertUToSamplerNV idResultType | SpecConstantOp idResultType ConvertUToSamplerNV) operand;
opConvertImageToUNV : idResult Equals Op (ConvertImageToUNV idResultType | SpecConstantOp idResultType ConvertImageToUNV) operand;
opConvertSamplerToUNV : idResult Equals Op (ConvertSamplerToUNV idResultType | SpecConstantOp idResultType ConvertSamplerToUNV) operand;
opConvertUToSampledImageNV : idResult Equals Op (ConvertUToSampledImageNV idResultType | SpecConstantOp idResultType ConvertUToSampledImageNV) operand;
opConvertSampledImageToUNV : idResult Equals Op (ConvertSampledImageToUNV idResultType | SpecConstantOp idResultType ConvertSampledImageToUNV) operand;
opSamplerImageAddressingModeNV : Op SamplerImageAddressingModeNV bitWidth;
opRayQueryGetIntersectionSpherePositionNV : idResult Equals Op (RayQueryGetIntersectionSpherePositionNV idResultType | SpecConstantOp idResultType RayQueryGetIntersectionSpherePositionNV) rayQuery intersection;
opRayQueryGetIntersectionSphereRadiusNV : idResult Equals Op (RayQueryGetIntersectionSphereRadiusNV idResultType | SpecConstantOp idResultType RayQueryGetIntersectionSphereRadiusNV) rayQuery intersection;
opRayQueryGetIntersectionLSSPositionsNV : idResult Equals Op (RayQueryGetIntersectionLSSPositionsNV idResultType | SpecConstantOp idResultType RayQueryGetIntersectionLSSPositionsNV) rayQuery intersection;
opRayQueryGetIntersectionLSSRadiiNV : idResult Equals Op (RayQueryGetIntersectionLSSRadiiNV idResultType | SpecConstantOp idResultType RayQueryGetIntersectionLSSRadiiNV) rayQuery intersection;
opRayQueryGetIntersectionLSSHitValueNV : idResult Equals Op (RayQueryGetIntersectionLSSHitValueNV idResultType | SpecConstantOp idResultType RayQueryGetIntersectionLSSHitValueNV) rayQuery intersection;
opHitObjectGetSpherePositionNV : idResult Equals Op (HitObjectGetSpherePositionNV idResultType | SpecConstantOp idResultType HitObjectGetSpherePositionNV) hitObject;
opHitObjectGetSphereRadiusNV : idResult Equals Op (HitObjectGetSphereRadiusNV idResultType | SpecConstantOp idResultType HitObjectGetSphereRadiusNV) hitObject;
opHitObjectGetLSSPositionsNV : idResult Equals Op (HitObjectGetLSSPositionsNV idResultType | SpecConstantOp idResultType HitObjectGetLSSPositionsNV) hitObject;
opHitObjectGetLSSRadiiNV : idResult Equals Op (HitObjectGetLSSRadiiNV idResultType | SpecConstantOp idResultType HitObjectGetLSSRadiiNV) hitObject;
opHitObjectIsSphereHitNV : idResult Equals Op (HitObjectIsSphereHitNV idResultType | SpecConstantOp idResultType HitObjectIsSphereHitNV) hitObject;
opHitObjectIsLSSHitNV : idResult Equals Op (HitObjectIsLSSHitNV idResultType | SpecConstantOp idResultType HitObjectIsLSSHitNV) hitObject;
opRayQueryIsSphereHitNV : idResult Equals Op (RayQueryIsSphereHitNV idResultType | SpecConstantOp idResultType RayQueryIsSphereHitNV) rayQuery intersection;
opRayQueryIsLSSHitNV : idResult Equals Op (RayQueryIsLSSHitNV idResultType | SpecConstantOp idResultType RayQueryIsLSSHitNV) rayQuery intersection;
opUCountLeadingZerosINTEL : idResult Equals Op (UCountLeadingZerosINTEL idResultType | SpecConstantOp idResultType UCountLeadingZerosINTEL) operand;
opUCountTrailingZerosINTEL : idResult Equals Op (UCountTrailingZerosINTEL idResultType | SpecConstantOp idResultType UCountTrailingZerosINTEL) operand;
opAbsISubINTEL : idResult Equals Op (AbsISubINTEL idResultType | SpecConstantOp idResultType AbsISubINTEL) operand1 operand2;
opAbsUSubINTEL : idResult Equals Op (AbsUSubINTEL idResultType | SpecConstantOp idResultType AbsUSubINTEL) operand1 operand2;
opIAddSatINTEL : idResult Equals Op (IAddSatINTEL idResultType | SpecConstantOp idResultType IAddSatINTEL) operand1 operand2;
opUAddSatINTEL : idResult Equals Op (UAddSatINTEL idResultType | SpecConstantOp idResultType UAddSatINTEL) operand1 operand2;
opIAverageINTEL : idResult Equals Op (IAverageINTEL idResultType | SpecConstantOp idResultType IAverageINTEL) operand1 operand2;
opUAverageINTEL : idResult Equals Op (UAverageINTEL idResultType | SpecConstantOp idResultType UAverageINTEL) operand1 operand2;
opIAverageRoundedINTEL : idResult Equals Op (IAverageRoundedINTEL idResultType | SpecConstantOp idResultType IAverageRoundedINTEL) operand1 operand2;
opUAverageRoundedINTEL : idResult Equals Op (UAverageRoundedINTEL idResultType | SpecConstantOp idResultType UAverageRoundedINTEL) operand1 operand2;
opISubSatINTEL : idResult Equals Op (ISubSatINTEL idResultType | SpecConstantOp idResultType ISubSatINTEL) operand1 operand2;
opUSubSatINTEL : idResult Equals Op (USubSatINTEL idResultType | SpecConstantOp idResultType USubSatINTEL) operand1 operand2;
opIMul32x16INTEL : idResult Equals Op (IMul32x16INTEL idResultType | SpecConstantOp idResultType IMul32x16INTEL) operand1 operand2;
opUMul32x16INTEL : idResult Equals Op (UMul32x16INTEL idResultType | SpecConstantOp idResultType UMul32x16INTEL) operand1 operand2;
opLoopControlINTEL : Op LoopControlINTEL loopControlParameters*;
opFPGARegINTEL : idResult Equals Op (FPGARegINTEL idResultType | SpecConstantOp idResultType FPGARegINTEL) result input;
opRayQueryGetRayTMinKHR : idResult Equals Op (RayQueryGetRayTMinKHR idResultType | SpecConstantOp idResultType RayQueryGetRayTMinKHR) rayQuery;
opRayQueryGetRayFlagsKHR : idResult Equals Op (RayQueryGetRayFlagsKHR idResultType | SpecConstantOp idResultType RayQueryGetRayFlagsKHR) rayQuery;
opRayQueryGetIntersectionTKHR : idResult Equals Op (RayQueryGetIntersectionTKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionTKHR) rayQuery intersection;
opRayQueryGetIntersectionInstanceCustomIndexKHR : idResult Equals Op (RayQueryGetIntersectionInstanceCustomIndexKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionInstanceCustomIndexKHR) rayQuery intersection;
opRayQueryGetIntersectionInstanceIdKHR : idResult Equals Op (RayQueryGetIntersectionInstanceIdKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionInstanceIdKHR) rayQuery intersection;
opRayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR : idResult Equals Op (RayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR) rayQuery intersection;
opRayQueryGetIntersectionGeometryIndexKHR : idResult Equals Op (RayQueryGetIntersectionGeometryIndexKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionGeometryIndexKHR) rayQuery intersection;
opRayQueryGetIntersectionPrimitiveIndexKHR : idResult Equals Op (RayQueryGetIntersectionPrimitiveIndexKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionPrimitiveIndexKHR) rayQuery intersection;
opRayQueryGetIntersectionBarycentricsKHR : idResult Equals Op (RayQueryGetIntersectionBarycentricsKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionBarycentricsKHR) rayQuery intersection;
opRayQueryGetIntersectionFrontFaceKHR : idResult Equals Op (RayQueryGetIntersectionFrontFaceKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionFrontFaceKHR) rayQuery intersection;
opRayQueryGetIntersectionCandidateAABBOpaqueKHR : idResult Equals Op (RayQueryGetIntersectionCandidateAABBOpaqueKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionCandidateAABBOpaqueKHR) rayQuery;
opRayQueryGetIntersectionObjectRayDirectionKHR : idResult Equals Op (RayQueryGetIntersectionObjectRayDirectionKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionObjectRayDirectionKHR) rayQuery intersection;
opRayQueryGetIntersectionObjectRayOriginKHR : idResult Equals Op (RayQueryGetIntersectionObjectRayOriginKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionObjectRayOriginKHR) rayQuery intersection;
opRayQueryGetWorldRayDirectionKHR : idResult Equals Op (RayQueryGetWorldRayDirectionKHR idResultType | SpecConstantOp idResultType RayQueryGetWorldRayDirectionKHR) rayQuery;
opRayQueryGetWorldRayOriginKHR : idResult Equals Op (RayQueryGetWorldRayOriginKHR idResultType | SpecConstantOp idResultType RayQueryGetWorldRayOriginKHR) rayQuery;
opRayQueryGetIntersectionObjectToWorldKHR : idResult Equals Op (RayQueryGetIntersectionObjectToWorldKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionObjectToWorldKHR) rayQuery intersection;
opRayQueryGetIntersectionWorldToObjectKHR : idResult Equals Op (RayQueryGetIntersectionWorldToObjectKHR idResultType | SpecConstantOp idResultType RayQueryGetIntersectionWorldToObjectKHR) rayQuery intersection;

// Type-Declaration Operations
opTypeVoid : idResult Equals Op (TypeVoid  | SpecConstantOp  TypeVoid);
opTypeBool : idResult Equals Op (TypeBool  | SpecConstantOp  TypeBool);
opTypeInt : idResult Equals Op (TypeInt  | SpecConstantOp  TypeInt) widthLiteralInteger signedness;
opTypeFloat : idResult Equals Op (TypeFloat  | SpecConstantOp  TypeFloat) widthLiteralInteger;
opTypeVector : idResult Equals Op (TypeVector  | SpecConstantOp  TypeVector) componentTypeIdRef componentCountLiteralInteger;
opTypeMatrix : idResult Equals Op (TypeMatrix  | SpecConstantOp  TypeMatrix) columnType columnCount;
opTypeImage : idResult Equals Op (TypeImage  | SpecConstantOp  TypeImage) sampledType dim depthLiteralInteger arrayed mS sampled imageFormat accessQualifier?;
opTypeSampler : idResult Equals Op (TypeSampler  | SpecConstantOp  TypeSampler);
opTypeSampledImage : idResult Equals Op (TypeSampledImage  | SpecConstantOp  TypeSampledImage) imageType;
opTypeArray : idResult Equals Op (TypeArray  | SpecConstantOp  TypeArray) elementType lengthIdRef;
opTypeRuntimeArray : idResult Equals Op (TypeRuntimeArray  | SpecConstantOp  TypeRuntimeArray) elementType;
opTypeStruct : idResult Equals Op (TypeStruct  | SpecConstantOp  TypeStruct) memberType*;
opTypeOpaque : idResult Equals Op (TypeOpaque  | SpecConstantOp  TypeOpaque) theNameOfTheOpaqueType;
opTypePointer : idResult Equals Op (TypePointer  | SpecConstantOp  TypePointer) storageClass type;
opTypeFunction : idResult Equals Op (TypeFunction  | SpecConstantOp  TypeFunction) returnType parameterType*;
opTypeEvent : idResult Equals Op (TypeEvent  | SpecConstantOp  TypeEvent);
opTypeDeviceEvent : idResult Equals Op (TypeDeviceEvent  | SpecConstantOp  TypeDeviceEvent);
opTypeReserveId : idResult Equals Op (TypeReserveId  | SpecConstantOp  TypeReserveId);
opTypeQueue : idResult Equals Op (TypeQueue  | SpecConstantOp  TypeQueue);
opTypePipe : idResult Equals Op (TypePipe  | SpecConstantOp  TypePipe) qualifier;
opTypeForwardPointer : Op TypeForwardPointer pointerType storageClass;
opTypePipeStorage : idResult Equals Op (TypePipeStorage  | SpecConstantOp  TypePipeStorage);
opTypeNamedBarrier : idResult Equals Op (TypeNamedBarrier  | SpecConstantOp  TypeNamedBarrier);
opTypeUntypedPointerKHR : idResult Equals Op (TypeUntypedPointerKHR  | SpecConstantOp  TypeUntypedPointerKHR) storageClass;
opTypeCooperativeMatrixKHR : idResult Equals Op (TypeCooperativeMatrixKHR  | SpecConstantOp  TypeCooperativeMatrixKHR) componentTypeIdRef scopeIdScope rows columns use;
opTypeRayQueryKHR : idResult Equals Op (TypeRayQueryKHR  | SpecConstantOp  TypeRayQueryKHR);
opTypeHitObjectNV : idResult Equals Op (TypeHitObjectNV  | SpecConstantOp  TypeHitObjectNV);
opTypeCooperativeVectorNV : idResult Equals Op (TypeCooperativeVectorNV  | SpecConstantOp  TypeCooperativeVectorNV) componentTypeIdRef componentCountIdRef;
opTypeAccelerationStructureKHR : idResult Equals Op (TypeAccelerationStructureKHR  | SpecConstantOp  TypeAccelerationStructureKHR);
opTypeCooperativeMatrixNV : idResult Equals Op (TypeCooperativeMatrixNV  | SpecConstantOp  TypeCooperativeMatrixNV) componentTypeIdRef execution rows columns;
opTypeTensorLayoutNV : idResult Equals Op (TypeTensorLayoutNV  | SpecConstantOp  TypeTensorLayoutNV) dimIdRef clampMode;
opTypeTensorViewNV : idResult Equals Op (TypeTensorViewNV  | SpecConstantOp  TypeTensorViewNV) dimIdRef hasDimensions p*;
opTypeBufferSurfaceINTEL : idResult Equals Op (TypeBufferSurfaceINTEL  | SpecConstantOp  TypeBufferSurfaceINTEL) accessQualifierAccessQualifier;
opTypeStructContinuedINTEL : Op TypeStructContinuedINTEL memberType*;

// exclude Operations
opConstantFunctionPointerINTEL : idResult Equals Op (ConstantFunctionPointerINTEL idResultType | SpecConstantOp idResultType ConstantFunctionPointerINTEL) function;
opFunctionPointerCallINTEL : idResult Equals Op (FunctionPointerCallINTEL idResultType | SpecConstantOp idResultType FunctionPointerCallINTEL) operand1*;
opAsmTargetINTEL : idResult Equals Op (AsmTargetINTEL  | SpecConstantOp  AsmTargetINTEL) asmTarget;
opAsmINTEL : idResult Equals Op (AsmINTEL idResultType | SpecConstantOp idResultType AsmINTEL) asmType targetIdRef asmInstructions constraints;
opAsmCallINTEL : idResult Equals Op (AsmCallINTEL idResultType | SpecConstantOp idResultType AsmCallINTEL) asm argument0*;
opVmeImageINTEL : idResult Equals Op (VmeImageINTEL idResultType | SpecConstantOp idResultType VmeImageINTEL) imageType sampler;
opTypeVmeImageINTEL : idResult Equals Op (TypeVmeImageINTEL  | SpecConstantOp  TypeVmeImageINTEL) imageType;
opTypeAvcImePayloadINTEL : idResult Equals Op (TypeAvcImePayloadINTEL  | SpecConstantOp  TypeAvcImePayloadINTEL);
opTypeAvcRefPayloadINTEL : idResult Equals Op (TypeAvcRefPayloadINTEL  | SpecConstantOp  TypeAvcRefPayloadINTEL);
opTypeAvcSicPayloadINTEL : idResult Equals Op (TypeAvcSicPayloadINTEL  | SpecConstantOp  TypeAvcSicPayloadINTEL);
opTypeAvcMcePayloadINTEL : idResult Equals Op (TypeAvcMcePayloadINTEL  | SpecConstantOp  TypeAvcMcePayloadINTEL);
opTypeAvcMceResultINTEL : idResult Equals Op (TypeAvcMceResultINTEL  | SpecConstantOp  TypeAvcMceResultINTEL);
opTypeAvcImeResultINTEL : idResult Equals Op (TypeAvcImeResultINTEL  | SpecConstantOp  TypeAvcImeResultINTEL);
opTypeAvcImeResultSingleReferenceStreamoutINTEL : idResult Equals Op (TypeAvcImeResultSingleReferenceStreamoutINTEL  | SpecConstantOp  TypeAvcImeResultSingleReferenceStreamoutINTEL);
opTypeAvcImeResultDualReferenceStreamoutINTEL : idResult Equals Op (TypeAvcImeResultDualReferenceStreamoutINTEL  | SpecConstantOp  TypeAvcImeResultDualReferenceStreamoutINTEL);
opTypeAvcImeSingleReferenceStreaminINTEL : idResult Equals Op (TypeAvcImeSingleReferenceStreaminINTEL  | SpecConstantOp  TypeAvcImeSingleReferenceStreaminINTEL);
opTypeAvcImeDualReferenceStreaminINTEL : idResult Equals Op (TypeAvcImeDualReferenceStreaminINTEL  | SpecConstantOp  TypeAvcImeDualReferenceStreaminINTEL);
opTypeAvcRefResultINTEL : idResult Equals Op (TypeAvcRefResultINTEL  | SpecConstantOp  TypeAvcRefResultINTEL);
opTypeAvcSicResultINTEL : idResult Equals Op (TypeAvcSicResultINTEL  | SpecConstantOp  TypeAvcSicResultINTEL);
opSubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL) sliceType qp;
opSubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL : idResult Equals Op (SubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL) referenceBasePenalty payload;
opSubgroupAvcMceGetDefaultInterShapePenaltyINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultInterShapePenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultInterShapePenaltyINTEL) sliceType qp;
opSubgroupAvcMceSetInterShapePenaltyINTEL : idResult Equals Op (SubgroupAvcMceSetInterShapePenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceSetInterShapePenaltyINTEL) packedShapePenalty payload;
opSubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL) sliceType qp;
opSubgroupAvcMceSetInterDirectionPenaltyINTEL : idResult Equals Op (SubgroupAvcMceSetInterDirectionPenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceSetInterDirectionPenaltyINTEL) directionCost payload;
opSubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL) sliceType qp;
opSubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL) sliceType qp;
opSubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL);
opSubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL);
opSubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL);
opSubgroupAvcMceSetMotionVectorCostFunctionINTEL : idResult Equals Op (SubgroupAvcMceSetMotionVectorCostFunctionINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceSetMotionVectorCostFunctionINTEL) packedCostCenterDelta packedCostTable costPrecision payload;
opSubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL) sliceType qp;
opSubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL);
opSubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL : idResult Equals Op (SubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL);
opSubgroupAvcMceSetAcOnlyHaarINTEL : idResult Equals Op (SubgroupAvcMceSetAcOnlyHaarINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceSetAcOnlyHaarINTEL) payload;
opSubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL : idResult Equals Op (SubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL) sourceFieldPolarity payload;
opSubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL : idResult Equals Op (SubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL) referenceFieldPolarity payload;
opSubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL : idResult Equals Op (SubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL) forwardReferenceFieldPolarity backwardReferenceFieldPolarity payload;
opSubgroupAvcMceConvertToImePayloadINTEL : idResult Equals Op (SubgroupAvcMceConvertToImePayloadINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceConvertToImePayloadINTEL) payload;
opSubgroupAvcMceConvertToImeResultINTEL : idResult Equals Op (SubgroupAvcMceConvertToImeResultINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceConvertToImeResultINTEL) payload;
opSubgroupAvcMceConvertToRefPayloadINTEL : idResult Equals Op (SubgroupAvcMceConvertToRefPayloadINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceConvertToRefPayloadINTEL) payload;
opSubgroupAvcMceConvertToRefResultINTEL : idResult Equals Op (SubgroupAvcMceConvertToRefResultINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceConvertToRefResultINTEL) payload;
opSubgroupAvcMceConvertToSicPayloadINTEL : idResult Equals Op (SubgroupAvcMceConvertToSicPayloadINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceConvertToSicPayloadINTEL) payload;
opSubgroupAvcMceConvertToSicResultINTEL : idResult Equals Op (SubgroupAvcMceConvertToSicResultINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceConvertToSicResultINTEL) payload;
opSubgroupAvcMceGetMotionVectorsINTEL : idResult Equals Op (SubgroupAvcMceGetMotionVectorsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetMotionVectorsINTEL) payload;
opSubgroupAvcMceGetInterDistortionsINTEL : idResult Equals Op (SubgroupAvcMceGetInterDistortionsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetInterDistortionsINTEL) payload;
opSubgroupAvcMceGetBestInterDistortionsINTEL : idResult Equals Op (SubgroupAvcMceGetBestInterDistortionsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetBestInterDistortionsINTEL) payload;
opSubgroupAvcMceGetInterMajorShapeINTEL : idResult Equals Op (SubgroupAvcMceGetInterMajorShapeINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetInterMajorShapeINTEL) payload;
opSubgroupAvcMceGetInterMinorShapeINTEL : idResult Equals Op (SubgroupAvcMceGetInterMinorShapeINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetInterMinorShapeINTEL) payload;
opSubgroupAvcMceGetInterDirectionsINTEL : idResult Equals Op (SubgroupAvcMceGetInterDirectionsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetInterDirectionsINTEL) payload;
opSubgroupAvcMceGetInterMotionVectorCountINTEL : idResult Equals Op (SubgroupAvcMceGetInterMotionVectorCountINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetInterMotionVectorCountINTEL) payload;
opSubgroupAvcMceGetInterReferenceIdsINTEL : idResult Equals Op (SubgroupAvcMceGetInterReferenceIdsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetInterReferenceIdsINTEL) payload;
opSubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL : idResult Equals Op (SubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL idResultType | SpecConstantOp idResultType SubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL) packedReferenceIds packedReferenceParameterFieldPolarities payload;
opSubgroupAvcImeInitializeINTEL : idResult Equals Op (SubgroupAvcImeInitializeINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeInitializeINTEL) srcCoord partitionMask sADAdjustment;
opSubgroupAvcImeSetSingleReferenceINTEL : idResult Equals Op (SubgroupAvcImeSetSingleReferenceINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeSetSingleReferenceINTEL) refOffset searchWindowConfig payload;
opSubgroupAvcImeSetDualReferenceINTEL : idResult Equals Op (SubgroupAvcImeSetDualReferenceINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeSetDualReferenceINTEL) fwdRefOffset bwdRefOffset id payload;
opSubgroupAvcImeRefWindowSizeINTEL : idResult Equals Op (SubgroupAvcImeRefWindowSizeINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeRefWindowSizeINTEL) searchWindowConfig dualRef;
opSubgroupAvcImeAdjustRefOffsetINTEL : idResult Equals Op (SubgroupAvcImeAdjustRefOffsetINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeAdjustRefOffsetINTEL) refOffset srcCoord refWindowSize imageSize;
opSubgroupAvcImeConvertToMcePayloadINTEL : idResult Equals Op (SubgroupAvcImeConvertToMcePayloadINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeConvertToMcePayloadINTEL) payload;
opSubgroupAvcImeSetMaxMotionVectorCountINTEL : idResult Equals Op (SubgroupAvcImeSetMaxMotionVectorCountINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeSetMaxMotionVectorCountINTEL) maxMotionVectorCount payload;
opSubgroupAvcImeSetUnidirectionalMixDisableINTEL : idResult Equals Op (SubgroupAvcImeSetUnidirectionalMixDisableINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeSetUnidirectionalMixDisableINTEL) payload;
opSubgroupAvcImeSetEarlySearchTerminationThresholdINTEL : idResult Equals Op (SubgroupAvcImeSetEarlySearchTerminationThresholdINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeSetEarlySearchTerminationThresholdINTEL) threshold payload;
opSubgroupAvcImeSetWeightedSadINTEL : idResult Equals Op (SubgroupAvcImeSetWeightedSadINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeSetWeightedSadINTEL) packedSadWeights payload;
opSubgroupAvcImeEvaluateWithSingleReferenceINTEL : idResult Equals Op (SubgroupAvcImeEvaluateWithSingleReferenceINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeEvaluateWithSingleReferenceINTEL) srcImage refImage payload;
opSubgroupAvcImeEvaluateWithDualReferenceINTEL : idResult Equals Op (SubgroupAvcImeEvaluateWithDualReferenceINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeEvaluateWithDualReferenceINTEL) srcImage fwdRefImage bwdRefImage payload;
opSubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL : idResult Equals Op (SubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL) srcImage refImage payload streaminComponents;
opSubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL : idResult Equals Op (SubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL) srcImage fwdRefImage bwdRefImage payload streaminComponents;
opSubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL : idResult Equals Op (SubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL) srcImage refImage payload;
opSubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL : idResult Equals Op (SubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL) srcImage fwdRefImage bwdRefImage payload;
opSubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL : idResult Equals Op (SubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL) srcImage refImage payload streaminComponents;
opSubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL : idResult Equals Op (SubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL) srcImage fwdRefImage bwdRefImage payload streaminComponents;
opSubgroupAvcImeConvertToMceResultINTEL : idResult Equals Op (SubgroupAvcImeConvertToMceResultINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeConvertToMceResultINTEL) payload;
opSubgroupAvcImeGetSingleReferenceStreaminINTEL : idResult Equals Op (SubgroupAvcImeGetSingleReferenceStreaminINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetSingleReferenceStreaminINTEL) payload;
opSubgroupAvcImeGetDualReferenceStreaminINTEL : idResult Equals Op (SubgroupAvcImeGetDualReferenceStreaminINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetDualReferenceStreaminINTEL) payload;
opSubgroupAvcImeStripSingleReferenceStreamoutINTEL : idResult Equals Op (SubgroupAvcImeStripSingleReferenceStreamoutINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeStripSingleReferenceStreamoutINTEL) payload;
opSubgroupAvcImeStripDualReferenceStreamoutINTEL : idResult Equals Op (SubgroupAvcImeStripDualReferenceStreamoutINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeStripDualReferenceStreamoutINTEL) payload;
opSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL : idResult Equals Op (SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL) payload majorShape;
opSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL : idResult Equals Op (SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL) payload majorShape;
opSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL : idResult Equals Op (SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL) payload majorShape;
opSubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL : idResult Equals Op (SubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL) payload majorShape direction;
opSubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL : idResult Equals Op (SubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL) payload majorShape direction;
opSubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL : idResult Equals Op (SubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL) payload majorShape direction;
opSubgroupAvcImeGetBorderReachedINTEL : idResult Equals Op (SubgroupAvcImeGetBorderReachedINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetBorderReachedINTEL) imageSelect payload;
opSubgroupAvcImeGetTruncatedSearchIndicationINTEL : idResult Equals Op (SubgroupAvcImeGetTruncatedSearchIndicationINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetTruncatedSearchIndicationINTEL) payload;
opSubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL : idResult Equals Op (SubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL) payload;
opSubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL : idResult Equals Op (SubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL) payload;
opSubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL : idResult Equals Op (SubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL idResultType | SpecConstantOp idResultType SubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL) payload;
opSubgroupAvcFmeInitializeINTEL : idResult Equals Op (SubgroupAvcFmeInitializeINTEL idResultType | SpecConstantOp idResultType SubgroupAvcFmeInitializeINTEL) srcCoord motionVectors majorShapes minorShapes direction pixelResolution sADAdjustment;
opSubgroupAvcBmeInitializeINTEL : idResult Equals Op (SubgroupAvcBmeInitializeINTEL idResultType | SpecConstantOp idResultType SubgroupAvcBmeInitializeINTEL) srcCoord motionVectors majorShapes minorShapes direction pixelResolution bidirectionalWeight sADAdjustment;
opSubgroupAvcRefConvertToMcePayloadINTEL : idResult Equals Op (SubgroupAvcRefConvertToMcePayloadINTEL idResultType | SpecConstantOp idResultType SubgroupAvcRefConvertToMcePayloadINTEL) payload;
opSubgroupAvcRefSetBidirectionalMixDisableINTEL : idResult Equals Op (SubgroupAvcRefSetBidirectionalMixDisableINTEL idResultType | SpecConstantOp idResultType SubgroupAvcRefSetBidirectionalMixDisableINTEL) payload;
opSubgroupAvcRefSetBilinearFilterEnableINTEL : idResult Equals Op (SubgroupAvcRefSetBilinearFilterEnableINTEL idResultType | SpecConstantOp idResultType SubgroupAvcRefSetBilinearFilterEnableINTEL) payload;
opSubgroupAvcRefEvaluateWithSingleReferenceINTEL : idResult Equals Op (SubgroupAvcRefEvaluateWithSingleReferenceINTEL idResultType | SpecConstantOp idResultType SubgroupAvcRefEvaluateWithSingleReferenceINTEL) srcImage refImage payload;
opSubgroupAvcRefEvaluateWithDualReferenceINTEL : idResult Equals Op (SubgroupAvcRefEvaluateWithDualReferenceINTEL idResultType | SpecConstantOp idResultType SubgroupAvcRefEvaluateWithDualReferenceINTEL) srcImage fwdRefImage bwdRefImage payload;
opSubgroupAvcRefEvaluateWithMultiReferenceINTEL : idResult Equals Op (SubgroupAvcRefEvaluateWithMultiReferenceINTEL idResultType | SpecConstantOp idResultType SubgroupAvcRefEvaluateWithMultiReferenceINTEL) srcImage packedReferenceIds payload;
opSubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL : idResult Equals Op (SubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL idResultType | SpecConstantOp idResultType SubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL) srcImage packedReferenceIds packedReferenceFieldPolarities payload;
opSubgroupAvcRefConvertToMceResultINTEL : idResult Equals Op (SubgroupAvcRefConvertToMceResultINTEL idResultType | SpecConstantOp idResultType SubgroupAvcRefConvertToMceResultINTEL) payload;
opSubgroupAvcSicInitializeINTEL : idResult Equals Op (SubgroupAvcSicInitializeINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicInitializeINTEL) srcCoord;
opSubgroupAvcSicConfigureSkcINTEL : idResult Equals Op (SubgroupAvcSicConfigureSkcINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicConfigureSkcINTEL) skipBlockPartitionType skipMotionVectorMask motionVectors bidirectionalWeight sADAdjustment payload;
opSubgroupAvcSicConfigureIpeLumaINTEL : idResult Equals Op (SubgroupAvcSicConfigureIpeLumaINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicConfigureIpeLumaINTEL) lumaIntraPartitionMask intraNeighbourAvailabilty leftEdgeLumaPixels upperLeftCornerLumaPixel upperEdgeLumaPixels upperRightEdgeLumaPixels sADAdjustment payload;
opSubgroupAvcSicConfigureIpeLumaChromaINTEL : idResult Equals Op (SubgroupAvcSicConfigureIpeLumaChromaINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicConfigureIpeLumaChromaINTEL) lumaIntraPartitionMask intraNeighbourAvailabilty leftEdgeLumaPixels upperLeftCornerLumaPixel upperEdgeLumaPixels upperRightEdgeLumaPixels leftEdgeChromaPixels upperLeftCornerChromaPixel upperEdgeChromaPixels sADAdjustment payload;
opSubgroupAvcSicGetMotionVectorMaskINTEL : idResult Equals Op (SubgroupAvcSicGetMotionVectorMaskINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicGetMotionVectorMaskINTEL) skipBlockPartitionType direction;
opSubgroupAvcSicConvertToMcePayloadINTEL : idResult Equals Op (SubgroupAvcSicConvertToMcePayloadINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicConvertToMcePayloadINTEL) payload;
opSubgroupAvcSicSetIntraLumaShapePenaltyINTEL : idResult Equals Op (SubgroupAvcSicSetIntraLumaShapePenaltyINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicSetIntraLumaShapePenaltyINTEL) packedShapePenalty payload;
opSubgroupAvcSicSetIntraLumaModeCostFunctionINTEL : idResult Equals Op (SubgroupAvcSicSetIntraLumaModeCostFunctionINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicSetIntraLumaModeCostFunctionINTEL) lumaModePenalty lumaPackedNeighborModes lumaPackedNonDcPenalty payload;
opSubgroupAvcSicSetIntraChromaModeCostFunctionINTEL : idResult Equals Op (SubgroupAvcSicSetIntraChromaModeCostFunctionINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicSetIntraChromaModeCostFunctionINTEL) chromaModeBasePenalty payload;
opSubgroupAvcSicSetBilinearFilterEnableINTEL : idResult Equals Op (SubgroupAvcSicSetBilinearFilterEnableINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicSetBilinearFilterEnableINTEL) payload;
opSubgroupAvcSicSetSkcForwardTransformEnableINTEL : idResult Equals Op (SubgroupAvcSicSetSkcForwardTransformEnableINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicSetSkcForwardTransformEnableINTEL) packedSadCoefficients payload;
opSubgroupAvcSicSetBlockBasedRawSkipSadINTEL : idResult Equals Op (SubgroupAvcSicSetBlockBasedRawSkipSadINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicSetBlockBasedRawSkipSadINTEL) blockBasedSkipType payload;
opSubgroupAvcSicEvaluateIpeINTEL : idResult Equals Op (SubgroupAvcSicEvaluateIpeINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicEvaluateIpeINTEL) srcImage payload;
opSubgroupAvcSicEvaluateWithSingleReferenceINTEL : idResult Equals Op (SubgroupAvcSicEvaluateWithSingleReferenceINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicEvaluateWithSingleReferenceINTEL) srcImage refImage payload;
opSubgroupAvcSicEvaluateWithDualReferenceINTEL : idResult Equals Op (SubgroupAvcSicEvaluateWithDualReferenceINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicEvaluateWithDualReferenceINTEL) srcImage fwdRefImage bwdRefImage payload;
opSubgroupAvcSicEvaluateWithMultiReferenceINTEL : idResult Equals Op (SubgroupAvcSicEvaluateWithMultiReferenceINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicEvaluateWithMultiReferenceINTEL) srcImage packedReferenceIds payload;
opSubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL : idResult Equals Op (SubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL) srcImage packedReferenceIds packedReferenceFieldPolarities payload;
opSubgroupAvcSicConvertToMceResultINTEL : idResult Equals Op (SubgroupAvcSicConvertToMceResultINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicConvertToMceResultINTEL) payload;
opSubgroupAvcSicGetIpeLumaShapeINTEL : idResult Equals Op (SubgroupAvcSicGetIpeLumaShapeINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicGetIpeLumaShapeINTEL) payload;
opSubgroupAvcSicGetBestIpeLumaDistortionINTEL : idResult Equals Op (SubgroupAvcSicGetBestIpeLumaDistortionINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicGetBestIpeLumaDistortionINTEL) payload;
opSubgroupAvcSicGetBestIpeChromaDistortionINTEL : idResult Equals Op (SubgroupAvcSicGetBestIpeChromaDistortionINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicGetBestIpeChromaDistortionINTEL) payload;
opSubgroupAvcSicGetPackedIpeLumaModesINTEL : idResult Equals Op (SubgroupAvcSicGetPackedIpeLumaModesINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicGetPackedIpeLumaModesINTEL) payload;
opSubgroupAvcSicGetIpeChromaModeINTEL : idResult Equals Op (SubgroupAvcSicGetIpeChromaModeINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicGetIpeChromaModeINTEL) payload;
opSubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL : idResult Equals Op (SubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL) payload;
opSubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL : idResult Equals Op (SubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL) payload;
opSubgroupAvcSicGetInterRawSadsINTEL : idResult Equals Op (SubgroupAvcSicGetInterRawSadsINTEL idResultType | SpecConstantOp idResultType SubgroupAvcSicGetInterRawSadsINTEL) payload;
opVariableLengthArrayINTEL : idResult Equals Op (VariableLengthArrayINTEL idResultType | SpecConstantOp idResultType VariableLengthArrayINTEL) lenght;
opSaveMemoryINTEL : idResult Equals Op (SaveMemoryINTEL idResultType | SpecConstantOp idResultType SaveMemoryINTEL);
opRestoreMemoryINTEL : Op RestoreMemoryINTEL ptr;
opArbitraryFloatSinCosPiINTEL : idResult Equals Op (ArbitraryFloatSinCosPiINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatSinCosPiINTEL) a m1 mout fromSign enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCastINTEL : idResult Equals Op (ArbitraryFloatCastINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatCastINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCastFromIntINTEL : idResult Equals Op (ArbitraryFloatCastFromIntINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatCastFromIntINTEL) a mout fromSign enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCastToIntINTEL : idResult Equals Op (ArbitraryFloatCastToIntINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatCastToIntINTEL) a m1 enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatAddINTEL : idResult Equals Op (ArbitraryFloatAddINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatAddINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatSubINTEL : idResult Equals Op (ArbitraryFloatSubINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatSubINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatMulINTEL : idResult Equals Op (ArbitraryFloatMulINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatMulINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatDivINTEL : idResult Equals Op (ArbitraryFloatDivINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatDivINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatGTINTEL : idResult Equals Op (ArbitraryFloatGTINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatGTINTEL) a m1 b m2;
opArbitraryFloatGEINTEL : idResult Equals Op (ArbitraryFloatGEINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatGEINTEL) a m1 b m2;
opArbitraryFloatLTINTEL : idResult Equals Op (ArbitraryFloatLTINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatLTINTEL) a m1 b m2;
opArbitraryFloatLEINTEL : idResult Equals Op (ArbitraryFloatLEINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatLEINTEL) a m1 b m2;
opArbitraryFloatEQINTEL : idResult Equals Op (ArbitraryFloatEQINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatEQINTEL) a m1 b m2;
opArbitraryFloatRecipINTEL : idResult Equals Op (ArbitraryFloatRecipINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatRecipINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatRSqrtINTEL : idResult Equals Op (ArbitraryFloatRSqrtINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatRSqrtINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCbrtINTEL : idResult Equals Op (ArbitraryFloatCbrtINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatCbrtINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatHypotINTEL : idResult Equals Op (ArbitraryFloatHypotINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatHypotINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatSqrtINTEL : idResult Equals Op (ArbitraryFloatSqrtINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatSqrtINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatLogINTEL : idResult Equals Op (ArbitraryFloatLogINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatLogINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatLog2INTEL : idResult Equals Op (ArbitraryFloatLog2INTEL idResultType | SpecConstantOp idResultType ArbitraryFloatLog2INTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatLog10INTEL : idResult Equals Op (ArbitraryFloatLog10INTEL idResultType | SpecConstantOp idResultType ArbitraryFloatLog10INTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatLog1pINTEL : idResult Equals Op (ArbitraryFloatLog1pINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatLog1pINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatExpINTEL : idResult Equals Op (ArbitraryFloatExpINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatExpINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatExp2INTEL : idResult Equals Op (ArbitraryFloatExp2INTEL idResultType | SpecConstantOp idResultType ArbitraryFloatExp2INTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatExp10INTEL : idResult Equals Op (ArbitraryFloatExp10INTEL idResultType | SpecConstantOp idResultType ArbitraryFloatExp10INTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatExpm1INTEL : idResult Equals Op (ArbitraryFloatExpm1INTEL idResultType | SpecConstantOp idResultType ArbitraryFloatExpm1INTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatSinINTEL : idResult Equals Op (ArbitraryFloatSinINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatSinINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCosINTEL : idResult Equals Op (ArbitraryFloatCosINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatCosINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatSinCosINTEL : idResult Equals Op (ArbitraryFloatSinCosINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatSinCosINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatSinPiINTEL : idResult Equals Op (ArbitraryFloatSinPiINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatSinPiINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatCosPiINTEL : idResult Equals Op (ArbitraryFloatCosPiINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatCosPiINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatASinINTEL : idResult Equals Op (ArbitraryFloatASinINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatASinINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatASinPiINTEL : idResult Equals Op (ArbitraryFloatASinPiINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatASinPiINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatACosINTEL : idResult Equals Op (ArbitraryFloatACosINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatACosINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatACosPiINTEL : idResult Equals Op (ArbitraryFloatACosPiINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatACosPiINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatATanINTEL : idResult Equals Op (ArbitraryFloatATanINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatATanINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatATanPiINTEL : idResult Equals Op (ArbitraryFloatATanPiINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatATanPiINTEL) a m1 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatATan2INTEL : idResult Equals Op (ArbitraryFloatATan2INTEL idResultType | SpecConstantOp idResultType ArbitraryFloatATan2INTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatPowINTEL : idResult Equals Op (ArbitraryFloatPowINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatPowINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatPowRINTEL : idResult Equals Op (ArbitraryFloatPowRINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatPowRINTEL) a m1 b m2 mout enableSubnormals roundingMode roundingAccuracy;
opArbitraryFloatPowNINTEL : idResult Equals Op (ArbitraryFloatPowNINTEL idResultType | SpecConstantOp idResultType ArbitraryFloatPowNINTEL) a m1 b mout enableSubnormals roundingMode roundingAccuracy;
opAliasDomainDeclINTEL : idResult Equals Op (AliasDomainDeclINTEL  | SpecConstantOp  AliasDomainDeclINTEL) nameIdRef?;
opAliasScopeDeclINTEL : idResult Equals Op (AliasScopeDeclINTEL  | SpecConstantOp  AliasScopeDeclINTEL) aliasDomain nameIdRef?;
opAliasScopeListDeclINTEL : idResult Equals Op (AliasScopeListDeclINTEL  | SpecConstantOp  AliasScopeListDeclINTEL) aliasScope*;
opFixedSqrtINTEL : idResult Equals Op (FixedSqrtINTEL idResultType | SpecConstantOp idResultType FixedSqrtINTEL) inputType input s iLiteralInteger rI q o;
opFixedRecipINTEL : idResult Equals Op (FixedRecipINTEL idResultType | SpecConstantOp idResultType FixedRecipINTEL) inputType input s iLiteralInteger rI q o;
opFixedRsqrtINTEL : idResult Equals Op (FixedRsqrtINTEL idResultType | SpecConstantOp idResultType FixedRsqrtINTEL) inputType input s iLiteralInteger rI q o;
opFixedSinINTEL : idResult Equals Op (FixedSinINTEL idResultType | SpecConstantOp idResultType FixedSinINTEL) inputType input s iLiteralInteger rI q o;
opFixedCosINTEL : idResult Equals Op (FixedCosINTEL idResultType | SpecConstantOp idResultType FixedCosINTEL) inputType input s iLiteralInteger rI q o;
opFixedSinCosINTEL : idResult Equals Op (FixedSinCosINTEL idResultType | SpecConstantOp idResultType FixedSinCosINTEL) inputType input s iLiteralInteger rI q o;
opFixedSinPiINTEL : idResult Equals Op (FixedSinPiINTEL idResultType | SpecConstantOp idResultType FixedSinPiINTEL) inputType input s iLiteralInteger rI q o;
opFixedCosPiINTEL : idResult Equals Op (FixedCosPiINTEL idResultType | SpecConstantOp idResultType FixedCosPiINTEL) inputType input s iLiteralInteger rI q o;
opFixedSinCosPiINTEL : idResult Equals Op (FixedSinCosPiINTEL idResultType | SpecConstantOp idResultType FixedSinCosPiINTEL) inputType input s iLiteralInteger rI q o;
opFixedLogINTEL : idResult Equals Op (FixedLogINTEL idResultType | SpecConstantOp idResultType FixedLogINTEL) inputType input s iLiteralInteger rI q o;
opFixedExpINTEL : idResult Equals Op (FixedExpINTEL idResultType | SpecConstantOp idResultType FixedExpINTEL) inputType input s iLiteralInteger rI q o;
opPtrCastToCrossWorkgroupINTEL : idResult Equals Op (PtrCastToCrossWorkgroupINTEL idResultType | SpecConstantOp idResultType PtrCastToCrossWorkgroupINTEL) pointer;
opCrossWorkgroupCastToPtrINTEL : idResult Equals Op (CrossWorkgroupCastToPtrINTEL idResultType | SpecConstantOp idResultType CrossWorkgroupCastToPtrINTEL) pointer;

// Extensions
literalExtInstInteger
    :   clspvReflection
    |   glsl
    |   opencl
    ;


// Extension clspvReflection
clspvReflection
    :   clspvReflection_argumentInfo
    |   clspvReflection_argumentPodPushConstant
    |   clspvReflection_argumentPodStorageBuffer
    |   clspvReflection_argumentPodUniform
    |   clspvReflection_argumentPointerPushConstant
    |   clspvReflection_argumentPointerUniform
    |   clspvReflection_argumentSampledImage
    |   clspvReflection_argumentSampler
    |   clspvReflection_argumentStorageBuffer
    |   clspvReflection_argumentStorageImage
    |   clspvReflection_argumentStorageTexelBuffer
    |   clspvReflection_argumentUniform
    |   clspvReflection_argumentUniformTexelBuffer
    |   clspvReflection_argumentWorkgroup
    |   clspvReflection_constantDataPointerPushConstant
    |   clspvReflection_constantDataStorageBuffer
    |   clspvReflection_constantDataUniform
    |   clspvReflection_imageArgumentInfoChannelDataTypePushConstant
    |   clspvReflection_imageArgumentInfoChannelDataTypeUniform
    |   clspvReflection_imageArgumentInfoChannelOrderPushConstant
    |   clspvReflection_imageArgumentInfoChannelOrderUniform
    |   clspvReflection_kernel
    |   clspvReflection_literalSampler
    |   clspvReflection_normalizedSamplerMaskPushConstant
    |   clspvReflection_printfBufferPointerPushConstant
    |   clspvReflection_printfBufferStorageBuffer
    |   clspvReflection_printfInfo
    |   clspvReflection_programScopeVariablePointerPushConstant
    |   clspvReflection_programScopeVariablePointerRelocation
    |   clspvReflection_programScopeVariablesStorageBuffer
    |   clspvReflection_propertyRequiredWorkgroupSize
    |   clspvReflection_pushConstantEnqueuedLocalSize
    |   clspvReflection_pushConstantGlobalOffset
    |   clspvReflection_pushConstantGlobalSize
    |   clspvReflection_pushConstantNumWorkgroups
    |   clspvReflection_pushConstantRegionGroupOffset
    |   clspvReflection_pushConstantRegionOffset
    |   clspvReflection_specConstantGlobalOffset
    |   clspvReflection_specConstantSubgroupMaxSize
    |   clspvReflection_specConstantWorkDim
    |   clspvReflection_specConstantWorkgroupSize
    ;

clspvReflection_kernel : ModeExt_Kernel kernelIdRef nameIdRef (numArguments (flags attributes?)?)?;
clspvReflection_argumentInfo : ModeExt_ArgumentInfo nameIdRef (typeName (addressQualifier (accessQualifierIdRef typeQualifier?)?)?)?;
clspvReflection_argumentStorageBuffer : ModeExt_ArgumentStorageBuffer decl ordinal descriptorSetIdRef binding argInfo?;
clspvReflection_argumentUniform : ModeExt_ArgumentUniform decl ordinal descriptorSetIdRef binding argInfo?;
clspvReflection_argumentPodStorageBuffer : ModeExt_ArgumentPodStorageBuffer decl ordinal descriptorSetIdRef binding offsetIdRef sizeIdRef argInfo?;
clspvReflection_argumentPodUniform : ModeExt_ArgumentPodUniform decl ordinal descriptorSetIdRef binding offsetIdRef sizeIdRef argInfo?;
clspvReflection_argumentPodPushConstant : ModeExt_ArgumentPodPushConstant decl ordinal offsetIdRef sizeIdRef argInfo?;
clspvReflection_argumentSampledImage : ModeExt_ArgumentSampledImage decl ordinal descriptorSetIdRef binding argInfo?;
clspvReflection_argumentStorageImage : ModeExt_ArgumentStorageImage decl ordinal descriptorSetIdRef binding argInfo?;
clspvReflection_argumentSampler : ModeExt_ArgumentSampler decl ordinal descriptorSetIdRef binding argInfo?;
clspvReflection_argumentWorkgroup : ModeExt_ArgumentWorkgroup decl ordinal specId elemSize argInfo?;
clspvReflection_specConstantWorkgroupSize : ModeExt_SpecConstantWorkgroupSize x y z;
clspvReflection_specConstantGlobalOffset : ModeExt_SpecConstantGlobalOffset x y z;
clspvReflection_specConstantWorkDim : ModeExt_SpecConstantWorkDim dimIdRef;
clspvReflection_pushConstantGlobalOffset : ModeExt_PushConstantGlobalOffset offsetIdRef sizeIdRef;
clspvReflection_pushConstantEnqueuedLocalSize : ModeExt_PushConstantEnqueuedLocalSize offsetIdRef sizeIdRef;
clspvReflection_pushConstantGlobalSize : ModeExt_PushConstantGlobalSize offsetIdRef sizeIdRef;
clspvReflection_pushConstantRegionOffset : ModeExt_PushConstantRegionOffset offsetIdRef sizeIdRef;
clspvReflection_pushConstantNumWorkgroups : ModeExt_PushConstantNumWorkgroups offsetIdRef sizeIdRef;
clspvReflection_pushConstantRegionGroupOffset : ModeExt_PushConstantRegionGroupOffset offsetIdRef sizeIdRef;
clspvReflection_constantDataStorageBuffer : ModeExt_ConstantDataStorageBuffer descriptorSetIdRef binding data;
clspvReflection_constantDataUniform : ModeExt_ConstantDataUniform descriptorSetIdRef binding data;
clspvReflection_literalSampler : ModeExt_LiteralSampler descriptorSetIdRef binding mask;
clspvReflection_propertyRequiredWorkgroupSize : ModeExt_PropertyRequiredWorkgroupSize kernelIdRef x y z;
clspvReflection_specConstantSubgroupMaxSize : ModeExt_SpecConstantSubgroupMaxSize sizeIdRef;
clspvReflection_argumentPointerPushConstant : ModeExt_ArgumentPointerPushConstant kernelIdRef ordinal offsetIdRef sizeIdRef argInfo?;
clspvReflection_argumentPointerUniform : ModeExt_ArgumentPointerUniform kernelIdRef ordinal descriptorSetIdRef binding offsetIdRef sizeIdRef argInfo?;
clspvReflection_programScopeVariablesStorageBuffer : ModeExt_ProgramScopeVariablesStorageBuffer descriptorSetIdRef binding data;
clspvReflection_programScopeVariablePointerRelocation : ModeExt_ProgramScopeVariablePointerRelocation objectOffset pointerOffset pointerSize;
clspvReflection_imageArgumentInfoChannelOrderPushConstant : ModeExt_ImageArgumentInfoChannelOrderPushConstant kernelIdRef ordinal offsetIdRef sizeIdRef;
clspvReflection_imageArgumentInfoChannelDataTypePushConstant : ModeExt_ImageArgumentInfoChannelDataTypePushConstant kernelIdRef ordinal offsetIdRef sizeIdRef;
clspvReflection_imageArgumentInfoChannelOrderUniform : ModeExt_ImageArgumentInfoChannelOrderUniform kernelIdRef ordinal descriptorSetIdRef binding offsetIdRef sizeIdRef;
clspvReflection_imageArgumentInfoChannelDataTypeUniform : ModeExt_ImageArgumentInfoChannelDataTypeUniform kernelIdRef ordinal descriptorSetIdRef binding offsetIdRef sizeIdRef;
clspvReflection_argumentStorageTexelBuffer : ModeExt_ArgumentStorageTexelBuffer decl ordinal descriptorSetIdRef binding argInfo?;
clspvReflection_argumentUniformTexelBuffer : ModeExt_ArgumentUniformTexelBuffer decl ordinal descriptorSetIdRef binding argInfo?;
clspvReflection_constantDataPointerPushConstant : ModeExt_ConstantDataPointerPushConstant offsetIdRef sizeIdRef data;
clspvReflection_programScopeVariablePointerPushConstant : ModeExt_ProgramScopeVariablePointerPushConstant offsetIdRef sizeIdRef data;
clspvReflection_printfInfo : ModeExt_PrintfInfo printfID formatString argumentSizes*;
clspvReflection_printfBufferStorageBuffer : ModeExt_PrintfBufferStorageBuffer descriptorSetIdRef binding bufferSize;
clspvReflection_printfBufferPointerPushConstant : ModeExt_PrintfBufferPointerPushConstant offsetIdRef sizeIdRef bufferSize;
clspvReflection_normalizedSamplerMaskPushConstant : ModeExt_NormalizedSamplerMaskPushConstant kernelIdRef ordinal offsetIdRef sizeIdRef;

// Extension glsl
glsl
    :   glsl_acos
    |   glsl_acosh
    |   glsl_asin
    |   glsl_asinh
    |   glsl_atan
    |   glsl_atan2
    |   glsl_atanh
    |   glsl_ceil
    |   glsl_cos
    |   glsl_cosh
    |   glsl_cross
    |   glsl_degrees
    |   glsl_determinant
    |   glsl_distance
    |   glsl_exp
    |   glsl_exp2
    |   glsl_fAbs
    |   glsl_fClamp
    |   glsl_fMax
    |   glsl_fMin
    |   glsl_fMix
    |   glsl_fSign
    |   glsl_faceForward
    |   glsl_findILsb
    |   glsl_findSMsb
    |   glsl_findUMsb
    |   glsl_floor
    |   glsl_fma
    |   glsl_fract
    |   glsl_frexp
    |   glsl_frexpStruct
    |   glsl_iMix
    |   glsl_interpolateAtCentroid
    |   glsl_interpolateAtOffset
    |   glsl_interpolateAtSample
    |   glsl_inverseSqrt
    |   glsl_ldexp
    |   glsl_length
    |   glsl_log
    |   glsl_log2
    |   glsl_matrixInverse
    |   glsl_modf
    |   glsl_modfStruct
    |   glsl_nClamp
    |   glsl_nMax
    |   glsl_nMin
    |   glsl_normalize
    |   glsl_packDouble2x32
    |   glsl_packHalf2x16
    |   glsl_packSnorm2x16
    |   glsl_packSnorm4x8
    |   glsl_packUnorm2x16
    |   glsl_packUnorm4x8
    |   glsl_pow
    |   glsl_radians
    |   glsl_reflect
    |   glsl_refract
    |   glsl_round
    |   glsl_roundEven
    |   glsl_sAbs
    |   glsl_sClamp
    |   glsl_sMax
    |   glsl_sMin
    |   glsl_sSign
    |   glsl_sin
    |   glsl_sinh
    |   glsl_smoothStep
    |   glsl_sqrt
    |   glsl_step
    |   glsl_tan
    |   glsl_tanh
    |   glsl_trunc
    |   glsl_uClamp
    |   glsl_uMax
    |   glsl_uMin
    |   glsl_unpackDouble2x32
    |   glsl_unpackHalf2x16
    |   glsl_unpackSnorm2x16
    |   glsl_unpackSnorm4x8
    |   glsl_unpackUnorm2x16
    |   glsl_unpackUnorm4x8
    ;

glsl_round : ModeExt_Round x;
glsl_roundEven : ModeExt_RoundEven x;
glsl_trunc : ModeExt_Trunc x;
glsl_fAbs : ModeExt_FAbs x;
glsl_sAbs : ModeExt_SAbs x;
glsl_fSign : ModeExt_FSign x;
glsl_sSign : ModeExt_SSign x;
glsl_floor : ModeExt_Floor x;
glsl_ceil : ModeExt_Ceil x;
glsl_fract : ModeExt_Fract x;
glsl_radians : ModeExt_Radians degreesIdRef;
glsl_degrees : ModeExt_Degrees radiansIdRef;
glsl_sin : ModeExt_Sin x;
glsl_cos : ModeExt_Cos x;
glsl_tan : ModeExt_Tan x;
glsl_asin : ModeExt_Asin x;
glsl_acos : ModeExt_Acos x;
glsl_atan : ModeExt_Atan y;
glsl_sinh : ModeExt_Sinh x;
glsl_cosh : ModeExt_Cosh x;
glsl_tanh : ModeExt_Tanh x;
glsl_asinh : ModeExt_Asinh x;
glsl_acosh : ModeExt_Acosh x;
glsl_atanh : ModeExt_Atanh x;
glsl_atan2 : ModeExt_Atan2 y x;
glsl_pow : ModeExt_Pow x y;
glsl_exp : ModeExt_Exp x;
glsl_log : ModeExt_Log x;
glsl_exp2 : ModeExt_Exp2 x;
glsl_log2 : ModeExt_Log2 x;
glsl_sqrt : ModeExt_Sqrt x;
glsl_inverseSqrt : ModeExt_InverseSqrt x;
glsl_determinant : ModeExt_Determinant x;
glsl_matrixInverse : ModeExt_MatrixInverse x;
glsl_modf : ModeExt_Modf x iIdRef;
glsl_modfStruct : ModeExt_ModfStruct x;
glsl_fMin : ModeExt_FMin x y;
glsl_uMin : ModeExt_UMin x y;
glsl_sMin : ModeExt_SMin x y;
glsl_fMax : ModeExt_FMax x y;
glsl_uMax : ModeExt_UMax x y;
glsl_sMax : ModeExt_SMax x y;
glsl_fClamp : ModeExt_FClamp x minVal maxVal;
glsl_uClamp : ModeExt_UClamp x minVal maxVal;
glsl_sClamp : ModeExt_SClamp x minVal maxVal;
glsl_fMix : ModeExt_FMix x y a;
glsl_iMix : ModeExt_IMix x y a;
glsl_step : ModeExt_Step edge x;
glsl_smoothStep : ModeExt_SmoothStep edge0 edge1 x;
glsl_fma : ModeExt_Fma a b c;
glsl_frexp : ModeExt_Frexp x expIdRef;
glsl_frexpStruct : ModeExt_FrexpStruct x;
glsl_ldexp : ModeExt_Ldexp x expIdRef;
glsl_packSnorm4x8 : ModeExt_PackSnorm4x8 v;
glsl_packUnorm4x8 : ModeExt_PackUnorm4x8 v;
glsl_packSnorm2x16 : ModeExt_PackSnorm2x16 v;
glsl_packUnorm2x16 : ModeExt_PackUnorm2x16 v;
glsl_packHalf2x16 : ModeExt_PackHalf2x16 v;
glsl_packDouble2x32 : ModeExt_PackDouble2x32 v;
glsl_unpackSnorm2x16 : ModeExt_UnpackSnorm2x16 p;
glsl_unpackUnorm2x16 : ModeExt_UnpackUnorm2x16 p;
glsl_unpackHalf2x16 : ModeExt_UnpackHalf2x16 v;
glsl_unpackSnorm4x8 : ModeExt_UnpackSnorm4x8 p;
glsl_unpackUnorm4x8 : ModeExt_UnpackUnorm4x8 p;
glsl_unpackDouble2x32 : ModeExt_UnpackDouble2x32 v;
glsl_length : ModeExt_Length x;
glsl_distance : ModeExt_Distance p0 p1;
glsl_cross : ModeExt_Cross x y;
glsl_normalize : ModeExt_Normalize x;
glsl_faceForward : ModeExt_FaceForward nIdRef iIdRef nref;
glsl_reflect : ModeExt_Reflect iIdRef nIdRef;
glsl_refract : ModeExt_Refract iIdRef nIdRef eta;
glsl_findILsb : ModeExt_FindILsb valueIdRef;
glsl_findSMsb : ModeExt_FindSMsb valueIdRef;
glsl_findUMsb : ModeExt_FindUMsb valueIdRef;
glsl_interpolateAtCentroid : ModeExt_InterpolateAtCentroid interpolant;
glsl_interpolateAtSample : ModeExt_InterpolateAtSample interpolant sample;
glsl_interpolateAtOffset : ModeExt_InterpolateAtOffset interpolant offsetIdRef;
glsl_nMin : ModeExt_NMin x y;
glsl_nMax : ModeExt_NMax x y;
glsl_nClamp : ModeExt_NClamp x minVal maxVal;

// Extension opencl
opencl
    :   opencl_acos
    |   opencl_acosh
    |   opencl_acospi
    |   opencl_asin
    |   opencl_asinh
    |   opencl_asinpi
    |   opencl_atan
    |   opencl_atan2
    |   opencl_atan2pi
    |   opencl_atanh
    |   opencl_atanpi
    |   opencl_bitselect
    |   opencl_cbrt
    |   opencl_ceil
    |   opencl_clz
    |   opencl_copysign
    |   opencl_cos
    |   opencl_cosh
    |   opencl_cospi
    |   opencl_cross
    |   opencl_ctz
    |   opencl_degrees
    |   opencl_distance
    |   opencl_erf
    |   opencl_erfc
    |   opencl_exp
    |   opencl_exp10
    |   opencl_exp2
    |   opencl_expm1
    |   opencl_fAbs
    |   opencl_fClamp
    |   opencl_fMax
    |   opencl_fMin
    |   opencl_fast_distance
    |   opencl_fast_length
    |   opencl_fast_normalize
    |   opencl_fdim
    |   opencl_floor
    |   opencl_fma
    |   opencl_fmax_common
    |   opencl_fmin_common
    |   opencl_fmod
    |   opencl_fract
    |   opencl_frexp
    |   opencl_half_cos
    |   opencl_half_divide
    |   opencl_half_exp
    |   opencl_half_exp10
    |   opencl_half_exp2
    |   opencl_half_log
    |   opencl_half_log10
    |   opencl_half_log2
    |   opencl_half_powr
    |   opencl_half_recip
    |   opencl_half_rsqrt
    |   opencl_half_sin
    |   opencl_half_sqrt
    |   opencl_half_tan
    |   opencl_hypot
    |   opencl_ilogb
    |   opencl_ldexp
    |   opencl_length
    |   opencl_lgamma
    |   opencl_lgamma_r
    |   opencl_log
    |   opencl_log10
    |   opencl_log1p
    |   opencl_log2
    |   opencl_logb
    |   opencl_mad
    |   opencl_maxmag
    |   opencl_minmag
    |   opencl_mix
    |   opencl_modf
    |   opencl_nan
    |   opencl_native_cos
    |   opencl_native_divide
    |   opencl_native_exp
    |   opencl_native_exp10
    |   opencl_native_exp2
    |   opencl_native_log
    |   opencl_native_log10
    |   opencl_native_log2
    |   opencl_native_powr
    |   opencl_native_recip
    |   opencl_native_rsqrt
    |   opencl_native_sin
    |   opencl_native_sqrt
    |   opencl_native_tan
    |   opencl_nextafter
    |   opencl_normalize
    |   opencl_popcount
    |   opencl_pow
    |   opencl_pown
    |   opencl_powr
    |   opencl_prefetch
    |   opencl_printf
    |   opencl_radians
    |   opencl_remainder
    |   opencl_remquo
    |   opencl_rint
    |   opencl_rootn
    |   opencl_rotate
    |   opencl_round
    |   opencl_rsqrt
    |   opencl_s_abs
    |   opencl_s_abs_diff
    |   opencl_s_add_sat
    |   opencl_s_clamp
    |   opencl_s_hadd
    |   opencl_s_mad24
    |   opencl_s_mad_hi
    |   opencl_s_mad_sat
    |   opencl_s_max
    |   opencl_s_min
    |   opencl_s_mul24
    |   opencl_s_mul_hi
    |   opencl_s_rhadd
    |   opencl_s_sub_sat
    |   opencl_s_upsample
    |   opencl_select
    |   opencl_shuffle
    |   opencl_shuffle2
    |   opencl_sign
    |   opencl_sin
    |   opencl_sincos
    |   opencl_sinh
    |   opencl_sinpi
    |   opencl_smoothStep
    |   opencl_sqrt
    |   opencl_step
    |   opencl_tan
    |   opencl_tanh
    |   opencl_tanpi
    |   opencl_tgamma
    |   opencl_trunc
    |   opencl_u_abs
    |   opencl_u_abs_diff
    |   opencl_u_add_sat
    |   opencl_u_clamp
    |   opencl_u_hadd
    |   opencl_u_mad24
    |   opencl_u_mad_hi
    |   opencl_u_mad_sat
    |   opencl_u_max
    |   opencl_u_min
    |   opencl_u_mul24
    |   opencl_u_mul_hi
    |   opencl_u_rhadd
    |   opencl_u_sub_sat
    |   opencl_u_upsample
    |   opencl_vload_half
    |   opencl_vload_halfn
    |   opencl_vloada_halfn
    |   opencl_vloadn
    |   opencl_vstore_half
    |   opencl_vstore_half_r
    |   opencl_vstore_halfn
    |   opencl_vstore_halfn_r
    |   opencl_vstorea_halfn
    |   opencl_vstorea_halfn_r
    |   opencl_vstoren
    ;

opencl_acos : ModeExt_acos x;
opencl_acosh : ModeExt_acosh x;
opencl_acospi : ModeExt_acospi x;
opencl_asin : ModeExt_asin x;
opencl_asinh : ModeExt_asinh x;
opencl_asinpi : ModeExt_asinpi x;
opencl_atan : ModeExt_atan x;
opencl_atan2 : ModeExt_atan2 y x;
opencl_atanh : ModeExt_atanh x;
opencl_atanpi : ModeExt_atanpi x;
opencl_atan2pi : ModeExt_atan2pi y x;
opencl_cbrt : ModeExt_cbrt x;
opencl_ceil : ModeExt_ceil x;
opencl_copysign : ModeExt_copysign x y;
opencl_cos : ModeExt_cos x;
opencl_cosh : ModeExt_cosh x;
opencl_cospi : ModeExt_cospi x;
opencl_erfc : ModeExt_erfc x;
opencl_erf : ModeExt_erf x;
opencl_exp : ModeExt_exp x;
opencl_exp2 : ModeExt_exp2 x;
opencl_exp10 : ModeExt_exp10 x;
opencl_expm1 : ModeExt_expm1 x;
opencl_fAbs : ModeExt_fabs x;
opencl_fdim : ModeExt_fdim x y;
opencl_floor : ModeExt_floor x;
opencl_fma : ModeExt_fma a b c;
opencl_fMax : ModeExt_fmax x y;
opencl_fMin : ModeExt_fmin x y;
opencl_fmod : ModeExt_fmod x y;
opencl_fract : ModeExt_fract x ptr;
opencl_frexp : ModeExt_frexp x expIdRef;
opencl_hypot : ModeExt_hypot x y;
opencl_ilogb : ModeExt_ilogb x;
opencl_ldexp : ModeExt_ldexp x k;
opencl_lgamma : ModeExt_lgamma x;
opencl_lgamma_r : ModeExt_lgamma_r x signp;
opencl_log : ModeExt_log x;
opencl_log2 : ModeExt_log2 x;
opencl_log10 : ModeExt_log10 x;
opencl_log1p : ModeExt_log1p x;
opencl_logb : ModeExt_logb x;
opencl_mad : ModeExt_mad a b c;
opencl_maxmag : ModeExt_maxmag x y;
opencl_minmag : ModeExt_minmag x y;
opencl_modf : ModeExt_modf x iptr;
opencl_nan : ModeExt_nan nancode;
opencl_nextafter : ModeExt_nextafter x y;
opencl_pow : ModeExt_pow x y;
opencl_pown : ModeExt_pown x y;
opencl_powr : ModeExt_powr x y;
opencl_remainder : ModeExt_remainder x y;
opencl_remquo : ModeExt_remquo x y quo;
opencl_rint : ModeExt_rint x;
opencl_rootn : ModeExt_rootn x y;
opencl_round : ModeExt_round x;
opencl_rsqrt : ModeExt_rsqrt x;
opencl_sin : ModeExt_sin x;
opencl_sincos : ModeExt_sincos x cosval;
opencl_sinh : ModeExt_sinh x;
opencl_sinpi : ModeExt_sinpi x;
opencl_sqrt : ModeExt_sqrt x;
opencl_tan : ModeExt_tan x;
opencl_tanh : ModeExt_tanh x;
opencl_tanpi : ModeExt_tanpi x;
opencl_tgamma : ModeExt_tgamma x;
opencl_trunc : ModeExt_trunc x;
opencl_half_cos : ModeExt_half_cos x;
opencl_half_divide : ModeExt_half_divide x y;
opencl_half_exp : ModeExt_half_exp x;
opencl_half_exp2 : ModeExt_half_exp2 x;
opencl_half_exp10 : ModeExt_half_exp10 x;
opencl_half_log : ModeExt_half_log x;
opencl_half_log2 : ModeExt_half_log2 x;
opencl_half_log10 : ModeExt_half_log10 x;
opencl_half_powr : ModeExt_half_powr x y;
opencl_half_recip : ModeExt_half_recip x;
opencl_half_rsqrt : ModeExt_half_rsqrt x;
opencl_half_sin : ModeExt_half_sin x;
opencl_half_sqrt : ModeExt_half_sqrt x;
opencl_half_tan : ModeExt_half_tan x;
opencl_native_cos : ModeExt_native_cos x;
opencl_native_divide : ModeExt_native_divide x y;
opencl_native_exp : ModeExt_native_exp x;
opencl_native_exp2 : ModeExt_native_exp2 x;
opencl_native_exp10 : ModeExt_native_exp10 x;
opencl_native_log : ModeExt_native_log x;
opencl_native_log2 : ModeExt_native_log2 x;
opencl_native_log10 : ModeExt_native_log10 x;
opencl_native_powr : ModeExt_native_powr x y;
opencl_native_recip : ModeExt_native_recip x;
opencl_native_rsqrt : ModeExt_native_rsqrt x;
opencl_native_sin : ModeExt_native_sin x;
opencl_native_sqrt : ModeExt_native_sqrt x;
opencl_native_tan : ModeExt_native_tan x;
opencl_s_abs : ModeExt_s_abs x;
opencl_s_abs_diff : ModeExt_s_abs_diff x y;
opencl_s_add_sat : ModeExt_s_add_sat x y;
opencl_u_add_sat : ModeExt_u_add_sat x y;
opencl_s_hadd : ModeExt_s_hadd x y;
opencl_u_hadd : ModeExt_u_hadd x y;
opencl_s_rhadd : ModeExt_s_rhadd x y;
opencl_u_rhadd : ModeExt_u_rhadd x y;
opencl_s_clamp : ModeExt_s_clamp x minVal maxVal;
opencl_u_clamp : ModeExt_u_clamp x minVal maxVal;
opencl_clz : ModeExt_clz x;
opencl_ctz : ModeExt_ctz x;
opencl_s_mad_hi : ModeExt_s_mad_hi a b c;
opencl_u_mad_sat : ModeExt_u_mad_sat x y z;
opencl_s_mad_sat : ModeExt_s_mad_sat x y z;
opencl_s_max : ModeExt_s_max x y;
opencl_u_max : ModeExt_u_max x y;
opencl_s_min : ModeExt_s_min x y;
opencl_u_min : ModeExt_u_min x y;
opencl_s_mul_hi : ModeExt_s_mul_hi x y;
opencl_rotate : ModeExt_rotate v iIdRef;
opencl_s_sub_sat : ModeExt_s_sub_sat x y;
opencl_u_sub_sat : ModeExt_u_sub_sat x y;
opencl_u_upsample : ModeExt_u_upsample hi lo;
opencl_s_upsample : ModeExt_s_upsample hi lo;
opencl_popcount : ModeExt_popcount x;
opencl_s_mad24 : ModeExt_s_mad24 x y z;
opencl_u_mad24 : ModeExt_u_mad24 x y z;
opencl_s_mul24 : ModeExt_s_mul24 x y;
opencl_u_mul24 : ModeExt_u_mul24 x y;
opencl_u_abs : ModeExt_u_abs x;
opencl_u_abs_diff : ModeExt_u_abs_diff x y;
opencl_u_mul_hi : ModeExt_u_mul_hi x y;
opencl_u_mad_hi : ModeExt_u_mad_hi a b c;
opencl_fClamp : ModeExt_fclamp x minVal maxVal;
opencl_degrees : ModeExt_degrees radiansIdRef;
opencl_fmax_common : ModeExt_fmax_common x y;
opencl_fmin_common : ModeExt_fmin_common x y;
opencl_mix : ModeExt_mix x y a;
opencl_radians : ModeExt_radians degreesIdRef;
opencl_step : ModeExt_step edge x;
opencl_smoothStep : ModeExt_smoothstep edge0 edge1 x;
opencl_sign : ModeExt_sign x;
opencl_cross : ModeExt_cross p0 p1;
opencl_distance : ModeExt_distance p0 p1;
opencl_length : ModeExt_length p;
opencl_normalize : ModeExt_normalize p;
opencl_fast_distance : ModeExt_fast_distance p0 p1;
opencl_fast_length : ModeExt_fast_length p;
opencl_fast_normalize : ModeExt_fast_normalize p;
opencl_bitselect : ModeExt_bitselect a b c;
opencl_select : ModeExt_select a b c;
opencl_vloadn : ModeExt_vloadn offsetIdRef p nLiteralInteger;
opencl_vstoren : ModeExt_vstoren data offsetIdRef p;
opencl_vload_half : ModeExt_vload_half offsetIdRef p;
opencl_vload_halfn : ModeExt_vload_halfn offsetIdRef p nLiteralInteger;
opencl_vstore_half : ModeExt_vstore_half data offsetIdRef p;
opencl_vstore_half_r : ModeExt_vstore_half_r data offsetIdRef p modeFPRoundingMode;
opencl_vstore_halfn : ModeExt_vstore_halfn data offsetIdRef p;
opencl_vstore_halfn_r : ModeExt_vstore_halfn_r data offsetIdRef p modeFPRoundingMode;
opencl_vloada_halfn : ModeExt_vloada_halfn offsetIdRef p nLiteralInteger;
opencl_vstorea_halfn : ModeExt_vstorea_halfn data offsetIdRef p;
opencl_vstorea_halfn_r : ModeExt_vstorea_halfn_r data offsetIdRef p modeFPRoundingMode;
opencl_shuffle : ModeExt_shuffle x shuffleMask;
opencl_shuffle2 : ModeExt_shuffle2 x y shuffleMask;
opencl_printf : ModeExt_printf format additionalArguments*;
opencl_prefetch : ModeExt_prefetch ptr numElements;

// Alias types
a : idRef;
accel : idRef;
accelerationStructure : idRef;
access : hostAccessQualifier;
accessQualifierAccessQualifier : accessQualifier;
accessQualifierIdRef : idRef;
accumulator : idRef;
additionalArguments : idRef;
addressQualifier : idRef;
addressWidth : literalInteger;
aliasDomain : idRef;
aliasScope : idRef;
aliasingScopesList : idRef;
alignmentIdRef : idRef;
alignmentLiteralInteger : literalInteger;
argInfo : idRef;
argument : idRef;
argument0 : idRef;
argumentSizes : idRef;
arrayMember : literalInteger;
arraySize : idRef;
arrayStride : literalInteger;
arrayed : literalInteger;
asm : idRef;
asmInstructions : literalString;
asmTarget : literalString;
asmType : idRef;
attachment : idRef;
attachmentIndex : literalInteger;
attributes : idRef;
b : idRef;
bFloat16Value : idRef;
backwardReferenceFieldPolarity : idRef;
bankBits : literalInteger;
bankWidth : literalInteger;
banks : literalInteger;
barrierCount : literalInteger;
barycentric : idRef;
base : idRef;
baseIndex : idRef;
baseType : idRef;
bias : idRef;
biasInterpretation : idRef;
biasOffset : idRef;
bidirectionalWeight : idRef;
binding : idRef;
bindingPoint : literalInteger;
bitWidth : literalInteger;
bits : idRef;
blockBasedSkipType : idRef;
blockCount : idRef;
blockHeight : idRef;
blockSize : idRef;
blockWidth : idRef;
boxSize : idRef;
branchWeights : literalInteger;
bufferLocationID : literalInteger;
bufferSize : idRef;
bwdRefImage : idRef;
bwdRefOffset : idRef;
byteOffsetIdRef : idRef;
byteOffsetLiteralInteger : literalInteger;
byteStride : idRef;
c : idRef;
cacheControlLoadCacheControl : loadCacheControl;
cacheControlStoreCacheControl : storeCacheControl;
cacheLevel : literalInteger;
cacheSizeInBytes : literalInteger;
cacheType : idRef;
callableData : idRef;
callableDataId : idRef;
capacity : literalInteger;
chromaModeBasePenalty : idRef;
clampMode : idRef;
clipColOffset : idRef;
clipColSpan : idRef;
clipRowOffset : idRef;
clipRowSpan : idRef;
clusterSize : idRef;
coarse : idRef;
column : literalInteger;
columnCount : literalInteger;
columnMajor : idRef;
columnType : idRef;
columns : idRef;
combineFunc : idRef;
comparator : idRef;
componentCountIdRef : idRef;
componentCountLiteralInteger : literalInteger;
componentIdRef : idRef;
componentLiteralInteger : literalInteger;
componentTypeIdRef : idRef;
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
cosval : idRef;
count : idRef;
counterBuffer : idRef;
cullMask : idRef;
current : idRef;
currentTime : idRef;
cycles : literalInteger;
d : idRef;
data : idRef;
dataType : idRef;
dataWidth : literalInteger;
decl : idRef;
decorationGroup : idRef;
default : idRef;
degreesIdRef : idRef;
delta : idRef;
depthLiteralInteger : literalInteger;
descriptorSetIdRef : idRef;
descriptorSetLiteralInteger : literalInteger;
destination : idRef;
dimIdRef : idRef;
direction : idRef;
directionCost : idRef;
dstBasePointer : idRef;
dstPointer : idRef;
dualRef : idRef;
edge : idRef;
edge0 : idRef;
edge1 : idRef;
elemSize : idRef;
element : idRef;
elementIndex : idRef;
elementSize : idRef;
elementType : idRef;
enable : literalInteger;
enableSubnormals : literalInteger;
entryPoint : idRef;
equal : idMemorySemantics;
eta : idRef;
event : idRef;
eventsList : idRef;
execution : idScope;
expIdRef : idRef;
expectedValue : idRef;
extension : literalString;
falseLabel : idRef;
fastFPFastMathMode : fPFastMathMode;
fastIdRef : idRef;
file : idRef;
fillEmpty : idRef;
flags : idRef;
floatValue : idRef;
floating : fPRoundingMode;
forceKey : literalInteger;
format : idRef;
formatString : idRef;
forwardReferenceFieldPolarity : idRef;
fragmentIndex : idRef;
fromSign : literalInteger;
func : idRef;
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
hasDimensions : idRef;
height : idRef;
hi : idRef;
hint : idRef;
hit : idRef;
hitKind : idRef;
hitObject : idRef;
hitObjectAttribute : idRef;
hitObjectAttributes : idRef;
hitT : idRef;
iIdRef : idRef;
iLiteralInteger : literalInteger;
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
inputInterpretation : idRef;
inputType : idRef;
inputVector : idRef;
insert : idRef;
instanceId : idRef;
instruction : literalExtInstInteger;
integerValue : idRef;
interface : idRef;
interpolant : idRef;
intersection : idRef;
intraNeighbourAvailabilty : idRef;
invocationId : idRef;
invocations : literalInteger;
invoke : idRef;
iptr : idRef;
isEntry : idRef;
k : idRef;
kDim : idRef;
kernelIdRef : idRef;
kind : literalInteger;
latency : literalInteger;
latencyLabel : literalInteger;
leftEdgeChromaPixels : idRef;
leftEdgeLumaPixels : idRef;
leftMatrix : idRef;
lenght : idRef;
lengthIdRef : idRef;
levelOfDetail : idRef;
line : literalInteger;
literalStringLiteralString : literalString;
lo : idRef;
localId : idRef;
localSize : idRef;
localWorkSize : idRef;
locality : idRef;
location : literalInteger;
loopControlParameters : literalInteger;
lumaIntraPartitionMask : idRef;
lumaModePenalty : idRef;
lumaPackedNeighborModes : idRef;
lumaPackedNonDcPenalty : idRef;
m : idRef;
m1 : literalInteger;
m2 : literalInteger;
mS : literalInteger;
majorShape : idRef;
majorShapes : idRef;
mask : idRef;
matrix : idRef;
matrixA : idRef;
matrixB : idRef;
matrixC : idRef;
matrixInterpretation : idRef;
matrixOffset : idRef;
matrixStrideIdRef : idRef;
matrixStrideLiteralInteger : literalInteger;
max : literalInteger;
maxBurstCount : literalInteger;
maxByteOffsetIdRef : idRef;
maxByteOffsetLiteralInteger : literalInteger;
maxError : literalFloat;
maxMotionVectorCount : idRef;
maxNumberOfPayloads : idRef;
maxVal : idRef;
maximumCopies : literalInteger;
maximumReplicates : literalInteger;
member : literalInteger;
memberType : idRef;
memory : idScope;
memoryHeight : idRef;
memoryLayout : idRef;
memoryOperand : memoryAccess;
memoryPitch : idRef;
memoryType : literalString;
memoryWidth : idRef;
mergeBlock : idRef;
mergeKey : literalString;
mergeType : literalString;
minVal : idRef;
minorShapes : idRef;
missIndex : idRef;
modeExecutionMode : executionMode;
modeFPRoundingMode : fPRoundingMode;
modeLiteralInteger : literalInteger;
motionVectors : idRef;
mout : literalInteger;
nDRange : idRef;
nIdRef : idRef;
nLiteralInteger : literalInteger;
nameIdRef : idRef;
nameLiteralString : literalString;
namedBarrier : idRef;
nancode : idRef;
next : idRef;
nodeIndex : idRef;
nodeName : idRef;
nref : idRef;
numArguments : idRef;
numBytes : idRef;
numElements : idRef;
numEvents : idRef;
numPackets : idRef;
numberOf : literalInteger;
numberOfRecursions : idRef;
numberOfRegistersIdRef : idRef;
numberOfRegistersLiteralInteger : literalInteger;
o : literalInteger;
object : idRef;
object1 : idRef;
object2 : idRef;
objectOffset : idRef;
offsetIdRef : idRef;
offsetLiteralInteger : literalInteger;
operand : idRef;
operand1 : idRef;
operand2 : idRef;
operands : idRef;
operation : groupOperation;
ordinal : idRef;
origin : idRef;
p : idRef;
p0 : idRef;
p1 : idRef;
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
payloadType : idRef;
pipe : idRef;
pipeStorage : idRef;
pixelResolution : idRef;
pointer : idRef;
pointerOffset : idRef;
pointerSize : idRef;
pointerType : idRef;
predicate : idRef;
prefetcherSizeInBytes : literalInteger;
previous : idRef;
primitiveCountIdRef : idRef;
primitiveCountLiteralInteger : literalInteger;
primitiveId : idRef;
primitiveIndex : idRef;
printfID : idRef;
process : literalString;
profilingInfo : idRef;
propagate : literalInteger;
ptr : idRef;
ptrVector : idRef;
q : literalInteger;
qp : idRef;
qualifier : accessQualifier;
queue : idRef;
quo : idRef;
rI : literalInteger;
rW : idRef;
radiansIdRef : idRef;
rayDirection : idRef;
rayFlagsIdRef : idRef;
rayOrigin : idRef;
rayQuery : idRef;
rayTmax : idRef;
rayTmin : idRef;
readWriteMode : accessQualifier;
reduce : cooperativeMatrixReduce;
refImage : idRef;
refOffset : idRef;
refWindowSize : idRef;
reference : idRef;
referenceBasePenalty : idRef;
referenceCoordinates : idRef;
referenceFieldPolarity : idRef;
referenceSampledImage : idRef;
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
shuffleMask : idRef;
signedValue : idRef;
signedness : literalInteger;
signp : idRef;
sizeIdRef : idRef;
sizeLiteralInteger : literalInteger;
skipBlockPartitionType : idRef;
skipMotionVectorMask : idRef;
sliceType : idRef;
sourceFieldPolarity : idRef;
sourceIdRef : idRef;
sourceLiteralString : literalString;
specId : idRef;
specializationConstantID : literalInteger;
srcBasePointer : idRef;
srcCoord : idRef;
srcImage : idRef;
srcPointer : idRef;
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
targetSampledImage : idRef;
targetType : idRef;
targetWidth : literalInteger;
targetsIdRef : idRef;
targetsPairIdRefLiteralInteger : pairIdRefLiteralInteger;
tensorLayout : idRef;
tensorView : idRef;
texel : idRef;
texture : idRef;
theNameOfTheOpaqueType : literalString;
threshold : idRef;
time : idRef;
transpose : idRef;
trigger : initializationModeQualifier;
trueLabel : idRef;
type : idRef;
typeName : idRef;
typeQualifier : idRef;
unequal : idMemorySemantics;
unsignedValue : idRef;
upperEdgeChromaPixels : idRef;
upperEdgeLumaPixels : idRef;
upperLeftCornerChromaPixel : idRef;
upperLeftCornerLumaPixel : idRef;
upperRightEdgeLumaPixels : idRef;
use : idRef;
userType : literalString;
v : idRef;
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
z : idRef;
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
    ;

builtIn
    :   BaryCoordKHR
    |   BaryCoordNoPerspAMD
    |   BaryCoordNoPerspCentroidAMD
    |   BaryCoordNoPerspKHR
    |   BaryCoordNoPerspSampleAMD
    |   BaryCoordPullModelAMD
    |   BaryCoordSmoothAMD
    |   BaryCoordSmoothCentroidAMD
    |   BaryCoordSmoothSampleAMD
    |   BaseInstance
    |   BaseVertex
    |   ClipDistance
    |   ClipDistancePerViewNV
    |   ClusterIDNV
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
    |   FrontFacing
    |   FullyCoveredEXT
    |   GlobalInvocationId
    |   GlobalLinearId
    |   GlobalOffset
    |   GlobalSize
    |   HelperInvocation
    |   HitIsLSSNV
    |   HitIsSphereNV
    |   HitKindBackFacingMicroTriangleNV
    |   HitKindFrontFacingMicroTriangleNV
    |   HitKindKHR
    |   HitLSSPositionsNV
    |   HitLSSRadiiNV
    |   HitMicroTriangleVertexBarycentricsNV
    |   HitMicroTriangleVertexPositionsNV
    |   HitSpherePositionNV
    |   HitSphereRadiusNV
    |   HitTNV
    |   HitTriangleVertexPositionsKHR
    |   IncomingRayFlagsKHR
    |   InstanceCustomIndexKHR
    |   InstanceId
    |   InstanceIndex
    |   InvocationId
    |   LaunchIdKHR
    |   LaunchSizeKHR
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
    |   ObjectRayOriginKHR
    |   ObjectToWorldKHR
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
    |   RayTminKHR
    |   RemainingRecursionLevelsAMDX
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
    |   SubgroupGeMask
    |   SubgroupGtMask
    |   SubgroupId
    |   SubgroupLeMask
    |   SubgroupLocalInvocationId
    |   SubgroupLtMask
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
    |   WorldRayOriginKHR
    |   WorldToObjectKHR
    ;

capability
    :   Addresses
    |   ArbitraryPrecisionFixedPointINTEL
    |   ArbitraryPrecisionFloatingPointINTEL
    |   ArbitraryPrecisionIntegersINTEL
    |   ArithmeticFenceEXT
    |   AsmINTEL
    |   AtomicFloat16AddEXT
    |   AtomicFloat16MinMaxEXT
    |   AtomicFloat16VectorNV
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
    |   ComputeDerivativeGroupLinearKHR
    |   ComputeDerivativeGroupQuadsKHR
    |   CooperativeMatrixBlockLoadsNV
    |   CooperativeMatrixConversionsNV
    |   CooperativeMatrixKHR
    |   CooperativeMatrixLayoutsARM
    |   CooperativeMatrixNV
    |   CooperativeMatrixPerElementOperationsNV
    |   CooperativeMatrixReductionsNV
    |   CooperativeMatrixTensorAddressingNV
    |   CooperativeVectorNV
    |   CooperativeVectorTrainingNV
    |   CoreBuiltinsARM
    |   CullDistance
    |   DebugInfoModuleINTEL
    |   DemoteToHelperInvocation
    |   DenormFlushToZero
    |   DenormPreserve
    |   DerivativeControl
    |   DeviceEnqueue
    |   DeviceGroup
    |   DisplacementMicromapNV
    |   DotProduct
    |   DotProductInput4x8Bit
    |   DotProductInput4x8BitPacked
    |   DotProductInputAll
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
    |   FloatControls2
    |   FloatingPointModeINTEL
    |   FragmentBarycentricKHR
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
    |   InputAttachmentArrayNonUniformIndexing
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
    |   OptNoneEXT
    |   PerViewAttributesNV
    |   PhysicalStorageBufferAddresses
    |   PipeStorage
    |   Pipes
    |   QuadControlKHR
    |   RawAccessChainsNV
    |   RayCullMaskKHR
    |   RayQueryKHR
    |   RayQueryPositionFetchKHR
    |   RayQueryProvisionalKHR
    |   RayTracingClusterAccelerationStructureNV
    |   RayTracingDisplacementMicromapNV
    |   RayTracingKHR
    |   RayTracingLinearSweptSpheresGeometryNV
    |   RayTracingMotionBlurNV
    |   RayTracingNV
    |   RayTracingOpacityMicromapEXT
    |   RayTracingPositionFetchKHR
    |   RayTracingProvisionalKHR
    |   RayTracingSpheresGeometryNV
    |   RayTraversalPrimitiveCullingKHR
    |   RegisterLimitsINTEL
    |   ReplicatedCompositesEXT
    |   RoundToInfinityINTEL
    |   RoundingModeRTE
    |   RoundingModeRTZ
    |   RuntimeAlignedAttributeINTEL
    |   RuntimeDescriptorArray
    |   SampleMaskOverrideCoverageNV
    |   SampleMaskPostDepthCoverage
    |   SampleRateShading
    |   Sampled1D
    |   SampledBuffer
    |   SampledCubeArray
    |   SampledImageArrayDynamicIndexing
    |   SampledImageArrayNonUniformIndexing
    |   SampledRect
    |   Shader
    |   ShaderClockKHR
    |   ShaderEnqueueAMDX
    |   ShaderInvocationReorderNV
    |   ShaderLayer
    |   ShaderNonUniform
    |   ShaderSMBuiltinsNV
    |   ShaderStereoViewNV
    |   ShaderViewportIndex
    |   ShaderViewportIndexLayerEXT
    |   ShaderViewportMaskNV
    |   SignedZeroInfNanPreserve
    |   SparseResidency
    |   SplitBarrierINTEL
    |   StencilExportEXT
    |   StorageBuffer16BitAccess
    |   StorageBuffer8BitAccess
    |   StorageBufferArrayDynamicIndexing
    |   StorageBufferArrayNonUniformIndexing
    |   StorageImageArrayDynamicIndexing
    |   StorageImageArrayNonUniformIndexing
    |   StorageImageExtendedFormats
    |   StorageImageMultisample
    |   StorageImageReadWithoutFormat
    |   StorageImageWriteWithoutFormat
    |   StorageInputOutput16
    |   StoragePushConstant16
    |   StoragePushConstant8
    |   StorageTexelBufferArrayDynamicIndexing
    |   StorageTexelBufferArrayNonUniformIndexing
    |   Subgroup2DBlockIOINTEL
    |   Subgroup2DBlockTransformINTEL
    |   Subgroup2DBlockTransposeINTEL
    |   SubgroupAvcMotionEstimationChromaINTEL
    |   SubgroupAvcMotionEstimationINTEL
    |   SubgroupAvcMotionEstimationIntraINTEL
    |   SubgroupBallotKHR
    |   SubgroupBufferBlockIOINTEL
    |   SubgroupBufferPrefetchINTEL
    |   SubgroupDispatch
    |   SubgroupImageBlockIOINTEL
    |   SubgroupImageMediaBlockIOINTEL
    |   SubgroupMatrixMultiplyAccumulateINTEL
    |   SubgroupShuffleINTEL
    |   SubgroupVoteKHR
    |   TensorAddressingNV
    |   Tessellation
    |   TessellationPointSize
    |   TextureBlockMatch2QCOM
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
    |   UniformDecoration
    |   UniformTexelBufferArrayDynamicIndexing
    |   UniformTexelBufferArrayNonUniformIndexing
    |   UnstructuredLoopControlsINTEL
    |   UntypedPointersKHR
    |   VariableLengthArrayINTEL
    |   VariablePointers
    |   VariablePointersStorageBuffer
    |   Vector16
    |   VectorAnyINTEL
    |   VectorComputeINTEL
    |   VulkanMemoryModel
    |   VulkanMemoryModelDeviceScope
    |   WorkgroupMemoryExplicitLayout16BitAccessKHR
    |   WorkgroupMemoryExplicitLayout8BitAccessKHR
    |   WorkgroupMemoryExplicitLayoutKHR
    ;

componentType
    :   Float16NV
    |   Float32NV
    |   Float64NV
    |   FloatE4M3NV
    |   FloatE5M2NV
    |   SignedInt16NV
    |   SignedInt32NV
    |   SignedInt64NV
    |   SignedInt8NV
    |   SignedInt8PackedNV
    |   UnsignedInt16NV
    |   UnsignedInt32NV
    |   UnsignedInt64NV
    |   UnsignedInt8NV
    |   UnsignedInt8PackedNV
    ;

cooperativeMatrixLayout
    :   ColumnBlockedInterleavedARM
    |   ColumnMajorKHR
    |   RowBlockedInterleavedARM
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

cooperativeMatrixReduce
    :   Column
    |   Def2x2
    |   Row
    ;

cooperativeMatrixUse
    :   MatrixAKHR
    |   MatrixAccumulatorKHR
    |   MatrixBKHR
    ;

cooperativeVectorMatrixLayout
    :   ColumnMajorNV
    |   InferencingOptimalNV
    |   RowMajorNV
    |   TrainingOptimalNV
    ;

decoration
    :   AliasScopeINTEL aliasingScopesList
    |   Aliased
    |   AliasedPointer
    |   Alignment alignmentLiteralInteger
    |   AlignmentId alignmentIdRef
    |   ArrayStride arrayStride
    |   BankBitsINTEL bankBits*
    |   BankwidthINTEL bankWidth
    |   Binding bindingPoint
    |   BindlessImageNV
    |   BindlessSamplerNV
    |   Block
    |   BlockMatchSamplerQCOM
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
    |   DescriptorSet descriptorSetLiteralInteger
    |   DontStaticallyCoalesceINTEL
    |   DoublepumpINTEL
    |   ExplicitInterpAMD
    |   FPFastMathMode fastFPFastMathMode
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
    |   MatrixStride matrixStrideLiteralInteger
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
    |   NodeSharesPayloadLimitsWithAMDX payloadType
    |   NonReadable
    |   NonUniform
    |   NonWritable
    |   NumbanksINTEL banks
    |   Offset byteOffsetLiteralInteger
    |   OverrideCoverageNV
    |   PassthroughNV
    |   Patch
    |   PayloadDispatchIndirectAMDX
    |   PayloadNodeArraySizeAMDX arraySize
    |   PayloadNodeBaseIndexAMDX baseIndex
    |   PayloadNodeNameAMDX nodeName
    |   PayloadNodeSparseArrayAMDX
    |   PerPrimitiveEXT
    |   PerTaskNV
    |   PerVertexKHR
    |   PerViewNV
    |   PipelineEnableINTEL enable
    |   PrefetchINTEL prefetcherSizeInBytes
    |   ReferencedIndirectlyINTEL
    |   RegisterINTEL
    |   RegisterMapKernelArgumentINTEL
    |   RelaxedPrecision
    |   Restrict
    |   RestrictPointer
    |   RowMajor
    |   SIMTCallINTEL nLiteralInteger
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
    |   DerivativeGroupLinearKHR
    |   DerivativeGroupQuadsKHR
    |   EarlyAndLateFragmentTestsAMD
    |   EarlyFragmentTests
    |   FPFastMathDefault targetType fastIdRef
    |   Finalizer
    |   FloatingPointModeALTINTEL targetWidth
    |   FloatingPointModeIEEEINTEL targetWidth
    |   Initializer
    |   InputLines
    |   InputLinesAdjacency
    |   InputPoints
    |   InputTrianglesAdjacency
    |   Invocations numberOf
    |   IsApiEntryAMDX isEntry
    |   Isolines
    |   LocalSize xSizeLiteralInteger ySizeLiteralInteger zSizeLiteralInteger
    |   LocalSizeHint xSizeLiteralInteger ySizeLiteralInteger zSizeLiteralInteger
    |   LocalSizeHintId xSizeHint ySizeHint zSizeHint
    |   LocalSizeId xSizeIdRef ySizeIdRef zSizeIdRef
    |   MaxNodeRecursionAMDX numberOfRecursions
    |   MaxNumWorkgroupsAMDX xSizeIdRef ySizeIdRef zSizeIdRef
    |   MaxWorkDimINTEL max
    |   MaxWorkgroupSizeINTEL max max max
    |   MaximallyReconvergesKHR
    |   MaximumRegistersINTEL numberOfRegistersLiteralInteger
    |   MaximumRegistersIdINTEL numberOfRegistersIdRef
    |   NamedBarrierCountINTEL barrierCount
    |   NamedMaximumRegistersINTEL namedMaximumNumberOfRegisters
    |   NoGlobalOffsetINTEL
    |   NonCoherentColorAttachmentReadEXT
    |   NonCoherentDepthAttachmentReadEXT
    |   NonCoherentStencilAttachmentReadEXT
    |   NumSIMDWorkitemsINTEL vectorLiteralInteger
    |   OriginLowerLeft
    |   OriginUpperLeft
    |   OutputLineStrip
    |   OutputLinesEXT
    |   OutputPoints
    |   OutputPrimitivesEXT primitiveCountLiteralInteger
    |   OutputTriangleStrip
    |   OutputTrianglesEXT
    |   OutputVertices vertexCountLiteralInteger
    |   PixelCenterInteger
    |   PixelInterlockOrderedEXT
    |   PixelInterlockUnorderedEXT
    |   PointMode
    |   PostDepthCoverage
    |   QuadDerivativesKHR
    |   Quads
    |   RegisterMapInterfaceINTEL waitForDoneWrite
    |   RequireFullQuadsKHR
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
    |   SharesInputWithAMDX nodeName shaderIndex
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
    |   CallableKHR
    |   ClosestHitKHR
    |   Fragment
    |   GLCompute
    |   Geometry
    |   IntersectionKHR
    |   Kernel
    |   MeshEXT
    |   MeshNV
    |   MissKHR
    |   RayGenerationKHR
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
    :   AllowContract
    |   AllowReassoc
    |   AllowRecip
    |   AllowTransform
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
    |   OptNoneEXT
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
    |   UnormInt2_101010EXT
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
    |   MakeTexelVisible idScope
    |   MinLod idRef
    |   NonPrivateTexel
    |   None
    |   Nontemporal
    |   Offset idRef
    |   Offsets idRef
    |   Sample idRef
    |   SignExtend
    |   VolatileTexel
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

matrixMultiplyAccumulateOperands
    :   MatrixAPackedBFloat16INTEL
    |   MatrixAPackedFloat16INTEL
    |   MatrixAPackedInt4INTEL
    |   MatrixAPackedInt8INTEL
    |   MatrixASignedComponentsINTEL
    |   MatrixATF32INTEL
    |   MatrixBPackedBFloat16INTEL
    |   MatrixBPackedFloat16INTEL
    |   MatrixBPackedInt4INTEL
    |   MatrixBPackedInt8INTEL
    |   MatrixBSignedComponentsINTEL
    |   MatrixBTF32INTEL
    |   MatrixCBFloat16INTEL
    |   MatrixResultBFloat16INTEL
    |   None
    ;

memoryAccess : memoryAccessTag (Pipe memoryAccessTag)* literalInteger? idRef*;

memoryAccessTag
    :   AliasScopeINTELMask
    |   Aligned
    |   MakePointerAvailable
    |   MakePointerAvailableKHR
    |   MakePointerVisible
    |   MakePointerVisibleKHR
    |   NoAliasINTELMask
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
    ;

memorySemantics
    :   Acquire
    |   AcquireRelease
    |   AtomicCounterMemory
    |   CrossWorkgroupMemory
    |   ImageMemory
    |   MakeAvailable
    |   MakeVisible
    |   OutputMemory
    |   Relaxed
    |   Release
    |   SequentiallyConsistent
    |   SubgroupMemory
    |   UniformMemory
    |   Volatile
    |   WorkgroupMemory
    ;

namedMaximumNumberOfRegisters : AutoINTEL;
overflowModes
    :   SAT
    |   SAT_SYM
    |   SAT_ZERO
    |   WRAP
    ;

packedVectorFormat : PackedVectorFormat4x8Bit;
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

rawAccessChainOperands
    :   None
    |   RobustnessPerComponentNV
    |   RobustnessPerElementNV
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
    |   Rust
    |   SYCL
    |   Slang
    |   Unknown
    |   WGSL
    |   Zig
    ;

storageClass
    :   AtomicCounter
    |   CallableDataKHR
    |   CodeSectionINTEL
    |   CrossWorkgroup
    |   DeviceOnlyINTEL
    |   Function
    |   Generic
    |   HitAttributeKHR
    |   HitObjectAttributeNV
    |   HostOnlyINTEL
    |   Image
    |   IncomingCallableDataKHR
    |   IncomingRayPayloadKHR
    |   Input
    |   NodePayloadAMDX
    |   Output
    |   PhysicalStorageBuffer
    |   Private
    |   PushConstant
    |   RayPayloadKHR
    |   ShaderRecordBufferKHR
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

tensorAddressingOperands
    :   DecodeFunc idRef
    |   None
    |   TensorView idRef
    ;

tensorClampMode
    :   ClampToEdge
    |   Constant
    |   Repeat
    |   RepeatMirrored
    |   Undefined
    ;

// Base types
pairIdRefIdRef : idRef idRef;
pairIdRefLiteralInteger : idRef literalInteger;
pairLiteralIntegerIdRef : literalInteger idRef;
literalContextDependentNumber : LiteralInteger | LiteralFloat;
literanHeaderUnsignedInteger : ModeHeader_PositiveInteger;
initBaseValue : ModeHeader_NegativeInteger | ModeHeader_PositiveInteger;
literalFloat : LiteralFloat;
literalInteger : LiteralInteger;
literalString : LiteralString;
idMemorySemantics : Id;
idRef : Id;
idResult : Id;
idResultType : Id;
idScope : Id;
