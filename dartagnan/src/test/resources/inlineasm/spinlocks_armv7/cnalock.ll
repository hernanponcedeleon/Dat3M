; ModuleID = 'test/spinlock/cnalock.c'
source_filename = "test/spinlock/cnalock.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

%struct.vatomic32_s = type { i32 }
%struct.cnalock_s = type { %struct.vatomicptr_s }
%struct.vatomicptr_s = type { ptr }
%struct.cna_node_s = type { %struct.vatomicptr_s, %struct.vatomicptr_s, %struct.vatomic32_s }

@rand = global %struct.vatomic32_s zeroinitializer, align 4
@g_cs_x = internal global i32 0, align 4
@g_cs_y = internal global i32 0, align 4
@__func__.check = private unnamed_addr constant [6 x i8] c"check\00", align 1
@.str = private unnamed_addr constant [7 x i8] c"lock.h\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"g_cs_x == g_cs_y\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"g_cs_x == (4 + 0 + 0)\00", align 1
@lock = global %struct.cnalock_s zeroinitializer, align 8
@nodes = global [4 x %struct.cna_node_s] zeroinitializer, align 8

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @init() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @fini() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @cs() #0 {
  %1 = load i32, ptr @g_cs_x, align 4
  %2 = add i32 %1, 1
  store i32 %2, ptr @g_cs_x, align 4
  %3 = load i32, ptr @g_cs_y, align 4
  %4 = add i32 %3, 1
  store i32 %4, ptr @g_cs_y, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @check() #0 {
  %1 = load i32, ptr @g_cs_x, align 4
  %2 = load i32, ptr @g_cs_y, align 4
  %3 = icmp eq i32 %1, %2
  %4 = xor i1 %3, true
  %5 = zext i1 %4 to i32
  %6 = sext i32 %5 to i64
  %7 = icmp ne i64 %6, 0
  br i1 %7, label %8, label %10

8:                                                ; preds = %0
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 117, ptr noundef @.str.1) #3
  unreachable

9:                                                ; No predecessors!
  br label %11

10:                                               ; preds = %0
  br label %11

11:                                               ; preds = %10, %9
  %12 = load i32, ptr @g_cs_x, align 4
  %13 = icmp eq i32 %12, 4
  %14 = xor i1 %13, true
  %15 = zext i1 %14 to i32
  %16 = sext i32 %15 to i64
  %17 = icmp ne i64 %16, 0
  br i1 %17, label %18, label %20

18:                                               ; preds = %11
  call void @__assert_rtn(ptr noundef @__func__.check, ptr noundef @.str, i32 noundef 118, ptr noundef @.str.2) #3
  unreachable

19:                                               ; No predecessors!
  br label %21

20:                                               ; preds = %11
  br label %21

21:                                               ; preds = %20, %19
  ret void
}

; Function Attrs: cold noreturn
declare void @__assert_rtn(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x ptr], align 8
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, ptr %1, align 4
  call void @init()
  call void @verification_loop_bound(i32 noundef 5)
  store i64 0, ptr %3, align 8
  br label %5

5:                                                ; preds = %14, %0
  %6 = load i64, ptr %3, align 8
  %7 = icmp ult i64 %6, 4
  br i1 %7, label %8, label %17

8:                                                ; preds = %5
  %9 = load i64, ptr %3, align 8
  %10 = getelementptr inbounds [4 x ptr], ptr %2, i64 0, i64 %9
  %11 = load i64, ptr %3, align 8
  %12 = inttoptr i64 %11 to ptr
  %13 = call i32 @pthread_create(ptr noundef %10, ptr noundef null, ptr noundef @run, ptr noundef %12)
  br label %14

14:                                               ; preds = %8
  %15 = load i64, ptr %3, align 8
  %16 = add i64 %15, 1
  store i64 %16, ptr %3, align 8
  br label %5, !llvm.loop !6

