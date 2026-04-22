; ModuleID = 'benchmarks/ck/ticketlock.c'
source_filename = "benchmarks/ck/ticketlock.c"
target datalayout = "E-m:e-Fi64-i64:64-i128:128-n32:64-S128-v256:256:256-v512:512:512"
target triple = "ppc64-pc-linux-gnu"

%struct.ck_spinlock_ticket = type { i32, i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !19
@ticket_lock = dso_local global ptr null, align 8, !dbg !38
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !21
@.str.1 = private unnamed_addr constant [27 x i8] c"benchmarks/ck/ticketlock.c\00", align 1, !dbg !27
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !32

; Function Attrs: noinline nounwind optnone uwtable
define dso_local ptr @run(ptr noundef %0) #0 !dbg !48 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !52, !DIExpression(), !53)
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

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_ticket_lock(ptr noundef %0) #0 !dbg !61 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !65, !DIExpression(), !66)
    #dbg_declare(ptr %3, !67, !DIExpression(), !68)
  %4 = load ptr, ptr %2, align 8, !dbg !69
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %4, i32 0, i32 0, !dbg !70
  %6 = call zeroext i32 @ck_pr_faa_uint(ptr noundef %5, i32 noundef zeroext 1), !dbg !71
  store i32 %6, ptr %3, align 4, !dbg !72
  br label %7, !dbg !73

7:                                                ; preds = %13, %1
  %8 = load ptr, ptr %2, align 8, !dbg !74
  %9 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %8, i32 0, i32 1, !dbg !75
  %10 = call zeroext i32 @ck_pr_md_load_uint(ptr noundef %9), !dbg !76
  %11 = load i32, ptr %3, align 4, !dbg !77
  %12 = icmp ne i32 %10, %11, !dbg !78
  br i1 %12, label %13, label %14, !dbg !73

13:                                               ; preds = %7
  call void @ck_pr_stall(), !dbg !79
  br label %7, !dbg !73, !llvm.loop !80

14:                                               ; preds = %7
  call void @ck_pr_fence_lock(), !dbg !83
  ret void, !dbg !84
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_ticket_unlock(ptr noundef %0) #0 !dbg !85 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !86, !DIExpression(), !87)
    #dbg_declare(ptr %3, !88, !DIExpression(), !89)
  call void @ck_pr_fence_unlock(), !dbg !90
  %4 = load ptr, ptr %2, align 8, !dbg !91
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %4, i32 0, i32 1, !dbg !92
  %6 = call zeroext i32 @ck_pr_md_load_uint(ptr noundef %5), !dbg !93
  store i32 %6, ptr %3, align 4, !dbg !94
  %7 = load ptr, ptr %2, align 8, !dbg !95
  %8 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %7, i32 0, i32 1, !dbg !96
  %9 = load i32, ptr %3, align 4, !dbg !97
  %10 = add i32 %9, 1, !dbg !98
  call void @ck_pr_md_store_uint(ptr noundef %8, i32 noundef zeroext %10), !dbg !99
  ret void, !dbg !100
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local signext i32 @main() #0 !dbg !101 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 8
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !104, !DIExpression(), !110)
    #dbg_declare(ptr %3, !111, !DIExpression(), !112)
  %4 = call ptr @malloc(i64 noundef 8) #4, !dbg !113
  store ptr %4, ptr @ticket_lock, align 8, !dbg !114
  %5 = load ptr, ptr @ticket_lock, align 8, !dbg !115
  call void @ck_spinlock_ticket_init(ptr noundef %5), !dbg !116
  store i32 0, ptr %3, align 4, !dbg !117
  br label %6, !dbg !119

6:                                                ; preds = %17, %0
  %7 = load i32, ptr %3, align 4, !dbg !120
  %8 = icmp slt i32 %7, 3, !dbg !122
  br i1 %8, label %9, label %20, !dbg !123

