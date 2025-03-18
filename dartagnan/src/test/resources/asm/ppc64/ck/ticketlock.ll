; ModuleID = 'tests/ticketlock.c'
source_filename = "tests/ticketlock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.ck_spinlock_ticket = type { i32, i32 }

@x = global i32 0, align 4, !dbg !0
@y = global i32 0, align 4, !dbg !18
@ticket_lock = global ptr null, align 8, !dbg !38
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !21
@.str = private unnamed_addr constant [13 x i8] c"ticketlock.c\00", align 1, !dbg !28
@.str.1 = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !33

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define ptr @run(ptr noundef %0) #0 !dbg !48 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr @ticket_lock, align 8, !dbg !54
  call void @ck_spinlock_ticket_lock(ptr noundef %3), !dbg !55
  %4 = load i32, ptr @x, align 4, !dbg !56
  %5 = add nsw i32 %4, 1, !dbg !56
  store i32 %5, ptr @x, align 4, !dbg !56
  %6 = load i32, ptr @y, align 4, !dbg !57
  %7 = add nsw i32 %6, 1, !dbg !57
  store i32 %7, ptr @y, align 4, !dbg !57
  %8 = load ptr, ptr @ticket_lock, align 8, !dbg !58
  call void @ck_spinlock_ticket_unlock(ptr noundef %8), !dbg !59
  ret ptr null, !dbg !60
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_ticket_lock(ptr noundef %0) #0 !dbg !61 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !69
  %5 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %4, i32 0, i32 0, !dbg !70
  %6 = call i32 @ck_pr_faa_uint(ptr noundef %5, i32 noundef 1), !dbg !71
  store i32 %6, ptr %3, align 4, !dbg !72
  br label %7, !dbg !73

7:                                                ; preds = %13, %1
  %8 = load ptr, ptr %2, align 8, !dbg !74
  %9 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %8, i32 0, i32 1, !dbg !74
  %10 = call i32 @ck_pr_md_load_uint(ptr noundef %9), !dbg !74
  %11 = load i32, ptr %3, align 4, !dbg !75
  %12 = icmp ne i32 %10, %11, !dbg !76
  br i1 %12, label %13, label %14, !dbg !73

13:                                               ; preds = %7
  call void @ck_pr_stall(), !dbg !77
  br label %7, !dbg !73, !llvm.loop !78

14:                                               ; preds = %7
  call void @ck_pr_fence_lock(), !dbg !81
  ret void, !dbg !82
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_ticket_unlock(ptr noundef %0) #0 !dbg !83 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  call void @ck_pr_fence_unlock(), !dbg !88
  %4 = load ptr, ptr %2, align 8, !dbg !89
  %5 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %4, i32 0, i32 1, !dbg !89
  %6 = call i32 @ck_pr_md_load_uint(ptr noundef %5), !dbg !89
  store i32 %6, ptr %3, align 4, !dbg !90
  %7 = load ptr, ptr %2, align 8, !dbg !91
  %8 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %7, i32 0, i32 1, !dbg !91
  %9 = load i32, ptr %3, align 4, !dbg !91
  %10 = add i32 %9, 1, !dbg !91
  call void @ck_pr_md_store_uint(ptr noundef %8, i32 noundef %10), !dbg !91
  ret void, !dbg !92
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 !dbg !93 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  %4 = call ptr @malloc(i64 noundef 8) #5, !dbg !126
  store ptr %4, ptr @ticket_lock, align 8, !dbg !127
  %5 = load ptr, ptr @ticket_lock, align 8, !dbg !128
  call void @ck_spinlock_ticket_init(ptr noundef %5), !dbg !129
  store i32 0, ptr %3, align 4, !dbg !130
  br label %6, !dbg !132

6:                                                ; preds = %17, %0
  %7 = load i32, ptr %3, align 4, !dbg !133
  %8 = icmp slt i32 %7, 3, !dbg !135
  br i1 %8, label %9, label %20, !dbg !136

9:                                                ; preds = %6
  %10 = load i32, ptr %3, align 4, !dbg !137
  %11 = sext i32 %10 to i64, !dbg !140
  %12 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %11, !dbg !140
  %13 = call i32 @pthread_create(ptr noundef %12, ptr noundef null, ptr noundef @run, ptr noundef null), !dbg !141
  %14 = icmp ne i32 %13, 0, !dbg !142
  br i1 %14, label %15, label %16, !dbg !143

