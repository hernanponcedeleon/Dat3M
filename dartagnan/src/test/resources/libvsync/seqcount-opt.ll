; ModuleID = '/home/drc/git/Dat3M/output/seqcount.ll'
source_filename = "/home/drc/git/libvsync/test/spinlock/seqcount.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.vatomic32_s = type { i32 }
%union.pthread_attr_t = type { i64, [48 x i8] }

@g_seq_cnt = dso_local global %struct.vatomic32_s zeroinitializer, align 4, !dbg !0
@g_cs_x = dso_local global i32 0, align 4, !dbg !18
@g_cs_y = dso_local global i32 0, align 4, !dbg !21
@.str = private unnamed_addr constant [7 x i8] c"a == b\00", align 1
@.str.1 = private unnamed_addr constant [48 x i8] c"/home/drc/git/libvsync/test/spinlock/seqcount.c\00", align 1
@__PRETTY_FUNCTION__.reader_cs = private unnamed_addr constant [26 x i8] c"void reader_cs(vuint32_t)\00", align 1
@.str.2 = private unnamed_addr constant [14 x i8] c"(s >> 1) == a\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init() #0 !dbg !38 {
  ret void, !dbg !43
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @post() #0 !dbg !44 {
  ret void, !dbg !45
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @fini() #0 !dbg !46 {
  ret void, !dbg !47
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @check() #0 !dbg !48 {
  ret void, !dbg !49
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_acquire(i32 noundef %0) #0 !dbg !50 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !53, metadata !DIExpression()), !dbg !54
  ret void, !dbg !55
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_release(i32 noundef %0) #0 !dbg !56 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !57, metadata !DIExpression()), !dbg !58
  ret void, !dbg !59
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_acquire(i32 noundef %0) #0 !dbg !60 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !61, metadata !DIExpression()), !dbg !62
  ret void, !dbg !63
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_release(i32 noundef %0) #0 !dbg !64 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !65, metadata !DIExpression()), !dbg !66
  ret void, !dbg !67
}

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !68 {
  %1 = alloca [3 x i64], align 16
  call void @llvm.dbg.declare(metadata [3 x i64]* %1, metadata !72, metadata !DIExpression()), !dbg !78
  call void @init(), !dbg !79
  call void @llvm.dbg.value(metadata i64 0, metadata !80, metadata !DIExpression()), !dbg !82
  call void @llvm.dbg.value(metadata i64 0, metadata !80, metadata !DIExpression()), !dbg !82
  %2 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 0, !dbg !83
  %3 = call i32 @pthread_create(i64* noundef %2, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @writer, i8* noundef null) #5, !dbg !86
  call void @llvm.dbg.value(metadata i64 1, metadata !80, metadata !DIExpression()), !dbg !82
  call void @llvm.dbg.value(metadata i64 1, metadata !80, metadata !DIExpression()), !dbg !82
  call void @llvm.dbg.value(metadata i64 1, metadata !87, metadata !DIExpression()), !dbg !89
  call void @llvm.dbg.value(metadata i64 1, metadata !87, metadata !DIExpression()), !dbg !89
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 1, !dbg !90
  %5 = call i32 @pthread_create(i64* noundef %4, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef inttoptr (i64 1 to i8*)) #5, !dbg !93
  call void @llvm.dbg.value(metadata i64 2, metadata !87, metadata !DIExpression()), !dbg !89
  call void @llvm.dbg.value(metadata i64 2, metadata !87, metadata !DIExpression()), !dbg !89
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %1, i64 0, i64 2, !dbg !90
  %7 = call i32 @pthread_create(i64* noundef %6, %union.pthread_attr_t* noundef null, i8* (i8*)* noundef @reader, i8* noundef inttoptr (i64 2 to i8*)) #5, !dbg !93
  call void @llvm.dbg.value(metadata i64 3, metadata !87, metadata !DIExpression()), !dbg !89
  call void @llvm.dbg.value(metadata i64 3, metadata !87, metadata !DIExpression()), !dbg !89
  call void @post(), !dbg !94
  call void @llvm.dbg.value(metadata i64 0, metadata !95, metadata !DIExpression()), !dbg !97
  call void @llvm.dbg.value(metadata i64 0, metadata !95, metadata !DIExpression()), !dbg !97
  %8 = load i64, i64* %2, align 8, !dbg !98
  %9 = call i32 @pthread_join(i64 noundef %8, i8** noundef null), !dbg !101
  call void @llvm.dbg.value(metadata i64 1, metadata !95, metadata !DIExpression()), !dbg !97
  call void @llvm.dbg.value(metadata i64 1, metadata !95, metadata !DIExpression()), !dbg !97
  %10 = load i64, i64* %4, align 8, !dbg !98
  %11 = call i32 @pthread_join(i64 noundef %10, i8** noundef null), !dbg !101
  call void @llvm.dbg.value(metadata i64 2, metadata !95, metadata !DIExpression()), !dbg !97
  call void @llvm.dbg.value(metadata i64 2, metadata !95, metadata !DIExpression()), !dbg !97
  %12 = load i64, i64* %6, align 8, !dbg !98
  %13 = call i32 @pthread_join(i64 noundef %12, i8** noundef null), !dbg !101
  call void @llvm.dbg.value(metadata i64 3, metadata !95, metadata !DIExpression()), !dbg !97
  call void @llvm.dbg.value(metadata i64 3, metadata !95, metadata !DIExpression()), !dbg !97
  call void @check(), !dbg !102
  call void @fini(), !dbg !103
  ret i32 0, !dbg !104
}

