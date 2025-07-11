// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XCOLOR_CONVERT_H
#define XCOLOR_CONVERT_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xcolor_convert_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u64 Control_BaseAddress;
} XColor_convert_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XColor_convert;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XColor_convert_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XColor_convert_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XColor_convert_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XColor_convert_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XColor_convert_Initialize(XColor_convert *InstancePtr, u16 DeviceId);
XColor_convert_Config* XColor_convert_LookupConfig(u16 DeviceId);
int XColor_convert_CfgInitialize(XColor_convert *InstancePtr, XColor_convert_Config *ConfigPtr);
#else
int XColor_convert_Initialize(XColor_convert *InstancePtr, const char* InstanceName);
int XColor_convert_Release(XColor_convert *InstancePtr);
#endif


void XColor_convert_Set_c1_c1(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_c1_c1(XColor_convert *InstancePtr);
void XColor_convert_Set_c1_c2(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_c1_c2(XColor_convert *InstancePtr);
void XColor_convert_Set_c1_c3(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_c1_c3(XColor_convert *InstancePtr);
void XColor_convert_Set_c2_c1(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_c2_c1(XColor_convert *InstancePtr);
void XColor_convert_Set_c2_c2(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_c2_c2(XColor_convert *InstancePtr);
void XColor_convert_Set_c2_c3(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_c2_c3(XColor_convert *InstancePtr);
void XColor_convert_Set_c3_c1(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_c3_c1(XColor_convert *InstancePtr);
void XColor_convert_Set_c3_c2(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_c3_c2(XColor_convert *InstancePtr);
void XColor_convert_Set_c3_c3(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_c3_c3(XColor_convert *InstancePtr);
void XColor_convert_Set_bias_c1(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_bias_c1(XColor_convert *InstancePtr);
void XColor_convert_Set_bias_c2(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_bias_c2(XColor_convert *InstancePtr);
void XColor_convert_Set_bias_c3(XColor_convert *InstancePtr, u32 Data);
u32 XColor_convert_Get_bias_c3(XColor_convert *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
