// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XPIXEL_UNPACK_H
#define XPIXEL_UNPACK_H

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
#include "xpixel_unpack_hw.h"

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
} XPixel_unpack_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XPixel_unpack;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XPixel_unpack_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XPixel_unpack_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XPixel_unpack_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XPixel_unpack_ReadReg(BaseAddress, RegOffset) \
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
int XPixel_unpack_Initialize(XPixel_unpack *InstancePtr, u16 DeviceId);
XPixel_unpack_Config* XPixel_unpack_LookupConfig(u16 DeviceId);
int XPixel_unpack_CfgInitialize(XPixel_unpack *InstancePtr, XPixel_unpack_Config *ConfigPtr);
#else
int XPixel_unpack_Initialize(XPixel_unpack *InstancePtr, const char* InstanceName);
int XPixel_unpack_Release(XPixel_unpack *InstancePtr);
#endif


void XPixel_unpack_Set_mode(XPixel_unpack *InstancePtr, u32 Data);
u32 XPixel_unpack_Get_mode(XPixel_unpack *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