; Function Attrs: nounwind
declare i32 @pthread_create(i64* noundef, %union.pthread_attr_t* noundef, i8* (i8*)* noundef, i8* noundef) #2

; Function Attrs: noinline nounwind uwtable
define internal i8* @writer(i8* noundef %0) #0 !dbg !105 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !108, metadata !DIExpression()), !dbg !109
  %2 = ptrtoint i8* %0 to i64, !dbg !110
  %3 = trunc i64 %2 to i32, !dbg !111
  call void @llvm.dbg.value(metadata i32 %3, metadata !112, metadata !DIExpression()), !dbg !109
  call void @writer_acquire(i32 noundef %3), !dbg !113
  call void @writer_cs(i32 noundef %3), !dbg !114
  call void @writer_release(i32 noundef %3), !dbg !115
  ret i8* null, !dbg !116
}

; Function Attrs: noinline nounwind uwtable
define internal i8* @reader(i8* noundef %0) #0 !dbg !117 {
  call void @llvm.dbg.value(metadata i8* %0, metadata !118, metadata !DIExpression()), !dbg !119
  %2 = ptrtoint i8* %0 to i64, !dbg !120
  %3 = trunc i64 %2 to i32, !dbg !121
  call void @llvm.dbg.value(metadata i32 %3, metadata !122, metadata !DIExpression()), !dbg !119
  call void @reader_acquire(i32 noundef %3), !dbg !123
  call void @reader_cs(i32 noundef %3), !dbg !124
  call void @reader_release(i32 noundef %3), !dbg !125
  ret i8* null, !dbg !126
}

declare i32 @pthread_join(i64 noundef, i8** noundef) #3

; Function Attrs: noinline nounwind uwtable
define dso_local void @writer_cs(i32 noundef %0) #0 !dbg !127 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !128, metadata !DIExpression()), !dbg !129
  %2 = call i32 @seqcount_wbegin(%struct.vatomic32_s* noundef @g_seq_cnt), !dbg !130
  call void @llvm.dbg.value(metadata i32 %2, metadata !131, metadata !DIExpression()), !dbg !129
  %3 = load i32, i32* @g_cs_x, align 4, !dbg !133
  %4 = add i32 %3, 1, !dbg !133
  store i32 %4, i32* @g_cs_x, align 4, !dbg !133
  %5 = load i32, i32* @g_cs_y, align 4, !dbg !134
  %6 = add i32 %5, 1, !dbg !134
  store i32 %6, i32* @g_cs_y, align 4, !dbg !134
  call void @seqcount_wend(%struct.vatomic32_s* noundef @g_seq_cnt, i32 noundef %2), !dbg !135
  ret void, !dbg !136
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @seqcount_wbegin(%struct.vatomic32_s* noundef %0) #0 !dbg !137 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !141, metadata !DIExpression()), !dbg !142
  %2 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !143
  call void @llvm.dbg.value(metadata i32 %2, metadata !144, metadata !DIExpression()), !dbg !142
  %3 = add i32 %2, 1, !dbg !145
  call void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %3), !dbg !146
  call void @vatomic_fence_rel(), !dbg !147
  ret i32 %2, !dbg !148
}