15:                                               ; preds = %9
  call void @exit(i32 noundef 1) #6, !dbg !144
  unreachable, !dbg !144

16:                                               ; preds = %9
  br label %17, !dbg !146

17:                                               ; preds = %16
  %18 = load i32, ptr %3, align 4, !dbg !147
  %19 = add nsw i32 %18, 1, !dbg !147
  store i32 %19, ptr %3, align 4, !dbg !147
  br label %6, !dbg !148, !llvm.loop !149

20:                                               ; preds = %6
  store i32 0, ptr %3, align 4, !dbg !151
  br label %21, !dbg !153

21:                                               ; preds = %33, %20
  %22 = load i32, ptr %3, align 4, !dbg !154
  %23 = icmp slt i32 %22, 3, !dbg !156
  br i1 %23, label %24, label %36, !dbg !157

24:                                               ; preds = %21
  %25 = load i32, ptr %3, align 4, !dbg !158
  %26 = sext i32 %25 to i64, !dbg !161
  %27 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %26, !dbg !161
  %28 = load ptr, ptr %27, align 8, !dbg !161
  %29 = call i32 @"\01_pthread_join"(ptr noundef %28, ptr noundef null), !dbg !162
  %30 = icmp ne i32 %29, 0, !dbg !163
  br i1 %30, label %31, label %32, !dbg !164

31:                                               ; preds = %24
  call void @exit(i32 noundef 1) #6, !dbg !165
  unreachable, !dbg !165

32:                                               ; preds = %24
  br label %33, !dbg !167

33:                                               ; preds = %32
  %34 = load i32, ptr %3, align 4, !dbg !168
  %35 = add nsw i32 %34, 1, !dbg !168
  store i32 %35, ptr %3, align 4, !dbg !168
  br label %21, !dbg !169, !llvm.loop !170

36:                                               ; preds = %21
  %37 = load i32, ptr @x, align 4, !dbg !172
  %38 = icmp eq i32 %37, 3, !dbg !172
  br i1 %38, label %39, label %42, !dbg !172

39:                                               ; preds = %36
  %40 = load i32, ptr @y, align 4, !dbg !172
  %41 = icmp eq i32 %40, 3, !dbg !172
  br label %42

42:                                               ; preds = %39, %36
  %43 = phi i1 [ false, %36 ], [ %41, %39 ], !dbg !173
  %44 = xor i1 %43, true, !dbg !172
  %45 = zext i1 %44 to i32, !dbg !172
  %46 = sext i32 %45 to i64, !dbg !172
  %47 = icmp ne i64 %46, 0, !dbg !172
  br i1 %47, label %48, label %50, !dbg !172

48:                                               ; preds = %42
  call void @__assert_rtn(ptr noundef @__func__.main, ptr noundef @.str, i32 noundef 50, ptr noundef @.str.1) #7, !dbg !172
  unreachable, !dbg !172

49:                                               ; No predecessors!
  br label %51, !dbg !172

50:                                               ; preds = %42
  br label %51, !dbg !172

51:                                               ; preds = %50, %49
  %52 = load ptr, ptr @ticket_lock, align 8, !dbg !174
  call void @free(ptr noundef %52), !dbg !175
  ret i32 0, !dbg !176
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_spinlock_ticket_init(ptr noundef %0) #0 !dbg !177 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8, !dbg !180
  %4 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %3, i32 0, i32 0, !dbg !181
  store i32 0, ptr %4, align 4, !dbg !182
  %5 = load ptr, ptr %2, align 8, !dbg !183
  %6 = getelementptr inbounds %struct.ck_spinlock_ticket, ptr %5, i32 0, i32 1, !dbg !184
  store i32 0, ptr %6, align 4, !dbg !185
  call void @ck_pr_barrier(), !dbg !186
  ret void, !dbg !187
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn
declare void @exit(i32 noundef) #3

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #4