17:                                               ; preds = %5
  call void @post()
  call void @verification_loop_bound(i32 noundef 5)
  store i64 0, ptr %4, align 8
  br label %18

18:                                               ; preds = %26, %17
  %19 = load i64, ptr %4, align 8
  %20 = icmp ult i64 %19, 4
  br i1 %20, label %21, label %29

21:                                               ; preds = %18
  %22 = load i64, ptr %4, align 8
  %23 = getelementptr inbounds [4 x ptr], ptr %2, i64 0, i64 %22
  %24 = load ptr, ptr %23, align 8
  %25 = call i32 @"\01_pthread_join"(ptr noundef %24, ptr noundef null)
  br label %26

26:                                               ; preds = %21
  %27 = load i64, ptr %4, align 8
  %28 = add i64 %27, 1
  store i64 %28, ptr %4, align 8
  br label %18, !llvm.loop !8

29:                                               ; preds = %18
  call void @check()
  call void @fini()
  ret i32 0
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_loop_bound(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  ret void
}

declare i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @run(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %7 = load ptr, ptr %2, align 8
  %8 = ptrtoint ptr %7 to i64
  %9 = trunc i64 %8 to i32
  store i32 %9, ptr %3, align 4
  call void @verification_loop_bound(i32 noundef 2)
  store i32 0, ptr %4, align 4
  br label %10

10:                                               ; preds = %65, %1
  %11 = load i32, ptr %4, align 4
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %22, label %13

13:                                               ; preds = %10
  %14 = load i32, ptr %4, align 4
  %15 = icmp eq i32 %14, 1
  br i1 %15, label %16, label %20

16:                                               ; preds = %13
  %17 = load i32, ptr %3, align 4
  %18 = add i32 %17, 1
  %19 = icmp ult i32 %18, 1
  br label %20

20:                                               ; preds = %16, %13
  %21 = phi i1 [ false, %13 ], [ %19, %16 ]
  br label %22

22:                                               ; preds = %20, %10
  %23 = phi i1 [ true, %10 ], [ %21, %20 ]
  br i1 %23, label %24, label %68

24:                                               ; preds = %22
  call void @verification_loop_bound(i32 noundef 2)
  store i32 0, ptr %5, align 4
  br label %25

25:                                               ; preds = %41, %24
  %26 = load i32, ptr %5, align 4
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %37, label %28

28:                                               ; preds = %25
  %29 = load i32, ptr %5, align 4
  %30 = icmp eq i32 %29, 1
  br i1 %30, label %31, label %35

31:                                               ; preds = %28
  %32 = load i32, ptr %3, align 4
  %33 = add i32 %32, 1
  %34 = icmp ult i32 %33, 1
  br label %35

35:                                               ; preds = %31, %28
  %36 = phi i1 [ false, %28 ], [ %34, %31 ]
  br label %37

37:                                               ; preds = %35, %25
  %38 = phi i1 [ true, %25 ], [ %36, %35 ]
  br i1 %38, label %39, label %44

39:                                               ; preds = %37
  %40 = load i32, ptr %3, align 4
  call void @acquire(i32 noundef %40)
  call void @cs()
  br label %41

41:                                               ; preds = %39
  %42 = load i32, ptr %5, align 4
  %43 = add nsw i32 %42, 1
  store i32 %43, ptr %5, align 4
  br label %25, !llvm.loop !9

44:                                               ; preds = %37
  call void @verification_loop_bound(i32 noundef 2)
  store i32 0, ptr %6, align 4
  br label %45

45:                                               ; preds = %61, %44
  %46 = load i32, ptr %6, align 4
  %47 = icmp eq i32 %46, 0
  br i1 %47, label %57, label %48

48:                                               ; preds = %45
  %49 = load i32, ptr %6, align 4
  %50 = icmp eq i32 %49, 1
  br i1 %50, label %51, label %55

51:                                               ; preds = %48
  %52 = load i32, ptr %3, align 4
  %53 = add i32 %52, 1
  %54 = icmp ult i32 %53, 1
  br label %55

55:                                               ; preds = %51, %48
  %56 = phi i1 [ false, %48 ], [ %54, %51 ]
  br label %57

57:                                               ; preds = %55, %45
  %58 = phi i1 [ true, %45 ], [ %56, %55 ]
  br i1 %58, label %59, label %64

59:                                               ; preds = %57
  %60 = load i32, ptr %3, align 4
  call void @release(i32 noundef %60)
  br label %61

61:                                               ; preds = %59
  %62 = load i32, ptr %6, align 4
  %63 = add nsw i32 %62, 1
  store i32 %63, ptr %6, align 4
  br label %45, !llvm.loop !10

64:                                               ; preds = %57
  br label %65

65:                                               ; preds = %64
  %66 = load i32, ptr %4, align 4
  %67 = add nsw i32 %66, 1
  store i32 %67, ptr %4, align 4
  br label %10, !llvm.loop !11

68:                                               ; preds = %22
  ret ptr null
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @post() #0 {
  call void @vatomic32_write_rlx(ptr noundef @rand, i32 noundef 1)
  ret void
}

