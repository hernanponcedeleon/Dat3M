; ModuleID = 'a.bc'
source_filename = "alignment5-array-global.cl"
target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spir-unknown-unknown"

@aligned = dso_local addrspace(1) global [3 x [3 x <3 x i32>]] zeroinitializer, align 64
@unaligned = dso_local addrspace(1) global [3 x [3 x [3 x i32]]] zeroinitializer, align 4

; Function Attrs: convergent noinline norecurse nounwind optnone
define dso_local spir_kernel void @test(i32 addrspace(1)* noundef %r_aligned, i32 addrspace(1)* noundef %r_unaligned) #0 !kernel_arg_addr_space !4 !kernel_arg_access_qual !5 !kernel_arg_type !6 !kernel_arg_base_type !6 !kernel_arg_type_qual !7 {
entry:
  %r_aligned.addr = alloca i32 addrspace(1)*, align 4
  %r_unaligned.addr = alloca i32 addrspace(1)*, align 4
  %i = alloca i32, align 4
  store i32 addrspace(1)* %r_aligned, i32 addrspace(1)** %r_aligned.addr, align 4
  store i32 addrspace(1)* %r_unaligned, i32 addrspace(1)** %r_unaligned.addr, align 4
  %0 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 0), align 64
  %vecins = insertelement <3 x i32> %0, i32 0, i32 0
  store <3 x i32> %vecins, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 0), align 64
  %1 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 0), align 64
  %vecins1 = insertelement <3 x i32> %1, i32 1, i32 1
  store <3 x i32> %vecins1, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 0), align 64
  %2 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 0), align 64
  %vecins2 = insertelement <3 x i32> %2, i32 2, i32 2
  store <3 x i32> %vecins2, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 0), align 64
  %3 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 1), align 16
  %vecins3 = insertelement <3 x i32> %3, i32 3, i32 0
  store <3 x i32> %vecins3, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 1), align 16
  %4 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 1), align 16
  %vecins4 = insertelement <3 x i32> %4, i32 4, i32 1
  store <3 x i32> %vecins4, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 1), align 16
  %5 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 1), align 16
  %vecins5 = insertelement <3 x i32> %5, i32 5, i32 2
  store <3 x i32> %vecins5, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 1), align 16
  %6 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 2), align 32
  %vecins6 = insertelement <3 x i32> %6, i32 6, i32 0
  store <3 x i32> %vecins6, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 2), align 32
  %7 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 2), align 32
  %vecins7 = insertelement <3 x i32> %7, i32 7, i32 1
  store <3 x i32> %vecins7, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 2), align 32
  %8 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 2), align 32
  %vecins8 = insertelement <3 x i32> %8, i32 8, i32 2
  store <3 x i32> %vecins8, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 2), align 32
  %9 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 0), align 16
  %vecins9 = insertelement <3 x i32> %9, i32 9, i32 0
  store <3 x i32> %vecins9, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 0), align 16
  %10 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 0), align 16
  %vecins10 = insertelement <3 x i32> %10, i32 10, i32 1
  store <3 x i32> %vecins10, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 0), align 16
  %11 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 0), align 16
  %vecins11 = insertelement <3 x i32> %11, i32 11, i32 2
  store <3 x i32> %vecins11, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 0), align 16
  %12 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 1), align 16
  %vecins12 = insertelement <3 x i32> %12, i32 12, i32 0
  store <3 x i32> %vecins12, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 1), align 16
  %13 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 1), align 16
  %vecins13 = insertelement <3 x i32> %13, i32 13, i32 1
  store <3 x i32> %vecins13, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 1), align 16
  %14 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 1), align 16
  %vecins14 = insertelement <3 x i32> %14, i32 14, i32 2
  store <3 x i32> %vecins14, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 1), align 16
  %15 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 2), align 16
  %vecins15 = insertelement <3 x i32> %15, i32 15, i32 0
  store <3 x i32> %vecins15, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 2), align 16
  %16 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 2), align 16
  %vecins16 = insertelement <3 x i32> %16, i32 16, i32 1
  store <3 x i32> %vecins16, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 2), align 16
  %17 = load <3 x i32>, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 2), align 16
  %vecins17 = insertelement <3 x i32> %17, i32 17, i32 2
  store <3 x i32> %vecins17, <3 x i32> addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 1, i32 2), align 16
  store i32 18, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 0, i32 0, i32 0), align 4
  store i32 19, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 0, i32 0, i32 1), align 4
  store i32 20, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 0, i32 0, i32 2), align 4
  store i32 21, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 0, i32 1, i32 0), align 4
  store i32 22, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 0, i32 1, i32 1), align 4
  store i32 23, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 0, i32 1, i32 2), align 4
  store i32 24, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 0, i32 2, i32 0), align 4
  store i32 25, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 0, i32 2, i32 1), align 4
  store i32 26, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 0, i32 2, i32 2), align 4
  store i32 27, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 1, i32 0, i32 0), align 4
  store i32 28, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 1, i32 0, i32 1), align 4
  store i32 29, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 1, i32 0, i32 2), align 4
  store i32 30, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 1, i32 1, i32 0), align 4
  store i32 31, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 1, i32 1, i32 1), align 4
  store i32 32, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 1, i32 1, i32 2), align 4
  store i32 33, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 1, i32 2, i32 0), align 4
  store i32 34, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 1, i32 2, i32 1), align 4
  store i32 35, i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 1, i32 2, i32 2), align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %18 = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %18, 64
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %19 = load i32, i32* %i, align 4
  %add.ptr = getelementptr inbounds i32, i32 addrspace(4)* addrspacecast (i32 addrspace(1)* getelementptr inbounds ([3 x [3 x <3 x i32>]], [3 x [3 x <3 x i32>]] addrspace(1)* @aligned, i32 0, i32 0, i32 0, i32 0) to i32 addrspace(4)*), i32 %19
  %20 = load i32, i32 addrspace(4)* %add.ptr, align 4
  %21 = load i32 addrspace(1)*, i32 addrspace(1)** %r_aligned.addr, align 4
  %22 = load i32, i32* %i, align 4
  %arrayidx = getelementptr inbounds i32, i32 addrspace(1)* %21, i32 %22
  store i32 %20, i32 addrspace(1)* %arrayidx, align 4
  %23 = load i32, i32* %i, align 4
  %add.ptr18 = getelementptr inbounds i32, i32 addrspace(4)* addrspacecast (i32 addrspace(1)* getelementptr inbounds ([3 x [3 x [3 x i32]]], [3 x [3 x [3 x i32]]] addrspace(1)* @unaligned, i32 0, i32 0, i32 0, i32 0) to i32 addrspace(4)*), i32 %23
  %24 = load i32, i32 addrspace(4)* %add.ptr18, align 4
  %25 = load i32 addrspace(1)*, i32 addrspace(1)** %r_unaligned.addr, align 4
  %26 = load i32, i32* %i, align 4
  %arrayidx19 = getelementptr inbounds i32, i32 addrspace(1)* %25, i32 %26
  store i32 %24, i32 addrspace(1)* %arrayidx19, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %27 = load i32, i32* %i, align 4
  %inc = add nsw i32 %27, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

attributes #0 = { convergent noinline norecurse nounwind optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "uniform-work-group-size"="false" }

!llvm.module.flags = !{!0, !1}
!opencl.ocl.version = !{!2}
!opencl.spir.version = !{!2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"frame-pointer", i32 2}
!2 = !{i32 2, i32 0}
!3 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!4 = !{i32 1, i32 1}
!5 = !{!"none", !"none"}
!6 = !{!"int*", !"int*"}
!7 = !{!"", !""}