declare void @free(ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_faa_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !188 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %7 = load ptr, ptr %3, align 8, !dbg !193
  %8 = load i32, ptr %4, align 4, !dbg !193
  %9 = call { i32, i32 } asm sideeffect "1:;lwarx $0, 0, $2;add $1, $3, $0;stwcx. $1, 0, $2;bne-  1b;", "=&r,=&r,r,r,~{memory},~{cc}"(ptr %7, i32 %8) #8, !dbg !193, !srcloc !197
  %10 = extractvalue { i32, i32 } %9, 0, !dbg !193
  %11 = extractvalue { i32, i32 } %9, 1, !dbg !193
  store i32 %10, ptr %5, align 4, !dbg !193
  store i32 %11, ptr %6, align 4, !dbg !193
  %12 = load i32, ptr %5, align 4, !dbg !193
  ret i32 %12, !dbg !193
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !198 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8, !dbg !202
  %5 = call i32 asm sideeffect "lwz $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #8, !dbg !202, !srcloc !204
  store i32 %5, ptr %3, align 4, !dbg !202
  %6 = load i32, ptr %3, align 4, !dbg !202
  ret i32 %6, !dbg !202
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_stall() #0 !dbg !205 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #8, !dbg !208, !srcloc !209
  ret void, !dbg !210
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_lock() #0 !dbg !211 {
  call void @ck_pr_fence_strict_lock(), !dbg !213
  ret void, !dbg !213
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_lock() #0 !dbg !214 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !215, !srcloc !216
  ret void, !dbg !215
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_unlock() #0 !dbg !217 {
  call void @ck_pr_fence_strict_unlock(), !dbg !218
  ret void, !dbg !218
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !219 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8, !dbg !223
  %6 = load i32, ptr %4, align 4, !dbg !223
  call void asm sideeffect "stw $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #8, !dbg !223, !srcloc !225
  ret void, !dbg !223
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !226 {
  call void asm sideeffect "lwsync", "~{memory}"() #8, !dbg !227, !srcloc !228
  ret void, !dbg !227
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @ck_pr_barrier() #0 !dbg !229 {
  call void asm sideeffect "", "~{memory}"() #8, !dbg !231, !srcloc !232
  ret void, !dbg !233
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { noreturn "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #4 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #5 = { allocsize(0) }
attributes #6 = { noreturn }
attributes #7 = { cold noreturn }
attributes #8 = { nounwind }

!llvm.module.flags = !{!40, !41, !42, !43, !44, !45, !46}
!llvm.dbg.cu = !{!2}
!llvm.ident = !{!47}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !20, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 19.1.7", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !17, splitDebugInlining: false, nameTableKind: Apple, sysroot: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk", sdk: "MacOSX15.sdk")
!3 = !DIFile(filename: "tests/ticketlock.c", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "2e42b97c575f8696a63db17614240b11")
!4 = !{!5, !6, !14, !16}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_ticket_t", file: !8, line: 195, baseType: !9)
!8 = !DIFile(filename: "include/spinlock/ticket.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "c308b76e8f50dc3a0a4f98ae540c37c4")
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_ticket", file: !8, line: 191, size: 64, elements: !10)
!10 = !{!11, !13}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !9, file: !8, line: 192, baseType: !12, size: 32)
!12 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "position", scope: !9, file: !8, line: 193, baseType: !12, size: 32, offset: 32)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !12)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!17 = !{!0, !18, !21, !28, !33, !38}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !20, isLocal: false, isDefinition: true)
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !3, line: 50, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 40, elements: !26)
!24 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !25)
!25 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!26 = !{!27}
!27 = !DISubrange(count: 5)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !3, line: 50, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 104, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 13)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !3, line: 50, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 248, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 31)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "ticket_lock", scope: !2, file: !3, line: 11, type: !6, isLocal: false, isDefinition: true)
!40 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!41 = !{i32 7, !"Dwarf Version", i32 5}
!42 = !{i32 2, !"Debug Info Version", i32 3}
!43 = !{i32 1, !"wchar_size", i32 4}
!44 = !{i32 8, !"PIC Level", i32 2}
!45 = !{i32 7, !"uwtable", i32 1}
!46 = !{i32 7, !"frame-pointer", i32 1}
!47 = !{!"Homebrew clang version 19.1.7"}
!48 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 13, type: !49, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!49 = !DISubroutineType(types: !50)
!50 = !{!5, !5}
!51 = !{}
!52 = !DILocalVariable(name: "arg", arg: 1, scope: !48, file: !3, line: 13, type: !5)
!53 = !DILocation(line: 13, column: 17, scope: !48)
!54 = !DILocation(line: 16, column: 29, scope: !48)
!55 = !DILocation(line: 16, column: 5, scope: !48)
!56 = !DILocation(line: 18, column: 6, scope: !48)
!57 = !DILocation(line: 19, column: 6, scope: !48)
!58 = !DILocation(line: 21, column: 31, scope: !48)
!59 = !DILocation(line: 21, column: 5, scope: !48)
!60 = !DILocation(line: 23, column: 5, scope: !48)
!61 = distinct !DISubprogram(name: "ck_spinlock_ticket_lock", scope: !8, file: !8, line: 222, type: !62, scopeLine: 223, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!62 = !DISubroutineType(types: !63)
!63 = !{null, !64}
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!65 = !DILocalVariable(name: "ticket", arg: 1, scope: !61, file: !8, line: 222, type: !64)
!66 = !DILocation(line: 222, column: 52, scope: !61)
!67 = !DILocalVariable(name: "request", scope: !61, file: !8, line: 224, type: !12)
!68 = !DILocation(line: 224, column: 15, scope: !61)
!69 = !DILocation(line: 227, column: 28, scope: !61)
!70 = !DILocation(line: 227, column: 36, scope: !61)
!71 = !DILocation(line: 227, column: 12, scope: !61)
!72 = !DILocation(line: 227, column: 10, scope: !61)
!73 = !DILocation(line: 234, column: 2, scope: !61)
!74 = !DILocation(line: 234, column: 9, scope: !61)
!75 = !DILocation(line: 234, column: 47, scope: !61)
!76 = !DILocation(line: 234, column: 44, scope: !61)
!77 = !DILocation(line: 235, column: 3, scope: !61)
!78 = distinct !{!78, !73, !79, !80}
!79 = !DILocation(line: 235, column: 15, scope: !61)
!80 = !{!"llvm.loop.mustprogress"}
!81 = !DILocation(line: 237, column: 2, scope: !61)
!82 = !DILocation(line: 238, column: 2, scope: !61)
!83 = distinct !DISubprogram(name: "ck_spinlock_ticket_unlock", scope: !8, file: !8, line: 271, type: !62, scopeLine: 272, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!84 = !DILocalVariable(name: "ticket", arg: 1, scope: !83, file: !8, line: 271, type: !64)
!85 = !DILocation(line: 271, column: 54, scope: !83)
!86 = !DILocalVariable(name: "update", scope: !83, file: !8, line: 273, type: !12)
!87 = !DILocation(line: 273, column: 15, scope: !83)
!88 = !DILocation(line: 275, column: 2, scope: !83)
!89 = !DILocation(line: 282, column: 11, scope: !83)
!90 = !DILocation(line: 282, column: 9, scope: !83)
!91 = !DILocation(line: 283, column: 2, scope: !83)
!92 = !DILocation(line: 284, column: 2, scope: !83)
!93 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !94, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!94 = !DISubroutineType(types: !95)
!95 = !{!20}
!96 = !DILocalVariable(name: "threads", scope: !93, file: !3, line: 28, type: !97)
!97 = !DICompositeType(tag: DW_TAG_array_type, baseType: !98, size: 192, elements: !121)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !99, line: 31, baseType: !100)
!99 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_t.h", directory: "", checksumkind: CSK_MD5, checksum: "086fc6d7dc3c67fdb87e7376555dcfd7")
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "__darwin_pthread_t", file: !101, line: 118, baseType: !102)
!101 = !DIFile(filename: "/Library/Developer/CommandLineTools/SDKs/MacOSX15.sdk/usr/include/sys/_pthread/_pthread_types.h", directory: "", checksumkind: CSK_MD5, checksum: "4e2ea0e1af95894da0a6030a21a8ebee")
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_opaque_pthread_t", file: !101, line: 103, size: 65536, elements: !104)
!104 = !{!105, !107, !117}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "__sig", scope: !103, file: !101, line: 104, baseType: !106, size: 64)
!106 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "__cleanup_stack", scope: !103, file: !101, line: 105, baseType: !108, size: 64, offset: 64)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__darwin_pthread_handler_rec", file: !101, line: 57, size: 192, elements: !110)
!110 = !{!111, !115, !116}
!111 = !DIDerivedType(tag: DW_TAG_member, name: "__routine", scope: !109, file: !101, line: 58, baseType: !112, size: 64)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = !DISubroutineType(types: !114)
!114 = !{null, !5}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "__arg", scope: !109, file: !101, line: 59, baseType: !5, size: 64, offset: 64)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "__next", scope: !109, file: !101, line: 60, baseType: !108, size: 64, offset: 128)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "__opaque", scope: !103, file: !101, line: 106, baseType: !118, size: 65408, offset: 128)
!118 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 65408, elements: !119)
!119 = !{!120}
!120 = !DISubrange(count: 8176)
!121 = !{!122}
!122 = !DISubrange(count: 3)
!123 = !DILocation(line: 28, column: 15, scope: !93)
!124 = !DILocalVariable(name: "i", scope: !93, file: !3, line: 29, type: !20)
!125 = !DILocation(line: 29, column: 9, scope: !93)
!126 = !DILocation(line: 31, column: 43, scope: !93)
!127 = !DILocation(line: 31, column: 17, scope: !93)
!128 = !DILocation(line: 32, column: 29, scope: !93)
!129 = !DILocation(line: 32, column: 5, scope: !93)
!130 = !DILocation(line: 34, column: 12, scope: !131)
!131 = distinct !DILexicalBlock(scope: !93, file: !3, line: 34, column: 5)
!132 = !DILocation(line: 34, column: 10, scope: !131)
!133 = !DILocation(line: 34, column: 17, scope: !134)
!134 = distinct !DILexicalBlock(scope: !131, file: !3, line: 34, column: 5)
!135 = !DILocation(line: 34, column: 19, scope: !134)
!136 = !DILocation(line: 34, column: 5, scope: !131)
!137 = !DILocation(line: 36, column: 37, scope: !138)
!138 = distinct !DILexicalBlock(scope: !139, file: !3, line: 36, column: 13)
!139 = distinct !DILexicalBlock(scope: !134, file: !3, line: 35, column: 5)
!140 = !DILocation(line: 36, column: 29, scope: !138)
!141 = !DILocation(line: 36, column: 13, scope: !138)
!142 = !DILocation(line: 36, column: 58, scope: !138)
!143 = !DILocation(line: 36, column: 13, scope: !139)
!144 = !DILocation(line: 38, column: 13, scope: !145)
!145 = distinct !DILexicalBlock(scope: !138, file: !3, line: 37, column: 9)
!146 = !DILocation(line: 40, column: 5, scope: !139)
!147 = !DILocation(line: 34, column: 32, scope: !134)
!148 = !DILocation(line: 34, column: 5, scope: !134)
!149 = distinct !{!149, !136, !150, !80}
!150 = !DILocation(line: 40, column: 5, scope: !131)
!151 = !DILocation(line: 42, column: 12, scope: !152)
!152 = distinct !DILexicalBlock(scope: !93, file: !3, line: 42, column: 5)
!153 = !DILocation(line: 42, column: 10, scope: !152)
!154 = !DILocation(line: 42, column: 17, scope: !155)
!155 = distinct !DILexicalBlock(scope: !152, file: !3, line: 42, column: 5)
!156 = !DILocation(line: 42, column: 19, scope: !155)
!157 = !DILocation(line: 42, column: 5, scope: !152)
!158 = !DILocation(line: 44, column: 34, scope: !159)
!159 = distinct !DILexicalBlock(scope: !160, file: !3, line: 44, column: 13)
!160 = distinct !DILexicalBlock(scope: !155, file: !3, line: 43, column: 5)
!161 = !DILocation(line: 44, column: 26, scope: !159)
!162 = !DILocation(line: 44, column: 13, scope: !159)
!163 = !DILocation(line: 44, column: 44, scope: !159)
!164 = !DILocation(line: 44, column: 13, scope: !160)
!165 = !DILocation(line: 46, column: 13, scope: !166)
!166 = distinct !DILexicalBlock(scope: !159, file: !3, line: 45, column: 9)
!167 = !DILocation(line: 48, column: 5, scope: !160)
!168 = !DILocation(line: 42, column: 32, scope: !155)
!169 = !DILocation(line: 42, column: 5, scope: !155)
!170 = distinct !{!170, !157, !171, !80}
!171 = !DILocation(line: 48, column: 5, scope: !152)
!172 = !DILocation(line: 50, column: 5, scope: !93)
!173 = !DILocation(line: 0, scope: !93)
!174 = !DILocation(line: 52, column: 10, scope: !93)
!175 = !DILocation(line: 52, column: 5, scope: !93)
!176 = !DILocation(line: 54, column: 5, scope: !93)
!177 = distinct !DISubprogram(name: "ck_spinlock_ticket_init", scope: !8, file: !8, line: 200, type: !62, scopeLine: 201, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!178 = !DILocalVariable(name: "ticket", arg: 1, scope: !177, file: !8, line: 200, type: !64)
!179 = !DILocation(line: 200, column: 52, scope: !177)
!180 = !DILocation(line: 203, column: 2, scope: !177)
!181 = !DILocation(line: 203, column: 10, scope: !177)
!182 = !DILocation(line: 203, column: 15, scope: !177)
!183 = !DILocation(line: 204, column: 2, scope: !177)
!184 = !DILocation(line: 204, column: 10, scope: !177)
!185 = !DILocation(line: 204, column: 19, scope: !177)
!186 = !DILocation(line: 205, column: 2, scope: !177)
!187 = !DILocation(line: 207, column: 2, scope: !177)
!188 = distinct !DISubprogram(name: "ck_pr_faa_uint", scope: !189, file: !189, line: 424, type: !190, scopeLine: 424, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!189 = !DIFile(filename: "include/gcc/ppc64/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "1c5aecf7376064f28c732d8a93471464")
!190 = !DISubroutineType(types: !191)
!191 = !{!12, !16, !12}
!192 = !DILocalVariable(name: "target", arg: 1, scope: !188, file: !189, line: 424, type: !16)
!193 = !DILocation(line: 424, column: 1, scope: !188)
!194 = !DILocalVariable(name: "delta", arg: 2, scope: !188, file: !189, line: 424, type: !12)
!195 = !DILocalVariable(name: "previous", scope: !188, file: !189, line: 424, type: !12)
!196 = !DILocalVariable(name: "r", scope: !188, file: !189, line: 424, type: !12)
!197 = !{i64 2147801325}
!198 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !189, file: !189, line: 113, type: !199, scopeLine: 113, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!199 = !DISubroutineType(types: !200)
!200 = !{!12, !14}
!201 = !DILocalVariable(name: "target", arg: 1, scope: !198, file: !189, line: 113, type: !14)
!202 = !DILocation(line: 113, column: 1, scope: !198)
!203 = !DILocalVariable(name: "r", scope: !198, file: !189, line: 113, type: !12)
!204 = !{i64 2147765418}
!205 = distinct !DISubprogram(name: "ck_pr_stall", scope: !189, file: !189, line: 56, type: !206, scopeLine: 57, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!206 = !DISubroutineType(types: !207)
!207 = !{null}
!208 = !DILocation(line: 59, column: 2, scope: !205)
!209 = !{i64 264451}
!210 = !DILocation(line: 61, column: 2, scope: !205)
!211 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !212, file: !212, line: 118, type: !206, scopeLine: 118, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!212 = !DIFile(filename: "include/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "cffbc3bc631aa31cdde49d8ca6470a32")
!213 = !DILocation(line: 118, column: 1, scope: !211)
!214 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !189, file: !189, line: 88, type: !206, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!215 = !DILocation(line: 88, column: 1, scope: !214)
!216 = !{i64 2147762883}
!217 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !212, file: !212, line: 119, type: !206, scopeLine: 119, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!218 = !DILocation(line: 119, column: 1, scope: !217)
!219 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !189, file: !189, line: 143, type: !220, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!220 = !DISubroutineType(types: !221)
!221 = !{null, !16, !12}
!222 = !DILocalVariable(name: "target", arg: 1, scope: !219, file: !189, line: 143, type: !16)
!223 = !DILocation(line: 143, column: 1, scope: !219)
!224 = !DILocalVariable(name: "v", arg: 2, scope: !219, file: !189, line: 143, type: !12)
!225 = !{i64 2147769065}
!226 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !189, file: !189, line: 89, type: !206, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!227 = !DILocation(line: 89, column: 1, scope: !226)
!228 = !{i64 2147763080}
!229 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !230, file: !230, line: 37, type: !206, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!230 = !DIFile(filename: "include/gcc/ck_pr.h", directory: "/Users/stefanodalmas/Desktop/huawei/ck", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!231 = !DILocation(line: 40, column: 2, scope: !229)
!232 = !{i64 320152}
!233 = !DILocation(line: 41, column: 2, scope: !229)