9:                                                ; preds = %6
  %10 = load i32, ptr %3, align 4, !dbg !124
  %11 = sext i32 %10 to i64, !dbg !127
  %12 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %11, !dbg !127
  %13 = call signext i32 @pthread_create(ptr noundef %12, ptr noundef null, ptr noundef @run, ptr noundef null), !dbg !128
  %14 = icmp ne i32 %13, 0, !dbg !129
  br i1 %14, label %15, label %16, !dbg !129

15:                                               ; preds = %9
  call void @exit(i32 noundef signext 1) #5, !dbg !130
  unreachable, !dbg !130

16:                                               ; preds = %9
  br label %17, !dbg !132

17:                                               ; preds = %16
  %18 = load i32, ptr %3, align 4, !dbg !133
  %19 = add nsw i32 %18, 1, !dbg !133
  store i32 %19, ptr %3, align 4, !dbg !133
  br label %6, !dbg !134, !llvm.loop !135

20:                                               ; preds = %6
  store i32 0, ptr %3, align 4, !dbg !137
  br label %21, !dbg !139

21:                                               ; preds = %33, %20
  %22 = load i32, ptr %3, align 4, !dbg !140
  %23 = icmp slt i32 %22, 3, !dbg !142
  br i1 %23, label %24, label %36, !dbg !143

24:                                               ; preds = %21
  %25 = load i32, ptr %3, align 4, !dbg !144
  %26 = sext i32 %25 to i64, !dbg !147
  %27 = getelementptr inbounds [3 x ptr], ptr %2, i64 0, i64 %26, !dbg !147
  %28 = load ptr, ptr %27, align 8, !dbg !147
  %29 = call signext i32 @pthread_join(ptr noundef %28, ptr noundef null), !dbg !148
  %30 = icmp ne i32 %29, 0, !dbg !149
  br i1 %30, label %31, label %32, !dbg !149

31:                                               ; preds = %24
  call void @exit(i32 noundef signext 1) #5, !dbg !150
  unreachable, !dbg !150

32:                                               ; preds = %24
  br label %33, !dbg !152

33:                                               ; preds = %32
  %34 = load i32, ptr %3, align 4, !dbg !153
  %35 = add nsw i32 %34, 1, !dbg !153
  store i32 %35, ptr %3, align 4, !dbg !153
  br label %21, !dbg !154, !llvm.loop !155

36:                                               ; preds = %21
  %37 = load i32, ptr @x, align 4, !dbg !157
  %38 = icmp eq i32 %37, 3, !dbg !160
  br i1 %38, label %39, label %42, !dbg !161

39:                                               ; preds = %36
  %40 = load i32, ptr @y, align 4, !dbg !162
  %41 = icmp eq i32 %40, 3, !dbg !163
  br i1 %41, label %43, label %42, !dbg !164

42:                                               ; preds = %39, %36
  call void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef signext 50, ptr noundef @__func__.main), !dbg !164
  br label %43, !dbg !164

43:                                               ; preds = %42, %39
  %44 = load ptr, ptr @ticket_lock, align 8, !dbg !165
  call void @free(ptr noundef %44), !dbg !166
  ret i32 0, !dbg !167
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_spinlock_ticket_init(ptr noundef %0) #0 !dbg !168 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !169, !DIExpression(), !170)
  %3 = load ptr, ptr %2, align 8, !dbg !171
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %3, i32 0, i32 0, !dbg !172
  store i32 0, ptr %4, align 4, !dbg !173
  %5 = load ptr, ptr %2, align 8, !dbg !174
  %6 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %5, i32 0, i32 1, !dbg !175
  store i32 0, ptr %6, align 4, !dbg !176
  call void @ck_pr_barrier(), !dbg !177
  ret void, !dbg !178
}

declare signext i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn
declare void @exit(i32 noundef signext) #3

declare signext i32 @pthread_join(ptr noundef, ptr noundef) #2

declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef signext, ptr noundef) #2

