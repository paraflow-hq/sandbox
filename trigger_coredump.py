#!/usr/bin/env python3
"""触发 coredump 的测试脚本

用于验证 coredump 禁用配置是否生效。
"""

import os
import signal
import sys


def method1_sigsegv() -> None:
    """方法 1: 使用 SIGSEGV 信号触发段错误"""
    print("方法 1: 发送 SIGSEGV 信号...")
    os.kill(os.getpid(), signal.SIGSEGV)


def method2_null_pointer() -> None:
    """方法 2: 使用 ctypes 访问空指针"""
    print("方法 2: 访问空指针...")
    import ctypes
    ctypes.string_at(0)  # 访问空指针


def method3_abort() -> None:
    """方法 3: 调用 abort() 函数"""
    print("方法 3: 调用 abort()...")
    import ctypes
    libc = ctypes.CDLL("libc.so.6")
    libc.abort()


def method4_c_program() -> None:
    """方法 4: 编译并运行一个简单的 C 程序"""
    print("方法 4: 编译并运行 C 程序...")
    c_code = """
#include <stdio.h>
int main() {
    int *p = NULL;
    *p = 42;  // 解引用空指针
    return 0;
}
"""
    with open("/tmp/test_coredump.c", "w") as f:
        f.write(c_code)
    
    os.system("gcc -o /tmp/test_coredump /tmp/test_coredump.c && /tmp/test_coredump")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法: python trigger_coredump.py <method>")
        print("\n可用方法:")
        print("  1 - SIGSEGV 信号 (推荐)")
        print("  2 - 访问空指针")
        print("  3 - abort() 函数 (推荐)")
        print("  4 - C 程序段错误")
        sys.exit(1)
    
    method = sys.argv[1]
    
    print(f"当前 ulimit -c: {os.popen('ulimit -c').read().strip()}")
    print(f"kernel.core_pattern: {os.popen('sysctl kernel.core_pattern').read().strip()}\n")
    
    try:
        if method == "1":
            method1_sigsegv()
        elif method == "2":
            method2_null_pointer()
        elif method == "3":
            method3_abort()
        elif method == "4":
            method4_c_program()
        else:
            print(f"未知方法: {method}")
            sys.exit(1)
    except Exception as e:
        print(f"异常: {e}")
    
    print("\n检查是否生成了 coredump 文件...")
    os.system("ls -la /core* 2>&1 || echo '未找到 coredump 文件'")