; Function Attrs: noinline nounwind uwtable
define internal void @seqcount_wend(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !149 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !152, metadata !DIExpression()), !dbg !153
  call void @llvm.dbg.value(metadata i32 %1, metadata !154, metadata !DIExpression()), !dbg !153
  %3 = add i32 %1, 2, !dbg !155
  call void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %3), !dbg !156
  ret void, !dbg !157
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @reader_cs(i32 noundef %0) #0 !dbg !158 {
  call void @llvm.dbg.value(metadata i32 %0, metadata !159, metadata !DIExpression()), !dbg !160
  call void @llvm.dbg.value(metadata i32 0, metadata !161, metadata !DIExpression()), !dbg !160
  call void @llvm.dbg.value(metadata i32 0, metadata !162, metadata !DIExpression()), !dbg !160
  call void @llvm.dbg.value(metadata i32 0, metadata !163, metadata !DIExpression()), !dbg !160
  br label %2, !dbg !164

2:                                                ; preds = %2, %1
  %3 = call i32 @seqcount_rbegin(%struct.vatomic32_s* noundef @g_seq_cnt), !dbg !165
  call void @llvm.dbg.value(metadata i32 %3, metadata !163, metadata !DIExpression()), !dbg !160
  %4 = load i32, i32* @g_cs_x, align 4, !dbg !167
  call void @llvm.dbg.value(metadata i32 %4, metadata !161, metadata !DIExpression()), !dbg !160
  %5 = load i32, i32* @g_cs_y, align 4, !dbg !168
  call void @llvm.dbg.value(metadata i32 %5, metadata !162, metadata !DIExpression()), !dbg !160
  %6 = call zeroext i1 @seqcount_rend(%struct.vatomic32_s* noundef @g_seq_cnt, i32 noundef %3), !dbg !169
  %7 = xor i1 %6, true, !dbg !169
  br i1 %7, label %2, label %8, !dbg !170, !llvm.loop !171

8:                                                ; preds = %2
  %9 = icmp eq i32 %4, %5, !dbg !173
  br i1 %9, label %11, label %10, !dbg !176

10:                                               ; preds = %8
  call void @__assert_fail(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.1, i64 0, i64 0), i32 noundef 37, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #6, !dbg !173
  unreachable, !dbg !173

11:                                               ; preds = %8
  %12 = lshr i32 %3, 1, !dbg !177
  %13 = icmp eq i32 %12, %4, !dbg !177
  br i1 %13, label %15, label %14, !dbg !180

14:                                               ; preds = %11
  call void @__assert_fail(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([48 x i8], [48 x i8]* @.str.1, i64 0, i64 0), i32 noundef 38, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.reader_cs, i64 0, i64 0)) #6, !dbg !177
  unreachable, !dbg !177

15:                                               ; preds = %11
  ret void, !dbg !181
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @seqcount_rbegin(%struct.vatomic32_s* noundef %0) #0 !dbg !182 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !183, metadata !DIExpression()), !dbg !184
  %2 = call i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0), !dbg !185
  %3 = and i32 %2, -2, !dbg !186
  call void @llvm.dbg.value(metadata i32 %3, metadata !187, metadata !DIExpression()), !dbg !184
  ret i32 %3, !dbg !188
}

; Function Attrs: noinline nounwind uwtable
define internal zeroext i1 @seqcount_rend(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !189 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !194, metadata !DIExpression()), !dbg !195
  call void @llvm.dbg.value(metadata i32 %1, metadata !196, metadata !DIExpression()), !dbg !195
  call void @vatomic_fence_acq(), !dbg !197
  %3 = call i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0), !dbg !198
  %4 = icmp eq i32 %3, %1, !dbg !199
  ret i1 %4, !dbg !200
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_rlx(%struct.vatomic32_s* noundef %0) #0 !dbg !201 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !206, metadata !DIExpression()), !dbg !207
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !208, !srcloc !209
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !210
  %3 = load atomic i32, i32* %2 monotonic, align 4, !dbg !211
  call void @llvm.dbg.value(metadata i32 %3, metadata !212, metadata !DIExpression()), !dbg !207
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !213, !srcloc !214
  ret i32 %3, !dbg !215
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rlx(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !216 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !219, metadata !DIExpression()), !dbg !220
  call void @llvm.dbg.value(metadata i32 %1, metadata !221, metadata !DIExpression()), !dbg !220
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !222, !srcloc !223
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !224
  store atomic i32 %1, i32* %3 monotonic, align 4, !dbg !225
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !226, !srcloc !227
  ret void, !dbg !228
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_rel() #0 !dbg !229 {
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !230, !srcloc !231
  fence release, !dbg !232
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !233, !srcloc !234
  ret void, !dbg !235
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic32_write_rel(%struct.vatomic32_s* noundef %0, i32 noundef %1) #0 !dbg !236 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !237, metadata !DIExpression()), !dbg !238
  call void @llvm.dbg.value(metadata i32 %1, metadata !239, metadata !DIExpression()), !dbg !238
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !240, !srcloc !241
  %3 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !242
  store atomic i32 %1, i32* %3 release, align 4, !dbg !243
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !244, !srcloc !245
  ret void, !dbg !246
}