declare i32 @"\01_pthread_join"(ptr noundef, ptr noundef) #2

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomic32_write_rlx(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %4, align 4
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.vatomic32_s, ptr %6, i32 0, i32 0
  call void asm sideeffect " \0Astr $0, $1\0A \0A", "r,*Q,~{memory}"(i32 %5, ptr elementtype(i32) %7) #4, !srcloc !12
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @acquire(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  %4 = zext i32 %3 to i64
  %5 = getelementptr inbounds [4 x %struct.cna_node_s], ptr @nodes, i64 0, i64 %4
  %6 = load i32, ptr %2, align 4
  %7 = icmp ult i32 %6, 2
  %8 = zext i1 %7 to i32
  call void @cnalock_acquire(ptr noundef @lock, ptr noundef %5, i32 noundef %8)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @cnalock_acquire(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store i32 %2, ptr %6, align 4
  %8 = load ptr, ptr %5, align 8
  %9 = getelementptr inbounds %struct.cna_node_s, ptr %8, i32 0, i32 0
  call void @vatomicptr_write_rlx(ptr noundef %9, ptr noundef null)
  %10 = load ptr, ptr %5, align 8
  %11 = getelementptr inbounds %struct.cna_node_s, ptr %10, i32 0, i32 1
  call void @vatomicptr_write_rlx(ptr noundef %11, ptr noundef null)
  %12 = load ptr, ptr %5, align 8
  %13 = getelementptr inbounds %struct.cna_node_s, ptr %12, i32 0, i32 2
  call void @vatomic32_write_rlx(ptr noundef %13, i32 noundef -1)
  %14 = load ptr, ptr %4, align 8
  %15 = getelementptr inbounds %struct.cnalock_s, ptr %14, i32 0, i32 0
  %16 = load ptr, ptr %5, align 8
  %17 = call ptr @vatomicptr_xchg(ptr noundef %15, ptr noundef %16)
  store ptr %17, ptr %7, align 8
  %18 = load ptr, ptr %7, align 8
  %19 = icmp ne ptr %18, null
  br i1 %19, label %23, label %20

20:                                               ; preds = %3
  %21 = load ptr, ptr %5, align 8
  %22 = getelementptr inbounds %struct.cna_node_s, ptr %21, i32 0, i32 0
  call void @vatomicptr_write_rlx(ptr noundef %22, ptr noundef inttoptr (i64 1 to ptr))
  br label %33

23:                                               ; preds = %3
  %24 = load ptr, ptr %5, align 8
  %25 = getelementptr inbounds %struct.cna_node_s, ptr %24, i32 0, i32 2
  %26 = load i32, ptr %6, align 4
  call void @vatomic32_write_rlx(ptr noundef %25, i32 noundef %26)
  %27 = load ptr, ptr %7, align 8
  %28 = getelementptr inbounds %struct.cna_node_s, ptr %27, i32 0, i32 1
  %29 = load ptr, ptr %5, align 8
  call void @vatomicptr_write_rel(ptr noundef %28, ptr noundef %29)
  %30 = load ptr, ptr %5, align 8
  %31 = getelementptr inbounds %struct.cna_node_s, ptr %30, i32 0, i32 0
  %32 = call ptr @vatomicptr_await_neq_acq(ptr noundef %31, ptr noundef null)
  br label %33

33:                                               ; preds = %23, %20
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @release(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  %4 = zext i32 %3 to i64
  %5 = getelementptr inbounds [4 x %struct.cna_node_s], ptr @nodes, i64 0, i64 %4
  %6 = load i32, ptr %2, align 4
  %7 = icmp ult i32 %6, 2
  %8 = zext i1 %7 to i32
  call void @cnalock_release(ptr noundef @lock, ptr noundef %5, i32 noundef %8)
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @cnalock_release(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca ptr, align 8
  %12 = alloca ptr, align 8
  %13 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store i32 %2, ptr %6, align 4
  %14 = load ptr, ptr %5, align 8
  %15 = getelementptr inbounds %struct.cna_node_s, ptr %14, i32 0, i32 1
  %16 = call ptr @vatomicptr_read_acq(ptr noundef %15)
  store ptr %16, ptr %7, align 8
  %17 = load ptr, ptr %5, align 8
  %18 = getelementptr inbounds %struct.cna_node_s, ptr %17, i32 0, i32 0
  %19 = call ptr @vatomicptr_read_rlx(ptr noundef %18)
  store ptr %19, ptr %8, align 8
  %20 = load ptr, ptr %7, align 8
  %21 = icmp ne ptr %20, null
  br i1 %21, label %57, label %22

22:                                               ; preds = %3
  %23 = load ptr, ptr %8, align 8
  %24 = icmp eq ptr %23, inttoptr (i64 1 to ptr)
  br i1 %24, label %25, label %34

25:                                               ; preds = %22
  %26 = load ptr, ptr %4, align 8
  %27 = getelementptr inbounds %struct.cnalock_s, ptr %26, i32 0, i32 0
  %28 = load ptr, ptr %5, align 8
  %29 = call ptr @vatomicptr_cmpxchg_rel(ptr noundef %27, ptr noundef %28, ptr noundef null)
  %30 = load ptr, ptr %5, align 8
  %31 = icmp eq ptr %29, %30
  br i1 %31, label %32, label %33

32:                                               ; preds = %25
  br label %91

33:                                               ; preds = %25
  br label %53

34:                                               ; preds = %22
  %35 = load ptr, ptr %8, align 8
  store ptr %35, ptr %9, align 8
  %36 = load ptr, ptr %9, align 8
  %37 = getelementptr inbounds %struct.cna_node_s, ptr %36, i32 0, i32 1
  %38 = call ptr @vatomicptr_xchg_rlx(ptr noundef %37, ptr noundef null)
  store ptr %38, ptr %10, align 8
  %39 = load ptr, ptr %4, align 8
  %40 = getelementptr inbounds %struct.cnalock_s, ptr %39, i32 0, i32 0
  %41 = load ptr, ptr %5, align 8
  %42 = load ptr, ptr %9, align 8
  %43 = call ptr @vatomicptr_cmpxchg_rel(ptr noundef %40, ptr noundef %41, ptr noundef %42)
  %44 = load ptr, ptr %5, align 8
  %45 = icmp eq ptr %43, %44
  br i1 %45, label %46, label %49

46:                                               ; preds = %34
  %47 = load ptr, ptr %10, align 8
  %48 = getelementptr inbounds %struct.cna_node_s, ptr %47, i32 0, i32 0
  call void @vatomicptr_write_rel(ptr noundef %48, ptr noundef inttoptr (i64 1 to ptr))
  br label %91

49:                                               ; preds = %34
  %50 = load ptr, ptr %9, align 8
  %51 = getelementptr inbounds %struct.cna_node_s, ptr %50, i32 0, i32 1
  %52 = load ptr, ptr %10, align 8
  call void @vatomicptr_write_rlx(ptr noundef %51, ptr noundef %52)
  br label %53

53:                                               ; preds = %49, %33
  %54 = load ptr, ptr %5, align 8
  %55 = getelementptr inbounds %struct.cna_node_s, ptr %54, i32 0, i32 1
  %56 = call ptr @vatomicptr_await_neq_acq(ptr noundef %55, ptr noundef null)
  store ptr %56, ptr %7, align 8
  br label %57

57:                                               ; preds = %53, %3
  store ptr null, ptr %11, align 8
  store ptr inttoptr (i64 1 to ptr), ptr %12, align 8
  %58 = call i32 @_cnalock_keep_lock_local()
  store i32 %58, ptr %13, align 4
  %59 = load i32, ptr %13, align 4
  %60 = icmp ne i32 %59, 0
  br i1 %60, label %61, label %68

61:                                               ; preds = %57
  %62 = load ptr, ptr %5, align 8
  %63 = load i32, ptr %6, align 4
  %64 = call ptr @_cnalock_find_successor(ptr noundef %62, i32 noundef %63)
  store ptr %64, ptr %11, align 8
  %65 = load ptr, ptr %5, align 8
  %66 = getelementptr inbounds %struct.cna_node_s, ptr %65, i32 0, i32 0
  %67 = call ptr @vatomicptr_read_rlx(ptr noundef %66)
  store ptr %67, ptr %8, align 8
  br label %68

68:                                               ; preds = %61, %57
  %69 = load i32, ptr %13, align 4
  %70 = icmp ne i32 %69, 0
  br i1 %70, label %71, label %76

71:                                               ; preds = %68
  %72 = load ptr, ptr %11, align 8
  %73 = icmp ne ptr %72, null
  br i1 %73, label %74, label %76

74:                                               ; preds = %71
  %75 = load ptr, ptr %8, align 8
  store ptr %75, ptr %12, align 8
  br label %87

76:                                               ; preds = %71, %68
  %77 = load ptr, ptr %8, align 8
  %78 = icmp ugt ptr %77, inttoptr (i64 1 to ptr)
  br i1 %78, label %79, label %84

79:                                               ; preds = %76
  %80 = load ptr, ptr %8, align 8
  %81 = getelementptr inbounds %struct.cna_node_s, ptr %80, i32 0, i32 1
  %82 = load ptr, ptr %7, align 8
  %83 = call ptr @vatomicptr_xchg_rlx(ptr noundef %81, ptr noundef %82)
  store ptr %83, ptr %11, align 8
  br label %86

84:                                               ; preds = %76
  %85 = load ptr, ptr %7, align 8
  store ptr %85, ptr %11, align 8
  br label %86

86:                                               ; preds = %84, %79
  br label %87

87:                                               ; preds = %86, %74
  %88 = load ptr, ptr %11, align 8
  %89 = getelementptr inbounds %struct.cna_node_s, ptr %88, i32 0, i32 0
  %90 = load ptr, ptr %12, align 8
  call void @vatomicptr_write_rel(ptr noundef %89, ptr noundef %90)
  br label %91

91:                                               ; preds = %87, %46, %32
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomicptr_write_rlx(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.vatomicptr_s, ptr %6, i32 0, i32 0
  call void asm sideeffect " \0Astr $0, $1\0A \0A", "r,*Q,~{memory}"(ptr %5, ptr elementtype(ptr) %7) #4, !srcloc !13
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_xchg(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = load ptr, ptr %3, align 8
  %9 = getelementptr inbounds %struct.vatomicptr_s, ptr %8, i32 0, i32 0
  %10 = call { ptr, i32 } asm sideeffect "dmb ish \0A1:\0Aldrex $0, $3\0Astrex $1, $2, $3\0Acmp $1, #0 \0Abne 1b\0Admb ish \0A", "=&r,=&r,r,*Q,~{memory},~{cc}"(ptr %7, ptr elementtype(ptr) %9) #4, !srcloc !14
  %11 = extractvalue { ptr, i32 } %10, 0
  %12 = extractvalue { ptr, i32 } %10, 1
  store ptr %11, ptr %5, align 8
  store i32 %12, ptr %6, align 4
  %13 = load ptr, ptr %5, align 8
  ret ptr %13
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @vatomicptr_write_rel(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %5 = load ptr, ptr %4, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct.vatomicptr_s, ptr %6, i32 0, i32 0
  call void asm sideeffect "dmb ish \0Astr $0, $1\0A \0A", "r,*Q,~{memory}"(ptr %5, ptr elementtype(ptr) %7) #4, !srcloc !15
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_await_neq_acq(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  store ptr null, ptr %5, align 8
  call void @verification_loop_begin()
  br label %6

6:                                                ; preds = %20, %2
  call void @verification_spin_start()
  %7 = load ptr, ptr %3, align 8
  %8 = call ptr @vatomicptr_read_acq(ptr noundef %7)
  store ptr %8, ptr %5, align 8
  %9 = load ptr, ptr %5, align 8
  %10 = load ptr, ptr %4, align 8
  %11 = icmp eq ptr %9, %10
  br i1 %11, label %12, label %13

12:                                               ; preds = %6
  br label %14

13:                                               ; preds = %6
  call void @verification_spin_end(i32 noundef 1)
  br label %14

14:                                               ; preds = %13, %12
  %15 = phi i32 [ 1, %12 ], [ 0, %13 ]
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %17, label %21

17:                                               ; preds = %14
  br label %18

18:                                               ; preds = %17
  br label %19

19:                                               ; preds = %18
  br label %20

20:                                               ; preds = %19
  call void @verification_spin_end(i32 noundef 0)
  br label %6, !llvm.loop !16

21:                                               ; preds = %14
  %22 = load ptr, ptr %5, align 8
  ret ptr %22
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_loop_begin() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_spin_start() #0 {
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_read_acq(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomicptr_s, ptr %4, i32 0, i32 0
  %6 = call ptr asm sideeffect "ldr $0, $1 \0Admb ish\0A", "=&r,*Q,~{memory}"(ptr elementtype(ptr) %5) #4, !srcloc !17
  store ptr %6, ptr %3, align 8
  %7 = load ptr, ptr %3, align 8
  ret ptr %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal void @verification_spin_end(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  ret void
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_read_rlx(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomicptr_s, ptr %4, i32 0, i32 0
  %6 = call ptr asm sideeffect "ldr $0, $1 \0A\0A", "=&r,*Q,~{memory}"(ptr elementtype(ptr) %5) #4, !srcloc !18
  store ptr %6, ptr %3, align 8
  %7 = load ptr, ptr %3, align 8
  ret ptr %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_cmpxchg_rel(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  store ptr %0, ptr %4, align 8
  store ptr %1, ptr %5, align 8
  store ptr %2, ptr %6, align 8
  %9 = load ptr, ptr %6, align 8
  %10 = load ptr, ptr %5, align 8
  %11 = load ptr, ptr %4, align 8
  %12 = getelementptr inbounds %struct.vatomicptr_s, ptr %11, i32 0, i32 0
  %13 = call { ptr, i32 } asm sideeffect "dmb ish \0A1:\0Aldrex $0, $4\0Acmp $0, $3\0Abne 2f\0Astrex $1, $2, $4\0Acmp $1, #0 \0Abne 1b\0A2:\0A \0A", "=&r,=&r,r,r,*Q,~{memory},~{cc}"(ptr %9, ptr %10, ptr elementtype(ptr) %12) #4, !srcloc !19
  %14 = extractvalue { ptr, i32 } %13, 0
  %15 = extractvalue { ptr, i32 } %13, 1
  store ptr %14, ptr %7, align 8
  store i32 %15, ptr %8, align 4
  %16 = load ptr, ptr %7, align 8
  ret ptr %16
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @vatomicptr_xchg_rlx(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = load ptr, ptr %3, align 8
  %9 = getelementptr inbounds %struct.vatomicptr_s, ptr %8, i32 0, i32 0
  %10 = call { ptr, i32 } asm sideeffect " \0A1:\0Aldrex $0, $3\0Astrex $1, $2, $3\0Acmp $1, #0 \0Abne 1b\0A \0A", "=&r,=&r,r,*Q,~{memory},~{cc}"(ptr %7, ptr elementtype(ptr) %9) #4, !srcloc !20
  %11 = extractvalue { ptr, i32 } %10, 0
  %12 = extractvalue { ptr, i32 } %10, 1
  store ptr %11, ptr %5, align 8
  store i32 %12, ptr %6, align 4
  %13 = load ptr, ptr %5, align 8
  ret ptr %13
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @_cnalock_keep_lock_local() #0 {
  %1 = call i32 @vatomic32_read_rlx(ptr noundef @rand)
  ret i32 %1
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal ptr @_cnalock_find_successor(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca ptr, align 8
  %12 = alloca ptr, align 8
  store ptr %0, ptr %4, align 8
  store i32 %1, ptr %5, align 4
  %13 = load ptr, ptr %4, align 8
  %14 = getelementptr inbounds %struct.cna_node_s, ptr %13, i32 0, i32 1
  %15 = call ptr @vatomicptr_read_rlx(ptr noundef %14)
  store ptr %15, ptr %6, align 8
  %16 = load ptr, ptr %4, align 8
  %17 = getelementptr inbounds %struct.cna_node_s, ptr %16, i32 0, i32 2
  %18 = call i32 @vatomic32_read_rlx(ptr noundef %17)
  store i32 %18, ptr %7, align 4
  %19 = load i32, ptr %7, align 4
  %20 = icmp eq i32 %19, -1
  br i1 %20, label %21, label %23

21:                                               ; preds = %2
  %22 = load i32, ptr %5, align 4
  store i32 %22, ptr %7, align 4
  br label %23

23:                                               ; preds = %21, %2
  %24 = load ptr, ptr %6, align 8
  store ptr %24, ptr %8, align 8
  %25 = load ptr, ptr %6, align 8
  store ptr %25, ptr %9, align 8
  %26 = load ptr, ptr %6, align 8
  store ptr %26, ptr %10, align 8
  br label %27

27:                                               ; preds = %39, %23
  %28 = load ptr, ptr %10, align 8
  %29 = icmp ne ptr %28, null
  br i1 %29, label %30, label %36

30:                                               ; preds = %27
  %31 = load ptr, ptr %10, align 8
  %32 = getelementptr inbounds %struct.cna_node_s, ptr %31, i32 0, i32 2
  %33 = call i32 @vatomic32_read_rlx(ptr noundef %32)
  %34 = load i32, ptr %7, align 4
  %35 = icmp ne i32 %33, %34
  br label %36

36:                                               ; preds = %30, %27
  %37 = phi i1 [ false, %27 ], [ %35, %30 ]
  br i1 %37, label %38, label %44

38:                                               ; preds = %36
  br label %39

39:                                               ; preds = %38
  %40 = load ptr, ptr %10, align 8
  store ptr %40, ptr %9, align 8
  %41 = load ptr, ptr %10, align 8
  %42 = getelementptr inbounds %struct.cna_node_s, ptr %41, i32 0, i32 1
  %43 = call ptr @vatomicptr_read_acq(ptr noundef %42)
  store ptr %43, ptr %10, align 8
  br label %27, !llvm.loop !21

44:                                               ; preds = %36
  %45 = load ptr, ptr %10, align 8
  %46 = icmp ne ptr %45, null
  br i1 %46, label %48, label %47

47:                                               ; preds = %44
  store ptr null, ptr %3, align 8
  br label %74

48:                                               ; preds = %44
  %49 = load ptr, ptr %10, align 8
  %50 = load ptr, ptr %6, align 8
  %51 = icmp eq ptr %49, %50
  br i1 %51, label %52, label %54

52:                                               ; preds = %48
  %53 = load ptr, ptr %6, align 8
  store ptr %53, ptr %3, align 8
  br label %74

54:                                               ; preds = %48
  %55 = load ptr, ptr %4, align 8
  %56 = getelementptr inbounds %struct.cna_node_s, ptr %55, i32 0, i32 0
  %57 = call ptr @vatomicptr_read_rlx(ptr noundef %56)
  store ptr %57, ptr %11, align 8
  %58 = load ptr, ptr %11, align 8
  %59 = icmp ugt ptr %58, inttoptr (i64 1 to ptr)
  br i1 %59, label %60, label %66

60:                                               ; preds = %54
  %61 = load ptr, ptr %11, align 8
  %62 = getelementptr inbounds %struct.cna_node_s, ptr %61, i32 0, i32 1
  %63 = load ptr, ptr %8, align 8
  %64 = call ptr @vatomicptr_xchg_rlx(ptr noundef %62, ptr noundef %63)
  store ptr %64, ptr %12, align 8
  %65 = load ptr, ptr %12, align 8
  store ptr %65, ptr %8, align 8
  br label %66

66:                                               ; preds = %60, %54
  %67 = load ptr, ptr %9, align 8
  %68 = getelementptr inbounds %struct.cna_node_s, ptr %67, i32 0, i32 1
  %69 = load ptr, ptr %8, align 8
  call void @vatomicptr_write_rlx(ptr noundef %68, ptr noundef %69)
  %70 = load ptr, ptr %4, align 8
  %71 = getelementptr inbounds %struct.cna_node_s, ptr %70, i32 0, i32 0
  %72 = load ptr, ptr %9, align 8
  call void @vatomicptr_write_rlx(ptr noundef %71, ptr noundef %72)
  %73 = load ptr, ptr %10, align 8
  store ptr %73, ptr %3, align 8
  br label %74

74:                                               ; preds = %66, %52, %47
  %75 = load ptr, ptr %3, align 8
  ret ptr %75
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define internal i32 @vatomic32_read_rlx(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.vatomic32_s, ptr %4, i32 0, i32 0
  %6 = call i32 asm sideeffect "ldr $0, $1 \0A\0A", "=&r,*Q,~{memory}"(ptr elementtype(i32) %5) #4, !srcloc !22
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  ret i32 %7
}

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { cold noreturn "disable-tail-calls"="true" "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #3 = { cold noreturn }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 0]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Homebrew clang version 19.1.7"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = !{i64 940693, i64 940708, i64 940735}
!13 = !{i64 942105, i64 942120, i64 942147}
!14 = !{i64 947344, i64 947366, i64 947381, i64 947413, i64 947453, i64 947481, i64 947500}
!15 = !{i64 941629, i64 941651, i64 941678}
!16 = distinct !{!16, !7}
!17 = !{i64 938788, i64 938817}
!18 = !{i64 939279, i64 939308}
!19 = !{i64 957558, i64 957580, i64 957595, i64 957627, i64 957660, i64 957679, i64 957719, i64 957747, i64 957766, i64 957781}
!20 = !{i64 949379, i64 949394, i64 949409, i64 949441, i64 949481, i64 949509, i64 949528}
!21 = distinct !{!21, !7}
!22 = !{i64 936364, i64 936393}