declare void @free(ptr noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_faa_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !179 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !183, !DIExpression(), !184)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !185, !DIExpression(), !184)
    #dbg_declare(ptr %5, !186, !DIExpression(), !184)
    #dbg_declare(ptr %6, !187, !DIExpression(), !184)
  %7 = load ptr, ptr %3, align 8, !dbg !184
  %8 = load i32, ptr %4, align 4, !dbg !184
  %9 = call { i32, i32 } asm sideeffect "1:lwarx $0, 0, $2;add $1, $3, $0;stwcx. $1, 0, $2;bne-  1b;", "=&r,=&r,r,r,~{memory},~{cc}"(ptr %7, i32 %8) #6, !dbg !184, !srcloc !188
  %10 = extractvalue { i32, i32 } %9, 0, !dbg !184
  %11 = extractvalue { i32, i32 } %9, 1, !dbg !184
  store i32 %10, ptr %5, align 4, !dbg !184
  store i32 %11, ptr %6, align 4, !dbg !184
  %12 = load i32, ptr %5, align 4, !dbg !184
  ret i32 %12, !dbg !184
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !189 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
    #dbg_declare(ptr %2, !192, !DIExpression(), !193)
    #dbg_declare(ptr %3, !194, !DIExpression(), !193)
  %4 = load ptr, ptr %2, align 8, !dbg !193
  %5 = call i32 asm sideeffect "lwz${1:U}${1:X} $0, $1", "=r,*m,~{memory}"(ptr elementtype(i32) %4) #6, !dbg !193, !srcloc !195
  store i32 %5, ptr %3, align 4, !dbg !193
  %6 = load i32, ptr %3, align 4, !dbg !193
  ret i32 %6, !dbg !193
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_stall() #0 !dbg !196 {
  call void asm sideeffect "or 1, 1, 1;or 2, 2, 2;", "~{memory}"() #6, !dbg !199, !srcloc !200
  ret void, !dbg !201
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_lock() #0 !dbg !202 {
  call void @ck_pr_fence_strict_lock(), !dbg !204
  ret void, !dbg !204
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_lock() #0 !dbg !205 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !206, !srcloc !207
  ret void, !dbg !206
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_unlock() #0 !dbg !208 {
  call void @ck_pr_fence_strict_unlock(), !dbg !209
  ret void, !dbg !209
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef zeroext %1) #0 !dbg !210 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
    #dbg_declare(ptr %3, !213, !DIExpression(), !214)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !215, !DIExpression(), !214)
  %5 = load ptr, ptr %3, align 8, !dbg !214
  %6 = load i32, ptr %4, align 4, !dbg !214
  call void asm sideeffect "stw${0:U}${0:X} $1, $0", "=*m,r,~{memory}"(ptr elementtype(i32) %5, i32 %6) #6, !dbg !214, !srcloc !216
  ret void, !dbg !214
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_fence_strict_unlock() #0 !dbg !217 {
  call void asm sideeffect "lwsync", "~{memory}"() #6, !dbg !218, !srcloc !219
  ret void, !dbg !218
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @ck_pr_barrier() #0 !dbg !220 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !222, !srcloc !223
  ret void, !dbg !224
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #3 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="ppc64" "target-features"="+64bit-support,+fpu,+fres,+frsqrte,+fsqrt,+mfocrf,+stfiwx,-altivec,-crypto,-direct-move,-float128,-hard-float,-mma,-paired-vector-memops,-power10-vector,-power8-vector,-power9-vector,-vsx" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!40, !41, !42, !43, !44, !45, !46}
!llvm.ident = !{!47}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !14, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !18, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/ticketlock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "2e42b97c575f8696a63db17614240b11")
!4 = !{!5, !6, !14, !15, !17}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_ticket_t", file: !8, line: 195, baseType: !9)
!8 = !DIFile(filename: "../ck/include/spinlock/ticket.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "c308b76e8f50dc3a0a4f98ae540c37c4")
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_ticket", file: !8, line: 191, size: 64, elements: !10)
!10 = !{!11, !13}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !9, file: !8, line: 192, baseType: !12, size: 32)
!12 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "position", scope: !9, file: !8, line: 193, baseType: !12, size: 32, offset: 32)
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !12)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!18 = !{!0, !19, !21, !27, !32, !38}
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !14, isLocal: false, isDefinition: true)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(scope: null, file: !3, line: 50, type: !23, isLocal: true, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 248, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!25 = !{!26}
!26 = !DISubrange(count: 31)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !3, line: 50, type: !29, isLocal: true, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 216, elements: !30)
!30 = !{!31}
!31 = !DISubrange(count: 27)
!32 = !DIGlobalVariableExpression(var: !33, expr: !DIExpression())
!33 = distinct !DIGlobalVariable(scope: null, file: !3, line: 50, type: !34, isLocal: true, isDefinition: true)
!34 = !DICompositeType(tag: DW_TAG_array_type, baseType: !35, size: 40, elements: !36)
!35 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!36 = !{!37}
!37 = !DISubrange(count: 5)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "ticket_lock", scope: !2, file: !3, line: 11, type: !6, isLocal: false, isDefinition: true)
!40 = !{i32 7, !"Dwarf Version", i32 5}
!41 = !{i32 2, !"Debug Info Version", i32 3}
!42 = !{i32 1, !"wchar_size", i32 4}
!43 = !{i32 8, !"PIC Level", i32 2}
!44 = !{i32 7, !"PIE Level", i32 2}
!45 = !{i32 7, !"uwtable", i32 2}
!46 = !{i32 7, !"frame-pointer", i32 2}
!47 = !{!"Homebrew clang version 22.1.8"}
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
!74 = !DILocation(line: 234, column: 26, scope: !61)
!75 = !DILocation(line: 234, column: 34, scope: !61)
!76 = !DILocation(line: 234, column: 9, scope: !61)
!77 = !DILocation(line: 234, column: 47, scope: !61)
!78 = !DILocation(line: 234, column: 44, scope: !61)
!79 = !DILocation(line: 235, column: 3, scope: !61)
!80 = distinct !{!80, !73, !81, !82}
!81 = !DILocation(line: 235, column: 15, scope: !61)
!82 = !{!"llvm.loop.mustprogress"}
!83 = !DILocation(line: 237, column: 2, scope: !61)
!84 = !DILocation(line: 238, column: 2, scope: !61)
!85 = distinct !DISubprogram(name: "ck_spinlock_ticket_unlock", scope: !8, file: !8, line: 271, type: !62, scopeLine: 272, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!86 = !DILocalVariable(name: "ticket", arg: 1, scope: !85, file: !8, line: 271, type: !64)
!87 = !DILocation(line: 271, column: 54, scope: !85)
!88 = !DILocalVariable(name: "update", scope: !85, file: !8, line: 273, type: !12)
!89 = !DILocation(line: 273, column: 15, scope: !85)
!90 = !DILocation(line: 275, column: 2, scope: !85)
!91 = !DILocation(line: 282, column: 28, scope: !85)
!92 = !DILocation(line: 282, column: 36, scope: !85)
!93 = !DILocation(line: 282, column: 11, scope: !85)
!94 = !DILocation(line: 282, column: 9, scope: !85)
!95 = !DILocation(line: 283, column: 20, scope: !85)
!96 = !DILocation(line: 283, column: 28, scope: !85)
!97 = !DILocation(line: 283, column: 38, scope: !85)
!98 = !DILocation(line: 283, column: 45, scope: !85)
!99 = !DILocation(line: 283, column: 2, scope: !85)
!100 = !DILocation(line: 284, column: 2, scope: !85)
!101 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !102, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !51)
!102 = !DISubroutineType(types: !103)
!103 = !{!14}
!104 = !DILocalVariable(name: "threads", scope: !101, file: !3, line: 28, type: !105)
!105 = !DICompositeType(tag: DW_TAG_array_type, baseType: !106, size: 192, elements: !108)
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !107, line: 2, baseType: !5)
!107 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!108 = !{!109}
!109 = !DISubrange(count: 3)
!110 = !DILocation(line: 28, column: 15, scope: !101)
!111 = !DILocalVariable(name: "i", scope: !101, file: !3, line: 29, type: !14)
!112 = !DILocation(line: 29, column: 9, scope: !101)
!113 = !DILocation(line: 31, column: 43, scope: !101)
!114 = !DILocation(line: 31, column: 17, scope: !101)
!115 = !DILocation(line: 32, column: 29, scope: !101)
!116 = !DILocation(line: 32, column: 5, scope: !101)
!117 = !DILocation(line: 34, column: 12, scope: !118)
!118 = distinct !DILexicalBlock(scope: !101, file: !3, line: 34, column: 5)
!119 = !DILocation(line: 34, column: 10, scope: !118)
!120 = !DILocation(line: 34, column: 17, scope: !121)
!121 = distinct !DILexicalBlock(scope: !118, file: !3, line: 34, column: 5)
!122 = !DILocation(line: 34, column: 19, scope: !121)
!123 = !DILocation(line: 34, column: 5, scope: !118)
!124 = !DILocation(line: 36, column: 37, scope: !125)
!125 = distinct !DILexicalBlock(scope: !126, file: !3, line: 36, column: 13)
!126 = distinct !DILexicalBlock(scope: !121, file: !3, line: 35, column: 5)
!127 = !DILocation(line: 36, column: 29, scope: !125)
!128 = !DILocation(line: 36, column: 13, scope: !125)
!129 = !DILocation(line: 36, column: 58, scope: !125)
!130 = !DILocation(line: 38, column: 13, scope: !131)
!131 = distinct !DILexicalBlock(scope: !125, file: !3, line: 37, column: 9)
!132 = !DILocation(line: 40, column: 5, scope: !126)
!133 = !DILocation(line: 34, column: 32, scope: !121)
!134 = !DILocation(line: 34, column: 5, scope: !121)
!135 = distinct !{!135, !123, !136, !82}
!136 = !DILocation(line: 40, column: 5, scope: !118)
!137 = !DILocation(line: 42, column: 12, scope: !138)
!138 = distinct !DILexicalBlock(scope: !101, file: !3, line: 42, column: 5)
!139 = !DILocation(line: 42, column: 10, scope: !138)
!140 = !DILocation(line: 42, column: 17, scope: !141)
!141 = distinct !DILexicalBlock(scope: !138, file: !3, line: 42, column: 5)
!142 = !DILocation(line: 42, column: 19, scope: !141)
!143 = !DILocation(line: 42, column: 5, scope: !138)
!144 = !DILocation(line: 44, column: 34, scope: !145)
!145 = distinct !DILexicalBlock(scope: !146, file: !3, line: 44, column: 13)
!146 = distinct !DILexicalBlock(scope: !141, file: !3, line: 43, column: 5)
!147 = !DILocation(line: 44, column: 26, scope: !145)
!148 = !DILocation(line: 44, column: 13, scope: !145)
!149 = !DILocation(line: 44, column: 44, scope: !145)
!150 = !DILocation(line: 46, column: 13, scope: !151)
!151 = distinct !DILexicalBlock(scope: !145, file: !3, line: 45, column: 9)
!152 = !DILocation(line: 48, column: 5, scope: !146)
!153 = !DILocation(line: 42, column: 32, scope: !141)
!154 = !DILocation(line: 42, column: 5, scope: !141)
!155 = distinct !{!155, !143, !156, !82}
!156 = !DILocation(line: 48, column: 5, scope: !138)
!157 = !DILocation(line: 50, column: 12, scope: !158)
!158 = distinct !DILexicalBlock(scope: !159, file: !3, line: 50, column: 5)
!159 = distinct !DILexicalBlock(scope: !101, file: !3, line: 50, column: 5)
!160 = !DILocation(line: 50, column: 14, scope: !158)
!161 = !DILocation(line: 50, column: 26, scope: !158)
!162 = !DILocation(line: 50, column: 29, scope: !158)
!163 = !DILocation(line: 50, column: 31, scope: !158)
!164 = !DILocation(line: 50, column: 5, scope: !158)
!165 = !DILocation(line: 52, column: 10, scope: !101)
!166 = !DILocation(line: 52, column: 5, scope: !101)
!167 = !DILocation(line: 54, column: 5, scope: !101)
!168 = distinct !DISubprogram(name: "ck_spinlock_ticket_init", scope: !8, file: !8, line: 200, type: !62, scopeLine: 201, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!169 = !DILocalVariable(name: "ticket", arg: 1, scope: !168, file: !8, line: 200, type: !64)
!170 = !DILocation(line: 200, column: 52, scope: !168)
!171 = !DILocation(line: 203, column: 2, scope: !168)
!172 = !DILocation(line: 203, column: 10, scope: !168)
!173 = !DILocation(line: 203, column: 15, scope: !168)
!174 = !DILocation(line: 204, column: 2, scope: !168)
!175 = !DILocation(line: 204, column: 10, scope: !168)
!176 = !DILocation(line: 204, column: 19, scope: !168)
!177 = !DILocation(line: 205, column: 2, scope: !168)
!178 = !DILocation(line: 207, column: 2, scope: !168)
!179 = distinct !DISubprogram(name: "ck_pr_faa_uint", scope: !180, file: !180, line: 422, type: !181, scopeLine: 422, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!180 = !DIFile(filename: "../ck/include/gcc/ppc64/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "8952bb109540f13c2aa63ce3890cafa9")
!181 = !DISubroutineType(types: !182)
!182 = !{!12, !17, !12}
!183 = !DILocalVariable(name: "target", arg: 1, scope: !179, file: !180, line: 422, type: !17)
!184 = !DILocation(line: 422, column: 1, scope: !179)
!185 = !DILocalVariable(name: "delta", arg: 2, scope: !179, file: !180, line: 422, type: !12)
!186 = !DILocalVariable(name: "previous", scope: !179, file: !180, line: 422, type: !12)
!187 = !DILocalVariable(name: "r", scope: !179, file: !180, line: 422, type: !12)
!188 = !{i64 2147622163}
!189 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !180, file: !180, line: 111, type: !190, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!190 = !DISubroutineType(types: !191)
!191 = !{!12, !15}
!192 = !DILocalVariable(name: "target", arg: 1, scope: !189, file: !180, line: 111, type: !15)
!193 = !DILocation(line: 111, column: 1, scope: !189)
!194 = !DILocalVariable(name: "r", scope: !189, file: !180, line: 111, type: !12)
!195 = !{i64 2147586291}
!196 = distinct !DISubprogram(name: "ck_pr_stall", scope: !180, file: !180, line: 54, type: !197, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!197 = !DISubroutineType(types: !198)
!198 = !{null}
!199 = !DILocation(line: 57, column: 2, scope: !196)
!200 = !{i64 85287}
!201 = !DILocation(line: 59, column: 2, scope: !196)
!202 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !203, file: !203, line: 122, type: !197, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!203 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!204 = !DILocation(line: 122, column: 1, scope: !202)
!205 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !180, file: !180, line: 86, type: !197, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!206 = !DILocation(line: 86, column: 1, scope: !205)
!207 = !{i64 2147583720}
!208 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !203, file: !203, line: 123, type: !197, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!209 = !DILocation(line: 123, column: 1, scope: !208)
!210 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !180, file: !180, line: 141, type: !211, scopeLine: 141, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !51)
!211 = !DISubroutineType(types: !212)
!212 = !{null, !17, !12}
!213 = !DILocalVariable(name: "target", arg: 1, scope: !210, file: !180, line: 141, type: !17)
!214 = !DILocation(line: 141, column: 1, scope: !210)
!215 = !DILocalVariable(name: "v", arg: 2, scope: !210, file: !180, line: 141, type: !12)
!216 = !{i64 2147589998}
!217 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !180, file: !180, line: 87, type: !197, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!218 = !DILocation(line: 87, column: 1, scope: !217)
!219 = !{i64 2147583917}
!220 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !221, file: !221, line: 37, type: !197, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!221 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!222 = !DILocation(line: 40, column: 2, scope: !220)
!223 = !{i64 140988}
!224 = !DILocation(line: 41, column: 2, scope: !220)