; Function Attrs: noinline nounwind uwtable
define internal i32 @vatomic32_read_acq(%struct.vatomic32_s* noundef %0) #0 !dbg !247 {
  call void @llvm.dbg.value(metadata %struct.vatomic32_s* %0, metadata !248, metadata !DIExpression()), !dbg !249
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !250, !srcloc !251
  %2 = getelementptr inbounds %struct.vatomic32_s, %struct.vatomic32_s* %0, i32 0, i32 0, !dbg !252
  %3 = load atomic i32, i32* %2 acquire, align 4, !dbg !253
  call void @llvm.dbg.value(metadata i32 %3, metadata !254, metadata !DIExpression()), !dbg !249
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !255, !srcloc !256
  ret i32 %3, !dbg !257
}

; Function Attrs: noinline nounwind uwtable
define internal void @vatomic_fence_acq() #0 !dbg !258 {
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !259, !srcloc !260
  fence acquire, !dbg !261
  call void asm sideeffect "", "~{memory},~{dirflag},~{fpsr},~{flags}"() #5, !dbg !262, !srcloc !263
  ret void, !dbg !264
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!30, !31, !32, !33, !34, !35, !36}
!llvm.ident = !{!37}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_seq_cnt", scope: !2, file: !20, line: 10, type: !23, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/drc/git/libvsync/test/spinlock/seqcount.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "4d0bb3c248effb73a88a54363e861ec2")
!4 = !{!5, !6, !13}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuint32_t", file: !7, line: 34, baseType: !8)
!7 = !DIFile(filename: "./include/vsync/vtypes.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "6ac6784bf37e03e28013e7eed706797e")
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !9, line: 26, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "", checksumkind: CSK_MD5, checksum: "2bf2ae53c58c01b1a1b9383b5195125c")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !11, line: 42, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "d108b5f93a74c50510d7d9bc0ab36df9")
!12 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "vuintptr_t", file: !7, line: 36, baseType: !14)
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !15, line: 90, baseType: !16)
!15 = !DIFile(filename: "/usr/include/stdint.h", directory: "", checksumkind: CSK_MD5, checksum: "a48e64edacc5b19f56c99745232c963c")
!16 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!17 = !{!0, !18, !21}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "g_cs_x", scope: !2, file: !20, line: 11, type: !6, isLocal: false, isDefinition: true)
!20 = !DIFile(filename: "test/spinlock/seqcount.c", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "4d0bb3c248effb73a88a54363e861ec2")
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "g_cs_y", scope: !2, file: !20, line: 11, type: !6, isLocal: false, isDefinition: true)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqcount_t", file: !24, line: 27, baseType: !25)
!24 = !DIFile(filename: "./include/vsync/spinlock/seqcount.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "f37dde5f37d0e12bb2663f07ba9d34d0")
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "vatomic32_t", file: !26, line: 62, baseType: !27)
!26 = !DIFile(filename: "./include/vsync/atomic/core.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "1cc0657a82f0605ef67642f178a77e1c")
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vatomic32_s", file: !26, line: 60, size: 32, align: 32, elements: !28)
!28 = !{!29}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "_v", scope: !27, file: !26, line: 61, baseType: !6, size: 32)
!30 = !{i32 7, !"Dwarf Version", i32 5}
!31 = !{i32 2, !"Debug Info Version", i32 3}
!32 = !{i32 1, !"wchar_size", i32 4}
!33 = !{i32 7, !"PIC Level", i32 2}
!34 = !{i32 7, !"PIE Level", i32 2}
!35 = !{i32 7, !"uwtable", i32 1}
!36 = !{i32 7, !"frame-pointer", i32 2}
!37 = !{!"Ubuntu clang version 14.0.0-1ubuntu1"}
!38 = distinct !DISubprogram(name: "init", scope: !39, file: !39, line: 49, type: !40, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!39 = !DIFile(filename: "./include/test/boilerplate/reader_writer.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "54e4a8b6c91c55a7191ad9a8296bf783")
!40 = !DISubroutineType(types: !41)
!41 = !{null}
!42 = !{}
!43 = !DILocation(line: 51, column: 1, scope: !38)
!44 = distinct !DISubprogram(name: "post", scope: !39, file: !39, line: 58, type: !40, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!45 = !DILocation(line: 60, column: 1, scope: !44)
!46 = distinct !DISubprogram(name: "fini", scope: !39, file: !39, line: 67, type: !40, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!47 = !DILocation(line: 69, column: 1, scope: !46)
!48 = distinct !DISubprogram(name: "check", scope: !39, file: !39, line: 76, type: !40, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!49 = !DILocation(line: 78, column: 1, scope: !48)
!50 = distinct !DISubprogram(name: "writer_acquire", scope: !39, file: !39, line: 80, type: !51, scopeLine: 81, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!51 = !DISubroutineType(types: !52)
!52 = !{null, !6}
!53 = !DILocalVariable(name: "tid", arg: 1, scope: !50, file: !39, line: 80, type: !6)
!54 = !DILocation(line: 0, scope: !50)
!55 = !DILocation(line: 83, column: 1, scope: !50)
!56 = distinct !DISubprogram(name: "writer_release", scope: !39, file: !39, line: 85, type: !51, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!57 = !DILocalVariable(name: "tid", arg: 1, scope: !56, file: !39, line: 85, type: !6)
!58 = !DILocation(line: 0, scope: !56)
!59 = !DILocation(line: 88, column: 1, scope: !56)
!60 = distinct !DISubprogram(name: "reader_acquire", scope: !39, file: !39, line: 90, type: !51, scopeLine: 91, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!61 = !DILocalVariable(name: "tid", arg: 1, scope: !60, file: !39, line: 90, type: !6)
!62 = !DILocation(line: 0, scope: !60)
!63 = !DILocation(line: 93, column: 1, scope: !60)
!64 = distinct !DISubprogram(name: "reader_release", scope: !39, file: !39, line: 95, type: !51, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!65 = !DILocalVariable(name: "tid", arg: 1, scope: !64, file: !39, line: 95, type: !6)
!66 = !DILocation(line: 0, scope: !64)
!67 = !DILocation(line: 98, column: 1, scope: !64)
!68 = distinct !DISubprogram(name: "main", scope: !39, file: !39, line: 153, type: !69, scopeLine: 154, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!69 = !DISubroutineType(types: !70)
!70 = !{!71}
!71 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!72 = !DILocalVariable(name: "t", scope: !68, file: !39, line: 155, type: !73)
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !74, size: 192, elements: !76)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !75, line: 27, baseType: !16)
!75 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "", checksumkind: CSK_MD5, checksum: "735e3bf264ff9d8f5d95898b1692fbdb")
!76 = !{!77}
!77 = !DISubrange(count: 3)
!78 = !DILocation(line: 155, column: 12, scope: !68)
!79 = !DILocation(line: 162, column: 2, scope: !68)
!80 = !DILocalVariable(name: "i", scope: !81, file: !39, line: 164, type: !13)
!81 = distinct !DILexicalBlock(scope: !68, file: !39, line: 164, column: 2)
!82 = !DILocation(line: 0, scope: !81)
!83 = !DILocation(line: 165, column: 25, scope: !84)
!84 = distinct !DILexicalBlock(scope: !85, file: !39, line: 164, column: 44)
!85 = distinct !DILexicalBlock(scope: !81, file: !39, line: 164, column: 2)
!86 = !DILocation(line: 165, column: 9, scope: !84)
!87 = !DILocalVariable(name: "i", scope: !88, file: !39, line: 168, type: !13)
!88 = distinct !DILexicalBlock(scope: !68, file: !39, line: 168, column: 2)
!89 = !DILocation(line: 0, scope: !88)
!90 = !DILocation(line: 169, column: 25, scope: !91)
!91 = distinct !DILexicalBlock(scope: !92, file: !39, line: 168, column: 51)
!92 = distinct !DILexicalBlock(scope: !88, file: !39, line: 168, column: 2)
!93 = !DILocation(line: 169, column: 9, scope: !91)
!94 = !DILocation(line: 172, column: 2, scope: !68)
!95 = !DILocalVariable(name: "i", scope: !96, file: !39, line: 174, type: !13)
!96 = distinct !DILexicalBlock(scope: !68, file: !39, line: 174, column: 2)
!97 = !DILocation(line: 0, scope: !96)
!98 = !DILocation(line: 175, column: 22, scope: !99)
!99 = distinct !DILexicalBlock(scope: !100, file: !39, line: 174, column: 44)
!100 = distinct !DILexicalBlock(scope: !96, file: !39, line: 174, column: 2)
!101 = !DILocation(line: 175, column: 9, scope: !99)
!102 = !DILocation(line: 183, column: 2, scope: !68)
!103 = !DILocation(line: 184, column: 2, scope: !68)
!104 = !DILocation(line: 186, column: 2, scope: !68)
!105 = distinct !DISubprogram(name: "writer", scope: !39, file: !39, line: 132, type: !106, scopeLine: 133, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!106 = !DISubroutineType(types: !107)
!107 = !{!5, !5}
!108 = !DILocalVariable(name: "arg", arg: 1, scope: !105, file: !39, line: 132, type: !5)
!109 = !DILocation(line: 0, scope: !105)
!110 = !DILocation(line: 134, column: 29, scope: !105)
!111 = !DILocation(line: 134, column: 18, scope: !105)
!112 = !DILocalVariable(name: "tid", scope: !105, file: !39, line: 134, type: !6)
!113 = !DILocation(line: 135, column: 2, scope: !105)
!114 = !DILocation(line: 136, column: 2, scope: !105)
!115 = !DILocation(line: 137, column: 2, scope: !105)
!116 = !DILocation(line: 138, column: 2, scope: !105)
!117 = distinct !DISubprogram(name: "reader", scope: !39, file: !39, line: 142, type: !106, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!118 = !DILocalVariable(name: "arg", arg: 1, scope: !117, file: !39, line: 142, type: !5)
!119 = !DILocation(line: 0, scope: !117)
!120 = !DILocation(line: 144, column: 29, scope: !117)
!121 = !DILocation(line: 144, column: 18, scope: !117)
!122 = !DILocalVariable(name: "tid", scope: !117, file: !39, line: 144, type: !6)
!123 = !DILocation(line: 145, column: 2, scope: !117)
!124 = !DILocation(line: 146, column: 2, scope: !117)
!125 = !DILocation(line: 147, column: 2, scope: !117)
!126 = !DILocation(line: 149, column: 2, scope: !117)
!127 = distinct !DISubprogram(name: "writer_cs", scope: !20, file: !20, line: 14, type: !51, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!128 = !DILocalVariable(name: "tid", arg: 1, scope: !127, file: !20, line: 14, type: !6)
!129 = !DILocation(line: 0, scope: !127)
!130 = !DILocation(line: 17, column: 17, scope: !127)
!131 = !DILocalVariable(name: "s", scope: !127, file: !20, line: 17, type: !132)
!132 = !DIDerivedType(tag: DW_TAG_typedef, name: "seqvalue_t", file: !24, line: 28, baseType: !6)
!133 = !DILocation(line: 18, column: 8, scope: !127)
!134 = !DILocation(line: 19, column: 8, scope: !127)
!135 = !DILocation(line: 20, column: 2, scope: !127)
!136 = !DILocation(line: 21, column: 1, scope: !127)
!137 = distinct !DISubprogram(name: "seqcount_wbegin", scope: !24, file: !24, line: 60, type: !138, scopeLine: 61, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!138 = !DISubroutineType(types: !139)
!139 = !{!132, !140}
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!141 = !DILocalVariable(name: "sc", arg: 1, scope: !137, file: !24, line: 60, type: !140)
!142 = !DILocation(line: 0, scope: !137)
!143 = !DILocation(line: 62, column: 17, scope: !137)
!144 = !DILocalVariable(name: "s", scope: !137, file: !24, line: 62, type: !132)
!145 = !DILocation(line: 63, column: 28, scope: !137)
!146 = !DILocation(line: 63, column: 2, scope: !137)
!147 = !DILocation(line: 64, column: 2, scope: !137)
!148 = !DILocation(line: 65, column: 2, scope: !137)
!149 = distinct !DISubprogram(name: "seqcount_wend", scope: !24, file: !24, line: 74, type: !150, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!150 = !DISubroutineType(types: !151)
!151 = !{null, !140, !132}
!152 = !DILocalVariable(name: "sc", arg: 1, scope: !149, file: !24, line: 74, type: !140)
!153 = !DILocation(line: 0, scope: !149)
!154 = !DILocalVariable(name: "s", arg: 2, scope: !149, file: !24, line: 74, type: !132)
!155 = !DILocation(line: 76, column: 28, scope: !149)
!156 = !DILocation(line: 76, column: 2, scope: !149)
!157 = !DILocation(line: 77, column: 1, scope: !149)
!158 = distinct !DISubprogram(name: "reader_cs", scope: !20, file: !20, line: 24, type: !51, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !42)
!159 = !DILocalVariable(name: "tid", arg: 1, scope: !158, file: !20, line: 24, type: !6)
!160 = !DILocation(line: 0, scope: !158)
!161 = !DILocalVariable(name: "a", scope: !158, file: !20, line: 26, type: !6)
!162 = !DILocalVariable(name: "b", scope: !158, file: !20, line: 27, type: !6)
!163 = !DILocalVariable(name: "s", scope: !158, file: !20, line: 28, type: !132)
!164 = !DILocation(line: 30, column: 2, scope: !158)
!165 = !DILocation(line: 31, column: 7, scope: !166)
!166 = distinct !DILexicalBlock(scope: !158, file: !20, line: 30, column: 11)
!167 = !DILocation(line: 32, column: 7, scope: !166)
!168 = !DILocation(line: 33, column: 7, scope: !166)
!169 = !DILocation(line: 35, column: 2, scope: !158)
!170 = !DILocation(line: 34, column: 2, scope: !166)
!171 = distinct !{!171, !164, !169, !172}
!172 = !{!"llvm.loop.mustprogress"}
!173 = !DILocation(line: 37, column: 2, scope: !174)
!174 = distinct !DILexicalBlock(scope: !175, file: !20, line: 37, column: 2)
!175 = distinct !DILexicalBlock(scope: !158, file: !20, line: 37, column: 2)
!176 = !DILocation(line: 37, column: 2, scope: !175)
!177 = !DILocation(line: 38, column: 2, scope: !178)
!178 = distinct !DILexicalBlock(scope: !179, file: !20, line: 38, column: 2)
!179 = distinct !DILexicalBlock(scope: !158, file: !20, line: 38, column: 2)
!180 = !DILocation(line: 38, column: 2, scope: !179)
!181 = !DILocation(line: 41, column: 1, scope: !158)
!182 = distinct !DISubprogram(name: "seqcount_rbegin", scope: !24, file: !24, line: 87, type: !138, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!183 = !DILocalVariable(name: "sc", arg: 1, scope: !182, file: !24, line: 87, type: !140)
!184 = !DILocation(line: 0, scope: !182)
!185 = !DILocation(line: 89, column: 17, scope: !182)
!186 = !DILocation(line: 89, column: 40, scope: !182)
!187 = !DILocalVariable(name: "s", scope: !182, file: !24, line: 89, type: !132)
!188 = !DILocation(line: 90, column: 2, scope: !182)
!189 = distinct !DISubprogram(name: "seqcount_rend", scope: !24, file: !24, line: 102, type: !190, scopeLine: 103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!190 = !DISubroutineType(types: !191)
!191 = !{!192, !140, !132}
!192 = !DIDerivedType(tag: DW_TAG_typedef, name: "vbool_t", file: !7, line: 43, baseType: !193)
!193 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!194 = !DILocalVariable(name: "sc", arg: 1, scope: !189, file: !24, line: 102, type: !140)
!195 = !DILocation(line: 0, scope: !189)
!196 = !DILocalVariable(name: "s", arg: 2, scope: !189, file: !24, line: 102, type: !132)
!197 = !DILocation(line: 104, column: 2, scope: !189)
!198 = !DILocation(line: 105, column: 9, scope: !189)
!199 = !DILocation(line: 105, column: 32, scope: !189)
!200 = !DILocation(line: 105, column: 2, scope: !189)
!201 = distinct !DISubprogram(name: "vatomic32_read_rlx", scope: !202, file: !202, line: 193, type: !203, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!202 = !DIFile(filename: "./include/vsync/atomic/internal/builtins.h", directory: "/home/drc/git/libvsync", checksumkind: CSK_MD5, checksum: "31d9a9647b315cadb2f817a7c8e98ecf")
!203 = !DISubroutineType(types: !204)
!204 = !{!6, !205}
!205 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!206 = !DILocalVariable(name: "a", arg: 1, scope: !201, file: !202, line: 193, type: !205)
!207 = !DILocation(line: 0, scope: !201)
!208 = !DILocation(line: 195, column: 2, scope: !201)
!209 = !{i64 2147852378}
!210 = !DILocation(line: 197, column: 7, scope: !201)
!211 = !DILocation(line: 196, column: 29, scope: !201)
!212 = !DILocalVariable(name: "tmp", scope: !201, file: !202, line: 196, type: !6)
!213 = !DILocation(line: 198, column: 2, scope: !201)
!214 = !{i64 2147852424}
!215 = !DILocation(line: 199, column: 2, scope: !201)
!216 = distinct !DISubprogram(name: "vatomic32_write_rlx", scope: !202, file: !202, line: 451, type: !217, scopeLine: 452, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!217 = !DISubroutineType(types: !218)
!218 = !{null, !205, !6}
!219 = !DILocalVariable(name: "a", arg: 1, scope: !216, file: !202, line: 451, type: !205)
!220 = !DILocation(line: 0, scope: !216)
!221 = !DILocalVariable(name: "v", arg: 2, scope: !216, file: !202, line: 451, type: !6)
!222 = !DILocation(line: 453, column: 2, scope: !216)
!223 = !{i64 2147853890}
!224 = !DILocation(line: 454, column: 23, scope: !216)
!225 = !DILocation(line: 454, column: 2, scope: !216)
!226 = !DILocation(line: 455, column: 2, scope: !216)
!227 = !{i64 2147853936}
!228 = !DILocation(line: 456, column: 1, scope: !216)
!229 = distinct !DISubprogram(name: "vatomic_fence_rel", scope: !202, file: !202, line: 45, type: !40, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!230 = !DILocation(line: 47, column: 2, scope: !229)
!231 = !{i64 2147851614}
!232 = !DILocation(line: 48, column: 2, scope: !229)
!233 = !DILocation(line: 49, column: 2, scope: !229)
!234 = !{i64 2147851660}
!235 = !DILocation(line: 50, column: 1, scope: !229)
!236 = distinct !DISubprogram(name: "vatomic32_write_rel", scope: !202, file: !202, line: 438, type: !217, scopeLine: 439, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!237 = !DILocalVariable(name: "a", arg: 1, scope: !236, file: !202, line: 438, type: !205)
!238 = !DILocation(line: 0, scope: !236)
!239 = !DILocalVariable(name: "v", arg: 2, scope: !236, file: !202, line: 438, type: !6)
!240 = !DILocation(line: 440, column: 2, scope: !236)
!241 = !{i64 2147853806}
!242 = !DILocation(line: 441, column: 23, scope: !236)
!243 = !DILocation(line: 441, column: 2, scope: !236)
!244 = !DILocation(line: 442, column: 2, scope: !236)
!245 = !{i64 2147853852}
!246 = !DILocation(line: 443, column: 1, scope: !236)
!247 = distinct !DISubprogram(name: "vatomic32_read_acq", scope: !202, file: !202, line: 178, type: !203, scopeLine: 179, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!248 = !DILocalVariable(name: "a", arg: 1, scope: !247, file: !202, line: 178, type: !205)
!249 = !DILocation(line: 0, scope: !247)
!250 = !DILocation(line: 180, column: 2, scope: !247)
!251 = !{i64 2147852294}
!252 = !DILocation(line: 182, column: 7, scope: !247)
!253 = !DILocation(line: 181, column: 29, scope: !247)
!254 = !DILocalVariable(name: "tmp", scope: !247, file: !202, line: 181, type: !6)
!255 = !DILocation(line: 183, column: 2, scope: !247)
!256 = !{i64 2147852340}
!257 = !DILocation(line: 184, column: 2, scope: !247)
!258 = distinct !DISubprogram(name: "vatomic_fence_acq", scope: !202, file: !202, line: 32, type: !40, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !42)
!259 = !DILocation(line: 34, column: 2, scope: !258)
!260 = !{i64 2147851530}
!261 = !DILocation(line: 35, column: 2, scope: !258)
!262 = !DILocation(line: 36, column: 2, scope: !258)
!263 = !{i64 2147851576}
!264 = !DILocation(line: 37, column: 1, scope: !258)
